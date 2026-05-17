import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../app_constants.dart';
import '../models/budget_plan.dart';
import '../models/saving_goal.dart';
import '../models/transaction.dart';
import '../utils/currency_utils.dart';

class AIConfigurationException implements Exception {
  AIConfigurationException(this.message);

  final String message;

  @override
  String toString() => message;
}

class AIService {
  AIService({String? apiKey, String? modelName})
    : _apiKey = apiKey?.trim().isNotEmpty == true
          ? apiKey!.trim()
          : dotenv.env['GEMINI_API_KEY']?.trim() ?? '',
      _modelName = modelName?.trim().isNotEmpty == true
          ? modelName!.trim()
          : dotenv.env['GEMINI_MODEL']?.trim().isNotEmpty == true
          ? dotenv.env['GEMINI_MODEL']!.trim()
          : AppConstants.geminiModel {
    if (_apiKey.isNotEmpty) {
      _model = GenerativeModel(model: _modelName, apiKey: _apiKey);
    }
  }

  final String _apiKey;
  final String _modelName;
  GenerativeModel? _model;

<<<<<<< HEAD
  bool get isConfigured => _apiKey.isNotEmpty;
=======
  Future<String> getBudgetAdvice(List<FinancialTransaction> transactions) async {
    if (!_useRealAI || transactions.isEmpty) {
      return _mockBudgetAdvice(transactions);
    }
    final prompt = '''You are a professional financial advisor AI. Analyze these recent transactions and provide exactly 3 concise, actionable insights in bullet points. Focus on savings opportunities and unusual patterns.

Transactions: ${transactions.take(20).map((t) => '${t.title}(PKR${t.amount.toStringAsFixed(0)}, ${t.category}, ${t.type})').join('; ')}

Format: Start each point with • and keep each under 25 words. Be specific.''';
>>>>>>> c281882508291f62fb38dea4bf5b14544423a4e3

  Future<void> validateConfiguration() async {
    _ensureConfigured();
    try {
      final response = await _model!.generateContent([
        Content.text('Reply with exactly: OK'),
      ]);
      final text = response.text?.trim();
      if (text == null || text.isEmpty) {
        throw AIConfigurationException(
          'The chatbot API key was accepted but returned an empty response.',
        );
      }
    } catch (error) {
      if (error is AIConfigurationException) rethrow;
      throw AIConfigurationException(
        'Invalid or inactive chatbot API key. Update GEMINI_API_KEY in .env and restart FinEase.',
      );
    }
  }

<<<<<<< HEAD
  void _ensureConfigured() {
    if (!isConfigured || _model == null) {
      throw AIConfigurationException(
        'AI is not configured. Add a valid GEMINI_API_KEY in .env and restart FinEase.',
      );
    }
=======
  String _mockBudgetAdvice(List<FinancialTransaction> transactions) {
    final totalExpense = transactions
        .where((t) => t.type == 'expense')
        .fold(0.0, (sum, t) => sum + t.amount);
    final topCategory = _getTopCategory(transactions);

    return '''• Your top spending category is **$topCategory** — consider setting a monthly cap to avoid overspending.\n\n• You've spent PKR${totalExpense.toStringAsFixed(0)} this month. The 50/30/20 rule suggests allocating 20% (PKR${(totalExpense * 0.2).toStringAsFixed(0)}) to savings.\n\n• Automate savings transfers on payday to build wealth consistently without relying on willpower.''';
>>>>>>> c281882508291f62fb38dea4bf5b14544423a4e3
  }

  Future<String> getBudgetAdvice(
    List<FinancialTransaction> transactions,
  ) async {
    if (transactions.isEmpty) {
      return 'Add this month\'s income and expenses first so the AI Budget Advisor can analyze real financial activity.';
    }

    final prompt =
        '''
You are FinEase AI Budget Advisor for users in Pakistan.
Return exactly 3 concise bullet points using PKR amounts.
Analyze only the real current-month transactions below.
Focus on savings, unusual spending, and one specific action for this month.
Transactions:
${transactions.take(60).map((t) => '${t.title} | ${t.type} | ${t.category} | ${CurrencyUtils.format(t.amount)} | ${t.date.toIso8601String()}').join('\n')}
''';

    return _generate(prompt);
  }

  Future<List<Map<String, dynamic>>> detectUnusualSpending(
    List<FinancialTransaction> transactions,
  ) async {
    final categorySpending = <String, List<double>>{};
    for (final transaction in transactions.where((t) => t.type == 'expense')) {
      categorySpending
          .putIfAbsent(transaction.category, () => [])
          .add(transaction.amount);
    }

    final anomalies = <Map<String, dynamic>>[];
    for (final entry in categorySpending.entries) {
      if (entry.value.length < 2) continue;
      final average = entry.value.reduce((a, b) => a + b) / entry.value.length;
      final highest = entry.value.reduce((a, b) => a > b ? a : b);
      if (highest >= average * 1.45) {
        anomalies.add({
          'category': entry.key,
          'amount': highest,
          'average': average,
          'overspent': highest - average,
        });
      }
    }

    anomalies.sort(
      (a, b) => (b['overspent'] as double).compareTo(a['overspent'] as double),
    );
    return anomalies.take(4).toList();
  }

  Future<String> getSavingsInsight(List<SavingGoal> goals) async {
    if (goals.isEmpty) {
<<<<<<< HEAD
      return 'Create at least one savings goal first so the AI Finance Coach can generate personalized guidance.';
=======
      return 'Start by creating your first savings goal! Even saving PKR50/month adds up to PKR600/year — the foundation of financial freedom.';
>>>>>>> c281882508291f62fb38dea4bf5b14544423a4e3
    }

    final prompt =
        '''
You are FinEase AI Finance Coach.
Return exactly 2 concrete bullet points using PKR amounts.
Base advice only on these real savings goals:
${goals.map((goal) => '${goal.title}: ${CurrencyUtils.format(goal.currentAmount)} / ${CurrencyUtils.format(goal.targetAmount)} due ${goal.targetDate.toIso8601String()}').join('\n')}
''';

<<<<<<< HEAD
    return _generate(prompt);
=======
    final prompt = '''You are a savings advisor. Analyze these goals and provide 2 tips to accelerate savings:
Goals: ${goals.map((g) => '${g.title}: PKR${g.currentAmount.toStringAsFixed(0)}/PKR${g.targetAmount.toStringAsFixed(0)} (${(g.progress * 100).toStringAsFixed(0)}%)').join('; ')}
Keep each tip under 20 words, start with •.''';

    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      return response.text ?? _mockSavingsInsight(goals);
    } catch (e) {
      return _mockSavingsInsight(goals);
    }
>>>>>>> c281882508291f62fb38dea4bf5b14544423a4e3
  }

  Future<String> getInvestmentSuggestions(
    List<SavingGoal> goals,
    double totalSaved,
  ) async {
    final prompt =
        '''
Act as a conservative personal finance coach in Pakistan.
Return exactly 3 beginner-friendly investment or savings suggestions.
Mention risk briefly. Do not recommend individual stocks.
Total saved: ${CurrencyUtils.format(totalSaved)}
Goals: ${goals.map((goal) => goal.title).join(', ')}
''';

<<<<<<< HEAD
    return _generate(prompt);
=======
    return '''• Save PKR${perDay.toStringAsFixed(2)}/day to reach "${nearestGoal.title}" on time — try a daily coffee-brew habit instead of café visits.\n\n• Round-up micro-savings: every purchase rounded to the next dollar, automatically saved. Small amounts build big momentum.''';
  }

  // --------------- Investment Suggestions ---------------

  Future<String> getInvestmentSuggestions(List<SavingGoal> goals, double totalSaved) async {
    if (!_useRealAI) {
      return _mockInvestmentSuggestions(totalSaved);
    }

    final prompt = '''As a financial advisor, suggest 3 investment opportunities for someone with PKR${totalSaved.toStringAsFixed(0)} in savings and goals: ${goals.map((g) => g.title).join(', ')}. Be specific and practical. Format as • bullet points under 20 words each.''';

    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      return response.text ?? _mockInvestmentSuggestions(totalSaved);
    } catch (e) {
      return _mockInvestmentSuggestions(totalSaved);
    }
  }

