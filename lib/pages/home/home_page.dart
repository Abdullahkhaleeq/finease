import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../models/app_config.dart';
import '../../models/saving_goal.dart';
import '../../models/transaction.dart';
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';
<<<<<<< HEAD
import '../../utils/currency_utils.dart';
import '../../widgets/app_config_gate.dart';
import '../budget/ai_budget_advisor_page.dart';
=======
import '../../widgets/prediction_card.dart';
import '../../widgets/coach_advice_card.dart';
>>>>>>> c281882508291f62fb38dea4bf5b14544423a4e3
import '../chatbot/chatbot_page.dart';
import '../forum/community_forum_page.dart';
<<<<<<< HEAD
import '../analytics/analytics_screen.dart';
import '../literacy/literacy_hub_page.dart';
import '../loans/loan_simulator_page.dart';
import '../marketplace/marketplace_screen.dart';
import '../profile/profile_page.dart';
import '../savings/savings_tracker_page.dart';
=======
>>>>>>> c281882508291f62fb38dea4bf5b14544423a4e3
import '../transactions/add_transaction_page.dart';
import '../transactions/all_transactions_page.dart';
import '../welfare/welfare_programs_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.appConfig});

  final AppConfig? appConfig;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();
  bool _isRefreshing = false;

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);
    // Small delay to let streams re-emit
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) setState(() => _isRefreshing = false);
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final firestoreService = authService.firestoreService;
    final user = authService.user;
