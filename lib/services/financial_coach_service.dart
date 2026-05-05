import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/transaction.dart';
import 'spending_analytics_service.dart';

// ── Message model ────────────────────────────────────────────────────────────

enum MessageRole { user, coach }

class CoachMessage {
  final String text;
  final MessageRole role;
  final DateTime timestamp;

  const CoachMessage({
    required this.text,
    required this.role,
    required this.timestamp,
  });
}

// ── Instant tip ──────────────────────────────────────────────────────────────

class InstantTip {
  final String message;
  final String icon;  // emoji
  final bool isWarning;

  const InstantTip({
    required this.message,
    required this.icon,
    required this.isWarning,
  });
}

// ── Service ──────────────────────────────────────────────────────────────────

class FinancialCoachService {
  static const String _systemPrompt =
      'You are a personal finance coach for a Pakistani user. '
      'Currency is PKR. Give short, specific, actionable advice in 2-3 sentences. '
      'Be friendly and motivating. If they overspend on food, suggest local cheaper '
      'alternatives (e.g. home cooking, dhabas). Do not give generic tips. '
      'Always keep PKR as the currency unit.';

  late final GenerativeModel _model;
  late final ChatSession _chat;
  bool _ready = false;

  FinancialCoachService() {
    final key = dotenv.env['GEMINI_API_KEY'] ?? '';
    if (key.isNotEmpty && key != 'YOUR_API_KEY') {
      _model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: key,
        systemInstruction: Content.system(_systemPrompt),
        generationConfig: GenerationConfig(
          temperature: 0.7,
          maxOutputTokens: 200,
        ),
      );
      _chat = _model.startChat();
      _ready = true;
    }
  }

  // ── 1. Build financial context string ─────────────────────────────────────

  /// Summarises user finances into a compact JSON string injected into prompts.
  String buildFinancialContext({
    required List<FinancialTransaction> transactions,
    Map<String, double> budgets = const {},
  }) {
    final now = DateTime.now();

    // Monthly category totals (current month)
    final Map<String, double> monthlySpend = {};
    double totalMonthly = 0;
    for (final t in transactions) {
      if (t.type != 'expense') continue;
      if (t.date.year != now.year || t.date.month != now.month) continue;
      monthlySpend[t.category] = (monthlySpend[t.category] ?? 0) + t.amount;
      totalMonthly += t.amount;
    }

    // All-time income estimate
    final totalIncome = transactions
        .where((t) => t.type == 'income')
        .fold(0.0, (s, t) => s + t.amount);

    // Top 3 recurring expenses
    final recurringSvc = SpendingAnalyticsService();
    final recurring = recurringSvc
        .detectRecurringExpenses(transactions)
        .take(3)
        .map((r) => {'name': r.name, 'pkr': r.estimatedMonthlyAmount.round()})
        .toList();

    // Budget status
    final budgetStatus = <String, Map<String, dynamic>>{};
    for (final entry in budgets.entries) {
      final spent = monthlySpend[entry.key] ?? 0;
      budgetStatus[entry.key] = {
        'budget': entry.value.round(),
        'spent': spent.round(),
        'over': spent > entry.value,
      };
    }

    final ctx = {
      'month_spend_pkr': monthlySpend
          .map((k, v) => MapEntry(k, v.round())),
      'total_monthly_pkr': totalMonthly.round(),
      'total_income_pkr': totalIncome.round(),
      'top_recurring': recurring,
      'budget_status': budgetStatus,
    };

    return jsonEncode(ctx);
  }

  // ── 2. Send message to Gemini ─────────────────────────────────────────────

  Future<String> sendMessage({
    required String userMessage,
    required List<FinancialTransaction> transactions,
    Map<String, double> budgets = const {},
  }) async {
    if (!_ready) {
      return _ruleBasedFallback(transactions, budgets, userMessage);
    }

    final ctx = buildFinancialContext(
        transactions: transactions, budgets: budgets);
    final fullPrompt =
        'User financial context (JSON): $ctx\n\nUser question: $userMessage';

    try {
      final response = await _chat.sendMessage(Content.text(fullPrompt));
      final text = response.text?.trim() ?? '';
      return text.isNotEmpty
          ? text
          : _ruleBasedFallback(transactions, budgets, userMessage);
    } catch (e) {
      return _ruleBasedFallback(transactions, budgets, userMessage);
    }
  }

  // ── 3. Rule-based instant tips (no API needed) ────────────────────────────

  List<InstantTip> getInstantTips({
    required List<FinancialTransaction> transactions,
    Map<String, double> budgets = const {},
    double monthlyIncome = 0,
  }) {
    final now = DateTime.now();
    final List<InstantTip> tips = [];

    // Current-month expenses
    final Map<String, double> monthlySpend = {};
    double totalExpense = 0;
    for (final t in transactions) {
      if (t.type != 'expense') continue;
      if (t.date.year != now.year || t.date.month != now.month) continue;
      monthlySpend[t.category] = (monthlySpend[t.category] ?? 0) + t.amount;
      totalExpense += t.amount;
    }

    // Rule 1: Food > 40% of total spending
    final foodSpend = monthlySpend['Food'] ?? 0;
    if (totalExpense > 0 && foodSpend / totalExpense > 0.40) {
      final pct = ((foodSpend / totalExpense) * 100).toStringAsFixed(0);
      tips.add(InstantTip(
        icon: '🍽️',
        message:
            'You\'re spending $pct% of your budget on food — that\'s too high. '
            'Try cooking at home or switch to local dhabas to cut costs.',
        isWarning: true,
      ));
    }

    // Rule 2: Any category exceeds its budget
    for (final entry in budgets.entries) {
      final spent = monthlySpend[entry.key] ?? 0;
      if (spent > entry.value) {
        final over = _fmt(spent - entry.value);
        tips.add(InstantTip(
          icon: '⚠️',
          message:
              'Budget exceeded in ${entry.key} by PKR $over this month. '
              'Consider reducing discretionary spending in this area.',
          isWarning: true,
        ));
      }
    }

    // Rule 3: Savings < 10% of income
    if (monthlyIncome > 0) {
      final savings = monthlyIncome - totalExpense;
      final savingsPct = savings / monthlyIncome;
      if (savingsPct < 0.10) {
        final target = _fmt(monthlyIncome * 0.10);
        tips.add(InstantTip(
          icon: '💰',
          message:
              'You\'re saving less than 10% of your income this month. '
              'Aim to set aside at least PKR $target — even small consistent '
              'savings build financial security over time.',
          isWarning: savingsPct < 0,
        ));
      }
    }

    // Positive tip if no warnings
    if (tips.isEmpty && totalExpense > 0) {
      tips.add(InstantTip(
        icon: '✅',
        message: 'Your spending looks healthy this month! '
            'Keep tracking to maintain momentum.',
        isWarning: false,
      ));
    }

    return tips;
  }

  // ── Latest coach tip (for home screen card) ───────────────────────────────

  Future<String> getLatestTip({
    required List<FinancialTransaction> transactions,
    Map<String, double> budgets = const {},
    double monthlyIncome = 0,
  }) async {
    // Try rule-based first for speed
    final tips = getInstantTips(
      transactions: transactions,
      budgets: budgets,
      monthlyIncome: monthlyIncome,
    );
    if (tips.isNotEmpty) return tips.first.message;

    // Fallback to Gemini
    return sendMessage(
      userMessage: 'Give me one personalised financial tip for this month.',
      transactions: transactions,
      budgets: budgets,
    );
  }

  // ── Quick question prompts ────────────────────────────────────────────────

  static List<String> get quickQuestions => const [
        'How can I save more?',
        'Where am I overspending?',
        'My budget status',
        'Top 3 tips for this month',
        'How to cut food expenses?',
      ];

  // ── Helpers ───────────────────────────────────────────────────────────────

  String _ruleBasedFallback(
    List<FinancialTransaction> transactions,
    Map<String, double> budgets,
    String question,
  ) {
    final tips = getInstantTips(transactions: transactions, budgets: budgets);
    if (tips.isNotEmpty) return tips.first.message;

    final q = question.toLowerCase();
    if (q.contains('save') || q.contains('saving')) {
      return 'Try the 50/30/20 rule: 50% needs, 30% wants, 20% savings. '
          'Even saving PKR 1,000 a month adds up to PKR 12,000 a year!';
    }
    if (q.contains('food') || q.contains('eat')) {
      return 'Switch 2 meals a week to home-cooked daal-chawal — '
          'you can save PKR 3,000-5,000 a month easily.';
    }
    if (q.contains('budget')) {
      return 'Set a fixed budget for each category at the start of the month. '
          'Use the Budget tab to track your limits and stay on target.';
    }
    return 'Track every expense, even small ones like chai or rickshaw fares — '
        'they add up to thousands monthly without you noticing.';
  }

  String _fmt(double v) => v
      .toStringAsFixed(0)
      .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');
}