  String _mockInvestmentSuggestions(double saved) {
    if (saved < 500) {
      return '''• Start a high-yield savings account (4–5% APY) — better than a standard bank account.\n\n• Try fractional share investing: buy partial stocks in companies you believe in for as little as PKR1.\n\n• Look into micro-investment apps that round up purchases and invest the spare change automatically.''';
    } else if (saved < 5000) {
      return '''• Index funds (S&P 500 ETFs) offer broad market exposure with low fees — ideal for beginners.\n\n• Consider a Roth IRA: tax-free growth with PKR7,000 annual contribution limit for 2024.\n\n• Treasury I-Bonds provide inflation-protected government-backed returns with zero risk.''';
    } else {
      return '''• Diversify into REITs for real estate exposure without buying property — average 8–12% returns.\n\n• Explore a 3-fund portfolio: US stocks, international stocks, and bonds for balanced growth.\n\n• With PKR${saved.toStringAsFixed(0)} saved, consider consulting a fee-only financial advisor for a personalized wealth plan.''';
    }
  }

  // --------------- Helpers ---------------

  String _getTopCategory(List<FinancialTransaction> transactions) {
    final Map<String, double> totals = {};
    for (final t in transactions.where((t) => t.type == 'expense')) {
      totals[t.category] = (totals[t.category] ?? 0) + t.amount;
    }
    if (totals.isEmpty) return 'General';
    return totals.entries.reduce((a, b) => a.value > b.value ? a : b).key;
>>>>>>> c281882508291f62fb38dea4bf5b14544423a4e3
  }

