import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../../models/transaction.dart';

class AIBudgetAdvisorPage extends StatefulWidget {
  const AIBudgetAdvisorPage({super.key});

  @override
  State<AIBudgetAdvisorPage> createState() => _AIBudgetAdvisorPageState();
}

class _AIBudgetAdvisorPageState extends State<AIBudgetAdvisorPage>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  // Demo budget limits (PKR) — later connect to Firestore
  final Map<String, double> _budgets = {
    'Food': 15000,
    'Transport': 8000,
    'Shopping': 12000,
    'Health': 5000,
    'Bills': 10000,
    'Other': 6000,
  };

  final Map<String, Color> _catColors = {
    'Food':      AppTheme.catFood,
    'Transport': AppTheme.catTransport,
    'Shopping':  AppTheme.catShopping,
    'Health':    AppTheme.catHealth,
    'Bills':     AppTheme.catBills,
    'Other':     AppTheme.catOther,
  };

  final Map<String, IconData> _catIcons = {
    'Food':      Icons.restaurant_rounded,
    'Transport': Icons.directions_car_rounded,
    'Shopping':  Icons.shopping_bag_rounded,
    'Health':    Icons.favorite_rounded,
    'Bills':     Icons.receipt_long_rounded,
    'Other':     Icons.more_horiz_rounded,
  };

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);
    final fs = auth.firestoreService;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: fs == null
          ? const Center(child: Text('Please sign in'))
          : StreamBuilder<List<FinancialTransaction>>(
              stream: fs.getTransactions(),
              builder: (ctx, snap) {
                final txns = snap.data ?? [];
                final now = DateTime.now();
                final thisMonth = txns.where((t) =>
                    t.type == 'expense' &&
                    t.date.month == now.month &&
                    t.date.year == now.year);

                // Spending per category this month
                final Map<String, double> spent = {};
                for (final t in thisMonth) {
                  spent[t.category] =
                      (spent[t.category] ?? 0) + t.amount;
                }

                final totalBudget =
                    _budgets.values.fold(0.0, (a, b) => a + b);
                final totalSpent =
                    spent.values.fold(0.0, (a, b) => a + b);
                final totalRemaining =
                    (totalBudget - totalSpent).clamp(0, totalBudget);
                final pct = totalBudget > 0
                    ? (totalSpent / totalBudget).clamp(0.0, 1.0)
                    : 0.0;

                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    _buildHeader(),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: _buildOverviewCard(
                          totalBudget: totalBudget,
                          totalSpent: totalSpent,
                          totalRemaining: totalRemaining.toDouble(),
                          pct: pct.toDouble(),
                        ),
                      ),
                    ),
                    // ── Tab Bar ─────────────────────────────────────
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                        child: _buildTabBar(),
                      ),
                    ),
                    // ── Tab Content ─────────────────────────────────
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                        child: _buildTabContent(spent),
                      ),
                    ),
                    // ── AI Insights ─────────────────────────────────
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                        child: _buildSectionLabel('AI Insights'),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                        child: _buildInsightCard(
                          icon: Icons.auto_fix_high_rounded,
                          color: AppTheme.accent,
                          title: 'Subscription Overlap Detected',
                          body:
                              'You may have overlapping streaming subscriptions. Cutting one could save PKR 2,500/mo.',
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                        child: _buildInsightCard(
                          icon: Icons.psychology_alt_rounded,
                          color: AppTheme.warning,
                          title: 'Dining Spike This Week',
                          body:
                              'Food spending is 22% above your weekly average. Try home-cooked meals to stay on track.',
                        ),
                      ),
                    ),
                    // ── Upgrade CTA ─────────────────────────────────
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                        child: _buildUpgradeCTA(),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 120)),
                  ],
                );
              },
            ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.primaryGradient,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 60, 20, 28),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Budget Advisor',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.5)),
                  const SizedBox(height: 4),
                  Text('Smart spending, smarter saving',
                      style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.65))),
                ],
              ),
            ),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: Colors.white.withValues(alpha: 0.25)),
              ),
              child: const Icon(Icons.tune_rounded,
                  color: Colors.white, size: 22),
            ),
          ],
        ),
      ),
    );
  }

  // ── Overview Card ─────────────────────────────────────────────────────────
  Widget _buildOverviewCard({
    required double totalBudget,
    required double totalSpent,
    required double totalRemaining,
    required double pct,
  }) {
    final pctLabel = '${(pct * 100).toStringAsFixed(0)}%';
    final isWarning = pct > 0.85;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        boxShadow: AppTheme.cardShadow,
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Monthly Budget',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: (isWarning ? AppTheme.error : AppTheme.success)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isWarning ? '⚠️ High Usage' : '✓ On Track',
                  style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isWarning ? AppTheme.error : AppTheme.success),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _statCol('Total Budget',
                  'PKR ${_fmt(totalBudget)}', AppTheme.textPrimary),
              _vertDiv(),
              _statCol('Spent',
                  'PKR ${_fmt(totalSpent)}', AppTheme.error),
              _vertDiv(),
              _statCol('Remaining',
                  'PKR ${_fmt(totalRemaining)}', AppTheme.success),
            ],
          ),
          const SizedBox(height: 20),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 10,
              backgroundColor: AppTheme.border,
              valueColor: AlwaysStoppedAnimation<Color>(
                  isWarning ? AppTheme.error : AppTheme.primary),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$pctLabel used',
                  style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w500)),
              Text('PKR ${_fmt(totalRemaining)} left',
                  style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.success,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statCol(String label, String val, Color valColor) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textHint)),
          const SizedBox(height: 4),
          Text(val,
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: valColor)),
        ],
      ),
    );
  }

  Widget _vertDiv() {
    return Container(
      width: 1, height: 36,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: AppTheme.border,
    );
  }

  // ── Tab Bar ───────────────────────────────────────────────────────────────
  Widget _buildTabBar() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(14),
      ),
      child: TabBar(
        controller: _tab,
        indicator: BoxDecoration(
          color: AppTheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppTheme.textSecondary,
        labelStyle:
            GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
        unselectedLabelStyle:
            GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500),
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: 'Categories'),
          Tab(text: 'Distribution'),
        ],
      ),
    );
  }

  Widget _buildTabContent(Map<String, double> spent) {
    return SizedBox(
      height: 360,
      child: TabBarView(
        controller: _tab,
        children: [
          _buildCategoryList(spent),
          _buildDistributionChart(spent),
        ],
      ),
    );
  }

  // ── Category List ─────────────────────────────────────────────────────────
  Widget _buildCategoryList(Map<String, double> spent) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      children: _budgets.entries.map((e) {
        final cat = e.key;
        final budget = e.value;
        final spend = spent[cat] ?? 0;
        final ratio = budget > 0 ? (spend / budget).clamp(0.0, 1.0) : 0.0;
        final over = spend > budget;
        final color = _catColors[cat] ?? AppTheme.primary;

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(
                color: over
                    ? AppTheme.error.withValues(alpha: 0.3)
                    : AppTheme.border),
            boxShadow: AppTheme.softShadow,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(_catIcons[cat] ?? Icons.category,
                        color: color, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(cat,
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary)),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('PKR ${_fmt(spend)}',
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: over ? AppTheme.error : AppTheme.textPrimary)),
                      Text('of PKR ${_fmt(budget)}',
                          style: GoogleFonts.inter(
                              fontSize: 11, color: AppTheme.textHint)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: ratio,
                  minHeight: 7,
                  backgroundColor: AppTheme.border,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      over ? AppTheme.error : color),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ── Distribution Chart ────────────────────────────────────────────────────
  Widget _buildDistributionChart(Map<String, double> spent) {
    final hasData = spent.isNotEmpty;
    final sections = _budgets.entries.map((e) {
      final val = spent[e.key] ?? 0;
      final color = _catColors[e.key] ?? AppTheme.primary;
      return PieChartSectionData(
        color: color,
        value: hasData ? (val > 0 ? val : 0.001) : e.value,
        radius: 14,
        showTitle: false,
      );
    }).toList();

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sectionsSpace: 3,
              centerSpaceRadius: 65,
              sections: sections,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: _budgets.keys.map((cat) {
            final color = _catColors[cat] ?? AppTheme.primary;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8, height: 8,
                  decoration:
                      BoxDecoration(color: color, shape: BoxShape.circle),
                ),
                const SizedBox(width: 4),
                Text(cat,
                    style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w500)),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  // ── Insight Card ──────────────────────────────────────────────────────────
  Widget _buildInsightCard({
    required IconData icon,
    required Color color,
    required String title,
    required String body,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: color.withValues(alpha: 0.25)),
        boxShadow: AppTheme.softShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary)),
                const SizedBox(height: 4),
                Text(body,
                    style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                        height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Upgrade CTA ───────────────────────────────────────────────────────────
  Widget _buildUpgradeCTA() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.softShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: AppTheme.cyanGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.smart_toy_rounded,
                color: Colors.white, size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ask the AI Coach',
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary)),
                Text('Get personalised budget tips right now',
                    style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.textSecondary)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text('Chat',
                style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(label,
        style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary));
  }

  String _fmt(double v) => v
      .toStringAsFixed(0)
      .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');
}