<<<<<<< HEAD
    final photoUrl = user?.photoURL;
    final appConfig = widget.appConfig ?? AppConfig.defaults();
    final primaryColor = appConfigColor(
      appConfig.primaryColorHex,
      AppTheme.primary,
    );
    final secondaryColor = appConfigColor(
      appConfig.secondaryColorHex,
      AppTheme.secondary,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
=======
    final displayName =
        user?.displayName?.split(' ').first ??
        user?.email?.split('@').first ??
        'User';

    return Scaffold(
      backgroundColor: AppTheme.background,
>>>>>>> c281882508291f62fb38dea4bf5b14544423a4e3
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          key: _refreshKey,
          onRefresh: _handleRefresh,
          color: AppTheme.primary,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
<<<<<<< HEAD
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                  child: _TopBar(
                    appConfig: appConfig,
                    primaryColor: primaryColor,
                    photoUrl: photoUrl,
                    isRefreshing: _isRefreshing,
                    onRefresh: () => _refreshKey.currentState?.show(),
                    onProfileTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfilePage()),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: firestoreService == null
                      ? const SizedBox.shrink()
                      : StreamBuilder<List<FinancialTransaction>>(
                          stream: firestoreService.getTransactions(),
                          builder: (context, snapshot) {
                            final txns = snapshot.data ?? const [];
                            final now = DateTime.now();
                            final monthlyTxns = txns
                                .where(
                                  (t) =>
                                      t.date.year == now.year &&
                                      t.date.month == now.month,
                                )
                                .toList();
                            final income = monthlyTxns
                                .where((t) => t.type == 'income')
                                .fold<double>(0, (sum, t) => sum + t.amount);
                            final expense = monthlyTxns
                                .where((t) => t.type == 'expense')
                                .fold<double>(0, (sum, t) => sum + t.amount);
                            return StreamBuilder<Map<String, dynamic>>(
                              stream: firestoreService.getMonthlySummary(),
                              builder: (context, summarySnapshot) {
                                final summary = summarySnapshot.data ?? {};
                                final balance =
                                    (summary['totalBalance'] as num?)
                                        ?.toDouble() ??
                                    income - expense;
                                return _BalanceCard(
                                  title: appConfig.homeHeroTitle,
                                  message: appConfig.homeHeroMessage,
                                  primaryColor: primaryColor,
                                  secondaryColor: secondaryColor,
                                  balance: balance,
                                  income:
                                      (summary['monthlyIncome'] as num?)
                                          ?.toDouble() ??
                                      income,
                                  expense:
                                      (summary['totalExpenses'] as num?)
                                          ?.toDouble() ??
                                      expense,
                                );
                              },
                            );
                          },
                        ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: _SectionHeader(
                    title: 'Core Tools',
                    actionLabel: 'Open Budget Planer',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AIBudgetAdvisorPage(),
                      ),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: _FeatureGrid(
                    items: [
                      _FeatureItem(
                        label: 'Marketplace',
                        icon: Icons.storefront_rounded,
                        color: const Color(0xFF2E3192),
                        background: const Color(0xFFEEF2FF),
                        enabled: appConfig.marketplaceEnabled,
                        onTap: () => _openFeature(
                          enabled: appConfig.marketplaceEnabled,
                          title: 'Marketplace is paused',
                          message: appConfig.supportMessage,
                          page: const MarketplaceScreen(),
                        ),
                      ),
                      _FeatureItem(
                        label: 'Budget',
                        icon: Icons.account_balance_wallet_rounded,
                        color: const Color(0xFF0EA5A4),
                        background: const Color(0xFFECFEFF),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AIBudgetAdvisorPage(),
                          ),
                        ),
                      ),
                      _FeatureItem(
                        label: 'Analysis',
                        icon: Icons.query_stats_rounded,
                        color: const Color(0xFF4F46E5),
                        background: const Color(0xFFEEF2FF),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AnalyticsScreen(),
                          ),
                        ),
                      ),
                      _FeatureItem(
                        label: 'Loans',
                        icon: Icons.calculate_rounded,
                        color: const Color(0xFFD97706),
                        background: const Color(0xFFFFF7ED),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoanSimulatorPage(),
                          ),
                        ),
                      ),
                      _FeatureItem(
                        label: 'Chatbot',
                        icon: Icons.smart_toy_rounded,
                        color: const Color(0xFF475569),
                        background: const Color(0xFFF1F5F9),
                        enabled: appConfig.chatbotEnabled,
                        onTap: () => _openFeature(
                          enabled: appConfig.chatbotEnabled,
                          title: 'AI chatbot is paused',
                          message: appConfig.supportMessage,
                          page: const ChatbotPage(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: _SectionHeader(
                    title: 'Explore FinEase',
                    actionLabel: 'Open Savings Plan',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SavingsTrackerPage(),
                      ),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: _FeatureGrid(
                    items: [
                      _FeatureItem(
                        label: 'Savings',
                        icon: Icons.savings_rounded,
                        color: const Color(0xFF0EA5A4),
                        background: const Color(0xFFECFEFF),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SavingsTrackerPage(),
                          ),
                        ),
                      ),
                      _FeatureItem(
                        label: 'Literacy Hub',
                        icon: Icons.school_rounded,
                        color: const Color(0xFF4F46E5),
                        background: const Color(0xFFEEF2FF),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LiteracyHubPage(),
                          ),
                        ),
                      ),
                      _FeatureItem(
                        label: 'Welfare',
                        icon: Icons.volunteer_activism_rounded,
                        color: const Color(0xFFD97706),
                        background: const Color(0xFFFFF7ED),
                        enabled: appConfig.welfareEnabled,
                        onTap: () => _openFeature(
                          enabled: appConfig.welfareEnabled,
                          title: 'Welfare programs are paused',
                          message: appConfig.supportMessage,
                          page: const WelfareProgramsPage(),
                        ),
                      ),
                      _FeatureItem(
                        label: 'Forum',
                        icon: Icons.forum_rounded,
                        color: const Color(0xFF475569),
                        background: const Color(0xFFF1F5F9),
                        enabled: appConfig.forumEnabled,
                        onTap: () => _openFeature(
                          enabled: appConfig.forumEnabled,
                          title: 'Community forum is paused',
                          message: appConfig.supportMessage,
                          page: const CommunityForumPage(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: _SectionHeader(
                    title: 'Your Progress',
                    actionLabel: '',
                    onTap: () {},
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: firestoreService == null
                      ? const SizedBox.shrink()
                      : StreamBuilder<List<SavingGoal>>(
                          stream: firestoreService.getSavingGoals(),
                          builder: (context, goalSnapshot) {
                            return StreamBuilder<List<FinancialTransaction>>(
                              stream: firestoreService.getTransactions(),
                              builder: (context, txnSnapshot) {
                                final goals = goalSnapshot.data ?? const [];
                                final txns = txnSnapshot.data ?? const [];
                                final saved = goals.fold<double>(
                                  0,
                                  (sum, goal) => sum + goal.currentAmount,
                                );
                                return FutureBuilder<int>(
                                  future: _completedLessonCount(
                                    firestoreService,
                                  ),
                                  builder: (context, lessonSnapshot) {
                                    final completedLessons =
                                        lessonSnapshot.data ?? 0;
                                    return _ProgressPanel(
                                      totalSaved: saved,
                                      goalCount: goals.length,
                                      transactionCount: txns.length,
                                      completedLessons: completedLessons,
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: _SectionHeader(
                    title: 'Recent Transactions',
                    actionLabel: 'See all',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AllTransactionsPage(),
                      ),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                sliver: firestoreService == null
                    ? const SliverToBoxAdapter(child: SizedBox.shrink())
                    : StreamBuilder<List<FinancialTransaction>>(
                        stream: firestoreService.getTransactions(),
                        builder: (context, snapshot) {
                          final txns = (snapshot.data ?? const [])
                              .take(5)
                              .toList();
                          if (txns.isEmpty) {
                            return const SliverToBoxAdapter(
                              child: _EmptyState(),
                            );
                          }
                          return SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => _DismissibleTransactionTile(
                                txn: txns[index],
                                firestoreService: firestoreService,
                              ),
                              childCount: txns.length,
                            ),
                          );
                        },
                      ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),
=======

            // ── Balance Card ─────────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              sliver: SliverToBoxAdapter(
                child: firestoreService != null
                    ? StreamBuilder<List<FinancialTransaction>>(
                        stream: firestoreService.getTransactions(),
                        builder: (ctx, snap) {
                          final txns = snap.data ?? [];
                          final income = txns
                              .where((t) => t.type == 'income')
                              .fold(0.0, (s, t) => s + t.amount);
                          final expense = txns
                              .where((t) => t.type == 'expense')
                              .fold(0.0, (s, t) => s + t.amount);
                          return _buildBalanceCard(
                              balance: income - expense,
                              income: income,
                              expense: expense);
                        },
                      )
                    : _buildBalanceCard(
                        balance: 0, income: 0, expense: 0),
              ),
            ),

            // ── Promo Banner ─────────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              sliver: SliverToBoxAdapter(
                child: _buildHeroBanner(context),
              ),
            ),

            // ── Quick Actions ────────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              sliver: SliverToBoxAdapter(
                child: _buildSectionHeader('Quick Access', null),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              sliver: SliverToBoxAdapter(
                child: _buildQuickActions(context),
              ),
            ),

            // ── Prediction Card ──────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
              sliver: SliverToBoxAdapter(
                child: firestoreService != null
                    ? StreamBuilder<List<FinancialTransaction>>(
                        stream: firestoreService.getTransactions(),
                        builder: (ctx, snap) {
                          final txns = snap.data ?? [];
                          final income = txns
                              .where((t) => t.type == 'income')
                              .fold(0.0, (s, t) => s + t.amount);
                          final months = txns.isEmpty
                              ? 1
                              : (() {
                                  final diff = DateTime.now()
                                      .difference(txns.last.date)
                                      .inDays;
                                  return (diff / 30).ceil().clamp(1, 36);
                                })();
                          return PredictionCard(
                            transactions: txns,
                            monthlyIncome: income / months,
                          );
                        },
                      )
                    : const SizedBox.shrink(),
              ),
            ),

            // ── AI Coach Card ─────────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
              sliver: SliverToBoxAdapter(
                child: firestoreService != null
                    ? StreamBuilder<List<FinancialTransaction>>(
                        stream: firestoreService.getTransactions(),
                        builder: (ctx, snap) {
                          final txns = snap.data ?? [];
                          final income = txns
                              .where((t) => t.type == 'income')
                              .fold(0.0, (s, t) => s + t.amount);
                          final months = txns.isEmpty
                              ? 1
                              : (() {
                                  final diff = DateTime.now()
                                      .difference(txns.last.date)
                                      .inDays;
                                  return (diff / 30).ceil().clamp(1, 36);
                                })();
                          return CoachAdviceCard(
                            transactions: txns,
                            monthlyIncome: income / months,
                          );
                        },
                      )
                    : const SizedBox.shrink(),
              ),
            ),

            // ── Feature Highlight Banner ──────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              sliver: SliverToBoxAdapter(
                child: _buildFeatureBanner(context),
              ),
            ),

            // ── Recent Transactions ──────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
              sliver: SliverToBoxAdapter(
                child: _buildSectionHeader(
                  'Recent Transactions',
                  () => Navigator.push(context,
                      MaterialPageRoute(
                          builder: (_) => const AllTransactionsPage())),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              sliver: firestoreService != null
                  ? StreamBuilder<List<FinancialTransaction>>(
                      stream: firestoreService.getTransactions(),
                      builder: (ctx, snap) {
                        if (snap.connectionState ==
                            ConnectionState.waiting) {
                          return const SliverToBoxAdapter(
                              child: Center(
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppTheme.primary)));
                        }
                        final txns =
                            (snap.data ?? []).take(5).toList();
                        if (txns.isEmpty) {
                          return SliverToBoxAdapter(
                              child: _buildEmptyState());
                        }
                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (ctx, i) =>
                                _buildTransactionItem(txns[i]),
                            childCount: txns.length,
                          ),
                        );
                      },
                    )
                  : const SliverToBoxAdapter(
                      child: Center(
                          child: Text('Login to see transactions'))),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