  Future<String> getGoalImprovementTips(SavingGoal goal) async {
    final remaining = goal.remaining;
    final daysLeft = goal.daysLeft <= 0 ? 1 : goal.daysLeft;
    final prompt =
        '''
Give one practical sentence under 28 words to improve this savings goal.
Use PKR and this exact data:
Goal: ${goal.title}
Progress: ${(goal.progress * 100).round()}%
Remaining: ${CurrencyUtils.format(remaining)}
Days left: $daysLeft
''';

<<<<<<< HEAD
    return _generate(prompt);
  }

  Future<String> getBudgetPlanRecommendations(
    List<BudgetPlan> budgets,
    List<FinancialTransaction> transactions,
  ) async {
    if (budgets.isEmpty) {
      return 'Create category budgets first, then FinEase AI can compare planned amounts against your real spending.';
    }

    final budgetLines = budgets
        .map(
          (budget) =>
              '${budget.title} | ${budget.category} | allocated ${CurrencyUtils.format(budget.allocatedAmount)}',
        )
        .join('\n');
    final transactionLines = transactions
        .take(50)
        .map(
          (tx) =>
              '${tx.category} | ${tx.type} | ${CurrencyUtils.format(tx.amount)}',
        )
        .join('\n');

    final prompt =
        '''
You are the FinEase AI Budget Advisor.
Return exactly 3 bullet points.
Each bullet must mention one practical action tied to the user's current-month budget plans.
Use PKR and do not invent missing data.
Budgets:
$budgetLines

Transactions:
$transactionLines
''';

    return _generate(prompt);
  }

  Future<String> generalFinancialAnswer(String question) {
    final prompt =
        '''
You are FinEase AI Chatbot, a general financial Q&A assistant for Pakistan.
Answer the user's question clearly with practical PKR examples where relevant.
Do not pretend to know the user's personal balances unless supplied.
Question: $question
''';
    return _generate(prompt);
  }

  Future<String> personalizedCoachAnswer({
    required String question,
    required List<FinancialTransaction> transactions,
    required List<BudgetPlan> budgets,
    required List<SavingGoal> goals,
  }) {
    final prompt =
        '''
You are FinEase AI Finance Coach.
Give personalized budgeting, savings, spending analysis, and recommendations using only the user's real data below.
If data is missing, say exactly what is needed.
Question: $question

Budgets:
${budgets.map((b) => '${b.category}: ${CurrencyUtils.format(b.allocatedAmount)}').join('\n')}

Savings goals:
${goals.map((g) => '${g.title}: ${CurrencyUtils.format(g.currentAmount)} of ${CurrencyUtils.format(g.targetAmount)}').join('\n')}

Transactions:
${transactions.take(80).map((t) => '${t.type} | ${t.category} | ${CurrencyUtils.format(t.amount)} | ${t.title}').join('\n')}
''';
    return _generate(prompt);
  }

  Future<String> _generate(String prompt) async {
    _ensureConfigured();
=======
    if (!_useRealAI) {
      return 'You\'re $progress% toward "${goal.title}". To hit your target, save PKR${(remaining / (days > 0 ? days : 1)).toStringAsFixed(2)}/day. Consider automating transfers on payday.';
    }

    final prompt = 'Give one actionable tip (under 30 words) to help reach this savings goal: ${goal.title}, $progress% complete, PKR${remaining.toStringAsFixed(0)} remaining, $days days left.';
>>>>>>> c281882508291f62fb38dea4bf5b14544423a4e3
    try {
      final response = await _model!.generateContent([Content.text(prompt)]);
      final text = response.text?.trim();
      if (text == null || text.isEmpty) {
        throw AIConfigurationException(
          'AI returned an empty response. Verify the $_modelName model and API key.',
        );
      }
      return text.replaceAll('â€¢', '-');
    } on AIConfigurationException {
      rethrow;
    } catch (error) {
      throw AIConfigurationException(
        'AI request failed. Check GEMINI_API_KEY, GEMINI_MODEL, billing/API access, and network. Details: $error',
      );
    }
  }
}
