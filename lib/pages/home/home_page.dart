import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../services/auth_service.dart';
import '../../models/transaction.dart';
import '../../theme/app_theme.dart';
import '../../widgets/prediction_card.dart';
import '../../widgets/coach_advice_card.dart';
import '../chatbot/chatbot_page.dart';
import '../loans/loan_simulator_page.dart';
import '../welfare/welfare_programs_page.dart';
import '../forum/community_forum_page.dart';
import '../notifications/notifications_page.dart';
import '../transactions/add_transaction_page.dart';
import '../transactions/all_transactions_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final firestoreService = authService.firestoreService;
    final user = authService.user;
    final displayName =
        user?.displayName?.split(' ').first ??
        user?.email?.split('@').first ??
        'User';

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Top Bar ─────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: _buildTopBar(context, displayName, user?.photoURL),
            ),

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
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 90),
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
        ),
      ),
    );
  }

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
          Row(
            children: [
              _iconBtn(Icons.search_rounded, () {}),
              const SizedBox(width: 8),
              Builder(builder: (ctx) {
                return _iconBtn(
                    Icons.notifications_none_rounded,
                    () => Navigator.push(
                        ctx,
                        MaterialPageRoute(
                            builder: (_) =>
                                const NotificationsPage())),
                    badge: true);
              }),
            ],
          ),
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
          ),
        ],
      ),
    );
  }

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
    return Container(
      height: 130,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        image: const DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?w=800&q=80',
          ),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
              Color(0xCC1E1F6B), BlendMode.multiply),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.accent.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text('NEW FEATURE',
                        style: GoogleFonts.inter(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 1.2)),
                  ),
                  const SizedBox(height: 8),
                  Text('AI Spending\nForecast is Live!',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          height: 1.2)),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text('Explore →',
                          style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.primary)),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.insights_rounded,
                color: Colors.white, size: 72),
          ],
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
      ],
    );
  }

  // ── Transaction Item ──────────────────────────────────────────────────────
  Widget _buildTransactionItem(FinancialTransaction t) {
    final isIncome = t.type == 'income';
    final amountColor =
        isIncome ? AppTheme.success : AppTheme.error;
    final bgColor = isIncome
        ? const Color(0xFFECFDF5)
        : const Color(0xFFFFF1F2);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.softShadow,
      ),
      child: Row(
        children: [
          Container(
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
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                ),
              ],
            ),
          ),
          Text(
            '${isIncome ? '+' : '-'} PKR ${t.amount.toStringAsFixed(0)}',
            style: GoogleFonts.plusJakartaSans(
                color: amountColor,
                fontWeight: FontWeight.w700,
                fontSize: 14),
          ),
        ],
      ),
    );
  }

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
      ),
    );
  }
}