>>>>>>> c281882508291f62fb38dea4bf5b14544423a4e3
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 90),
<<<<<<< HEAD
        child: FloatingActionButton.extended(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTransactionPage()),
          ),
          backgroundColor: AppTheme.primary,
          icon: const Icon(Icons.add_rounded, color: Colors.white),
          label: Text(
            'Add Transaction',
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
=======
        child: FloatingActionButton(
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(
                  builder: (_) => const AddTransactionPage())),
          backgroundColor: AppTheme.primary,
          elevation: 6,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18)),
          child: const Icon(Icons.add_rounded,
              color: Colors.white, size: 30),
>>>>>>> c281882508291f62fb38dea4bf5b14544423a4e3
        ),
      ),
    );
  }

<<<<<<< HEAD
  Future<int> _completedLessonCount(dynamic firestoreService) async {
    const courseIds = [
      'budget-foundations',
      'smart-investing',
      'credit-and-debt',
      'pakistan-finance-playbook',
    ];
    var total = 0;
    for (final courseId in courseIds) {
      final progress = await firestoreService.getCourseProgress(courseId).first;
      final completed = List<String>.from(
        progress['completedLessonIds'] ?? const [],
      );
      total += completed.length;
    }
    return total;
  }

  void _openFeature({
    required bool enabled,
    required String title,
    required String message,
    required Widget page,
  }) {
    if (!enabled) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text('$title. $message')));
      return;
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.appConfig,
    required this.primaryColor,
    required this.photoUrl,
    required this.isRefreshing,
    required this.onRefresh,
    required this.onProfileTap,
  });

  final AppConfig appConfig;
  final Color primaryColor;
  final String? photoUrl;
  final bool isRefreshing;
  final VoidCallback onRefresh;
  final VoidCallback onProfileTap;

  @override
  Widget build(BuildContext context) {
    final firestoreService = context.watch<AuthService>().firestoreService;
    return StreamBuilder<Map<String, dynamic>>(
      stream: firestoreService?.getUserProfile(),
      builder: (context, snapshot) {
        final profile = snapshot.data ?? const {};
        final name =
            (profile['fullName'] as String?)?.split(' ').first ??
            context.watch<AuthService>().user?.displayName?.split(' ').first ??
            context.watch<AuthService>().user?.email?.split('@').first ??
            'User';
        final role = profile['role'] == 'admin'
            ? 'Administrator'
            : (profile['isDemoAccount'] == true
                  ? 'Demo account'
                  : appConfig.brandTagline);

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  AppBrandLogo(
                    logoUrl: appConfig.logoUrl,
                    size: 42,
                    backgroundColor: primaryColor.withValues(alpha: 0.08),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: onProfileTap,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: AppTheme.softShadow,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: photoUrl != null
                            ? Image.network(
                                photoUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    CircleAvatar(
                                      backgroundColor: primaryColor,
                                      child: const Icon(
                                        Icons.person_rounded,
                                        color: Colors.white,
                                      ),
                                    ),
                              )
                            : CircleAvatar(
                                backgroundColor: primaryColor,
                                child: const Icon(
                                  Icons.person_rounded,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appConfig.brandName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 17,
                            color: const Color(0xFF0F172A),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          role,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: onRefresh,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: AppTheme.softShadow,
                ),
                child: isRefreshing
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppTheme.primary,
                        ),
                      )
                    : const Icon(
                        Icons.refresh_rounded,
                        color: Color(0xFF0F172A),
                        size: 22,
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({
    required this.title,
    required this.message,
    required this.primaryColor,
    required this.secondaryColor,
    required this.balance,
    required this.income,
    required this.expense,
  });

  final String title;
  final String message;
  final Color primaryColor;
  final Color secondaryColor;
  final double balance;
  final double income;
  final double expense;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          colors: [primaryColor, secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              color: Colors.white.withValues(alpha: 0.78),
              fontWeight: FontWeight.w600,
            ),
=======
  // ── Top Bar ───────────────────────────────────────────────────────────────
  Widget _buildTopBar(
      BuildContext context, String displayName, String? photoUrl) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildAvatar(photoUrl),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Good ${_greeting()},',
                      style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppTheme.textHint,
                          fontWeight: FontWeight.w500)),
                  Text(displayName,
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 17,
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w800)),
                ],
              ),
            ],
          ),
          const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildAvatar(String? photoUrl) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppTheme.primaryGradient,
        boxShadow: [
          BoxShadow(
              color: AppTheme.primary.withValues(alpha: 0.25),
              blurRadius: 12,
              offset: const Offset(0, 4))
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: photoUrl != null
            ? Image.network(photoUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 22))
            : const Icon(Icons.person_rounded,
                color: Colors.white, size: 22),
      ),
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap,
      {bool badge = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: AppTheme.border),
          boxShadow: AppTheme.softShadow,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, color: AppTheme.textPrimary, size: 22),
            if (badge)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                      color: AppTheme.error, shape: BoxShape.circle),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Morning';
    if (h < 17) return 'Afternoon';
    return 'Evening';
  }

  // ── Balance Card ──────────────────────────────────────────────────────────
  Widget _buildBalanceCard({
    required double balance,
    required double income,
    required double expense,
  }) {
    final fmt = NumberFormat('#,##0', 'en_US');
    final isNeg = balance < 0;

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: AppTheme.heroBannerGradient,
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        boxShadow: AppTheme.floatingShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Balance',
                  style: GoogleFonts.inter(
                      color: Colors.white.withValues(alpha: 0.65),
                      fontSize: 13,
                      fontWeight: FontWeight.w500)),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(children: [
                  Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                          color: Color(0xFF34D399),
                          shape: BoxShape.circle)),
                  const SizedBox(width: 5),
                  Text('Live',
                      style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600)),
                ]),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '${isNeg ? '-' : ''}PKR ${fmt.format(balance.abs())}',
            style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.w800,
                letterSpacing: -1),
          ),
          const SizedBox(height: 6),
          Text(
            isNeg ? '⚠️ Spending exceeds income' : '✓ Finances on track',
            style: GoogleFonts.inter(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 12),
          ),
          const SizedBox(height: 24),
          Container(height: 1, color: Colors.white.withValues(alpha: 0.12)),
          const SizedBox(height: 20),
          Row(
            children: [
              _balanceStat(Icons.south_west_rounded, 'Income',
                  'PKR ${fmt.format(income)}', const Color(0xFF34D399)),
              Container(
                  width: 1,
                  height: 36,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.white.withValues(alpha: 0.15)),
              _balanceStat(Icons.north_east_rounded, 'Expenses',
                  'PKR ${fmt.format(expense)}',
                  const Color(0xFFFB7185)),
            ],
>>>>>>> c281882508291f62fb38dea4bf5b14544423a4e3
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: GoogleFonts.inter(
              color: Colors.white.withValues(alpha: 0.72),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            CurrencyUtils.format(balance),
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _BalanceStat(
                  label: 'Income',
                  value: CurrencyUtils.format(income),
                ),
              ),
              Expanded(
                child: _BalanceStat(
                  label: 'Expenses',
                  value: CurrencyUtils.format(expense),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

<<<<<<< HEAD
class _BalanceStat extends StatelessWidget {
  const _BalanceStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: Colors.white.withValues(alpha: 0.72),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
=======
  Widget _balanceStat(
      IconData icon, String label, String amount, Color color) {
    return Expanded(
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
                color: color.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: GoogleFonts.inter(
                      color: Colors.white.withValues(alpha: 0.55),
                      fontSize: 11,
                      fontWeight: FontWeight.w500)),
              Text(amount,
                  style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }

  // ── Hero Promo Banner ─────────────────────────────────────────────────────
  Widget _buildHeroBanner(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          boxShadow: AppTheme.floatingShadow,
        ),
        child: Image.asset(
          'assets/banner.png',
          fit: BoxFit.contain,
          width: double.infinity,
          errorBuilder: (_, _, _) => Container(
            height: 160,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(AppTheme.radiusLg),
            ),
            child: Center(
              child: Text(
                'FinEase — Your Finance Manager',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Feature Banner ────────────────────────────────────────────────────────
  Widget _buildFeatureBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0EA5E9), Color(0xFF06B6D4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      ),
      child: Row(
        children: [
          const Icon(Icons.calculate_rounded,
              color: Colors.white, size: 40),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Loan Simulator',
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.white)),
                Text(
                    'Calculate EMI & compare loan options instantly',
                    style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.8))),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(
                    builder: (_) => const LoanSimulatorPage())),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('Try Now',
                  style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.info)),
            ),
          ),
        ],
      ),
    );
  }

  // ── Quick Actions ─────────────────────────────────────────────────────────
  Widget _buildQuickActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _actionItem(
          context,
          icon: Icons.auto_awesome_rounded,
          label: 'AI Chat',
          bg: const Color(0xFFEEF2FF),
          fg: AppTheme.primaryLight,
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const ChatbotPage())),
        ),
        _actionItem(
          context,
          icon: Icons.calculate_rounded,
          label: 'Loans',
          bg: const Color(0xFFECFDF5),
          fg: AppTheme.success,
          onTap: () => Navigator.push(context,
              MaterialPageRoute(
                  builder: (_) => const LoanSimulatorPage())),
        ),
        _actionItem(
          context,
          icon: Icons.volunteer_activism_rounded,
          label: 'Welfare',
          bg: const Color(0xFFFFF7ED),
          fg: AppTheme.warning,
          onTap: () => Navigator.push(context,
              MaterialPageRoute(
                  builder: (_) => const WelfareProgramsPage())),
        ),
        _actionItem(
          context,
          icon: Icons.forum_rounded,
          label: 'Forum',
          bg: const Color(0xFFF5F3FF),
          fg: AppTheme.accent,
          onTap: () => Navigator.push(context,
              MaterialPageRoute(
                  builder: (_) => const CommunityForumPage())),
        ),
      ],
    );
  }

  Widget _actionItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color bg,
    required Color fg,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: fg.withValues(alpha: 0.15), width: 1.5),
              boxShadow: [
                BoxShadow(
                    color: fg.withValues(alpha: 0.12),
                    blurRadius: 14,
                    offset: const Offset(0, 5))
              ],
            ),
            child: Icon(icon, color: fg, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary)),
        ],
      ),
    );
  }

  // ── Section Header ────────────────────────────────────────────────────────
  Widget _buildSectionHeader(String title, VoidCallback? onSeeAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary)),
        if (onSeeAll != null)
          GestureDetector(
            onTap: onSeeAll,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: AppTheme.surfaceCard,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('See All',
                  style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary)),
            ),
          ),
>>>>>>> c281882508291f62fb38dea4bf5b14544423a4e3
      ],
    );
  }
}

<<<<<<< HEAD
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onTap,
  });
=======
  // ── Transaction Item ──────────────────────────────────────────────────────
  Widget _buildTransactionItem(FinancialTransaction t) {
    final isIncome = t.type == 'income';
    final amountColor =
        isIncome ? AppTheme.success : AppTheme.error;
    final bgColor = isIncome
        ? const Color(0xFFECFDF5)
        : const Color(0xFFFFF1F2);
>>>>>>> c281882508291f62fb38dea4bf5b14544423a4e3

  final String title;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0F172A),
          ),
        ),
        TextButton(onPressed: onTap, child: Text(actionLabel)),
      ],
    );
  }
}

class _FeatureGrid extends StatelessWidget {
  const _FeatureGrid({required this.items});

  final List<_FeatureItem> items;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        final iconColor = item.enabled ? item.color : const Color(0xFF94A3B8);
        final background = item.enabled
            ? item.background
            : const Color(0xFFF1F5F9);
        return InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: item.onTap,
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppTheme.border),
              boxShadow: AppTheme.softShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: background,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(item.icon, color: iconColor),
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.label,
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w700,
                          color: item.enabled
                              ? AppTheme.textPrimary
                              : AppTheme.textHint,
                        ),
                      ),
                    ),
                    if (!item.enabled)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          'Paused',
                          style: GoogleFonts.inter(
                            color: AppTheme.textSecondary,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FeatureItem {
  const _FeatureItem({
    required this.label,
    required this.icon,
    required this.color,
    required this.background,
    required this.onTap,
    this.enabled = true,
  });

  final String label;
  final IconData icon;
  final Color color;
  final Color background;
  final VoidCallback onTap;
  final bool enabled;
}

class _ProgressPanel extends StatelessWidget {
  const _ProgressPanel({
    required this.totalSaved,
    required this.goalCount,
    required this.transactionCount,
    required this.completedLessons,
  });

  final double totalSaved;
  final int goalCount;
  final int transactionCount;
  final int completedLessons;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your progress is syncing across savings, learning, and activity.',
            style: GoogleFonts.inter(
              color: Colors.white.withValues(alpha: 0.78),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _ProgressMetric(
                  label: 'Saved',
                  value: CurrencyUtils.format(totalSaved),
                ),
              ),
              Expanded(
                child: _ProgressMetric(
                  label: 'Goals',
                  value: '$goalCount active',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ProgressMetric(
                  label: 'Lessons',
                  value: '$completedLessons done',
                ),
              ),
              Expanded(
                child: _ProgressMetric(
                  label: 'Transactions',
                  value: '$transactionCount logged',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgressMetric extends StatelessWidget {
  const _ProgressMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              color: Colors.white.withValues(alpha: 0.65),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.txn});

  final FinancialTransaction txn;

  @override
  Widget build(BuildContext context) {
    final isIncome = txn.type == 'income';
    final color = isIncome ? AppTheme.success : const Color(0xFFE11D48);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
<<<<<<< HEAD
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppTheme.border),
=======
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.softShadow,
>>>>>>> c281882508291f62fb38dea4bf5b14544423a4e3
      ),
      child: Row(
        children: [
          Container(
<<<<<<< HEAD
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              isIncome ? Icons.south_west_rounded : Icons.north_east_rounded,
              color: color,
=======
            width: 46,
            height: 46,
            decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(14)),
            child: Icon(
              isIncome
                  ? Icons.south_west_rounded
                  : Icons.north_east_rounded,
              color: amountColor,
              size: 22,
>>>>>>> c281882508291f62fb38dea4bf5b14544423a4e3
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
<<<<<<< HEAD
                Text(
                  txn.title,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  txn.category,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
=======
                Text(t.title,
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: AppTheme.textPrimary)),
                const SizedBox(height: 3),
                Text(
                  '${t.category}  ·  ${DateFormat('dd MMM').format(t.date)}',
                  style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.textHint,
                      fontWeight: FontWeight.w500),
>>>>>>> c281882508291f62fb38dea4bf5b14544423a4e3
                ),
              ],
            ),
          ),
          Text(
<<<<<<< HEAD
            CurrencyUtils.format(txn.amount),
            style: GoogleFonts.plusJakartaSans(
              color: color,
              fontWeight: FontWeight.w800,
            ),
=======
            '${isIncome ? '+' : '-'} PKR ${t.amount.toStringAsFixed(0)}',
            style: GoogleFonts.plusJakartaSans(
                color: amountColor,
                fontWeight: FontWeight.w700,
                fontSize: 14),
>>>>>>> c281882508291f62fb38dea4bf5b14544423a4e3
          ),
        ],
      ),
    );
  }
}

<<<<<<< HEAD
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            const Icon(
              Icons.receipt_long_rounded,
              size: 64,
              color: Color(0xFFE2E8F0),
            ),
            const SizedBox(height: 16),
            Text(
              'No transactions yet',
              style: GoogleFonts.inter(
                color: const Color(0xFF94A3B8),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
=======
  // ── Empty State ───────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppTheme.surfaceCard,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(Icons.receipt_long_rounded,
                size: 36, color: AppTheme.textHint),
          ),
          const SizedBox(height: 16),
          Text('No transactions yet',
              style: GoogleFonts.plusJakartaSans(
                  color: AppTheme.textSecondary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text('Tap + below to add your first one',
              style: GoogleFonts.inter(
                  color: AppTheme.textHint, fontSize: 13)),
        ],
>>>>>>> c281882508291f62fb38dea4bf5b14544423a4e3
      ),
    );
  }
}

class _DismissibleTransactionTile extends StatelessWidget {
  const _DismissibleTransactionTile({
    required this.txn,
    required this.firestoreService,
  });

  final FinancialTransaction txn;
  final dynamic firestoreService;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(txn.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: const Color(0xFFE11D48),
          borderRadius: BorderRadius.circular(22),
        ),
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Delete',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.delete_outline_rounded, color: Colors.white),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        return true;
      },
      onDismissed: (direction) {
        firestoreService.deleteTransaction(txn.id);
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '"${txn.title}" deleted',
              style: GoogleFonts.inter(fontWeight: FontWeight.w500),
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'UNDO',
              textColor: const Color(0xFF00F2EA),
              onPressed: () {
                firestoreService.addTransaction(txn);
              },
            ),
          ),
        );
      },
      child: _TransactionTile(txn: txn),
    );
  }
}
