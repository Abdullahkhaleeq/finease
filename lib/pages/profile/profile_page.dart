import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
<<<<<<< HEAD

import '../../models/saving_goal.dart';
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';
import '../../utils/currency_utils.dart';
import '../admin/admin_dashboard_screen.dart';
import '../profile/about_page.dart';
import '../settings/settings_screen.dart';
=======
import 'package:url_launcher/url_launcher.dart';
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';
import '../../app_constants.dart';
import '../admin/admin_dashboard_screen.dart';
>>>>>>> c281882508291f62fb38dea4bf5b14544423a4e3

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Removed hardcoded primaryColor as we now use AppTheme.primary

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final firestoreService = authService.firestoreService;
    final user = authService.user;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          // ── Profile Header ──────────────────────────────────────────────
          SliverAppBar(
<<<<<<< HEAD
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppTheme.primary,
            iconTheme: const IconThemeData(color: Colors.black),
=======
            expandedHeight: 300,
            pinned: true,
            stretch: true,
            backgroundColor: AppTheme.primary,
            elevation: 0,
>>>>>>> c281882508291f62fb38dea4bf5b14544423a4e3
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
<<<<<<< HEAD
                    colors: [AppTheme.primary, Color(0xFF1D2671)],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CircleAvatar(
                          radius: 44,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person_rounded,
                            size: 48,
                            color: AppTheme.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        StreamBuilder<Map<String, dynamic>>(
                          stream: firestoreService?.getUserProfile(),
                          builder: (context, snapshot) {
                            final profile = snapshot.data ?? const {};
                            final name =
                                profile['fullName'] as String? ??
                                user?.displayName ??
                                user?.email?.split('@').first ??
                                'User';
                            final role = profile['role'] as String? ?? 'user';
                            return Column(
                              children: [
                                Text(
                                  name,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  user?.email ?? '',
                                  style: GoogleFonts.inter(
                                    color: Colors.white.withValues(alpha: 0.74),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.14),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    role == 'admin'
                                        ? 'Admin account'
                                        : (profile['isDemoAccount'] == true
                                              ? 'Demo account'
                                              : 'Personal account'),
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
=======
                    colors: [
                      AppTheme.primary,
                      AppTheme.primary.withValues(alpha: 0.85),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 2),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: CircleAvatar(
                          radius: 48,
                          backgroundColor:
                              AppTheme.primary.withValues(alpha: 0.1),
                          backgroundImage: user?.photoURL != null
                              ? NetworkImage(user!.photoURL!)
                              : null,
                          child: user?.photoURL == null
                              ? Icon(Icons.person_rounded,
                                  size: 48, color: AppTheme.primary)
                              : null,
>>>>>>> c281882508291f62fb38dea4bf5b14544423a4e3
                        ),
                      ],
                    ),
<<<<<<< HEAD
                  ),
=======
                    const SizedBox(height: 14),
                    Text(
                      user?.displayName ??
                          user?.email?.split('@')[0].toUpperCase() ??
                          'USER',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.5),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.email ?? 'Not signed in',
                      style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.7)),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 7),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.workspace_premium_rounded,
                              color: AppTheme.warning, size: 15),
                          const SizedBox(width: 7),
                          Text('ELITE MEMBER',
                              style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 1)),
                        ],
                      ),
                    ),
                  ],
>>>>>>> c281882508291f62fb38dea4bf5b14544423a4e3
                ),
              ),
            ),
          ),

          // ── Content ──────────────────────────────────────────────────────
          SliverToBoxAdapter(
<<<<<<< HEAD
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (firestoreService != null)
                    StreamBuilder<List<SavingGoal>>(
                      stream: firestoreService.getSavingGoals(),
                      builder: (context, snapshot) {
                        final goals = snapshot.data ?? const <SavingGoal>[];
                        final saved = goals.fold<double>(
                          0,
                          (sum, goal) => sum + goal.currentAmount,
                        );
                        return Row(
                          children: [
                            Expanded(
                              child: _StatCard(
                                label: 'Saved',
                                value: CurrencyUtils.format(saved),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _StatCard(
                                label: 'Goals',
                                value: '${goals.length}',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _StatCard(
                                label: 'Biometric',
                                value: authService.isBiometricEnabled
                                    ? 'On'
                                    : 'Off',
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  const SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Column(
                      children: [
                        SwitchListTile.adaptive(
                          value: authService.isBiometricEnabled,
                          onChanged: (value) async {
                            if (value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Sign in again from the login screen to enable biometric unlock.',
                                  ),
                                ),
                              );
                            } else {
                              await authService.disableBiometricLogin();
                            }
                          },
                          title: Text(
                            'Touch ID / Face ID',
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          subtitle: Text(
                            authService.isBiometricEnabled
                                ? 'Biometric quick login is active on this device.'
                                : 'Enable this from login after entering your password.',
                            style: GoogleFonts.inter(color: Colors.grey[600]),
                          ),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.settings_outlined),
                          title: const Text('Settings'),
                          subtitle: const Text(
                            'Notifications, security, language, and app preferences',
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsScreen(),
                            ),
                          ),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.info_outline_rounded),
                          title: const Text('About FinEase'),
                          subtitle: const Text(
                            'App overview, features, and developer details',
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AboutPage(),
                            ),
                          ),
                        ),
                        if (authService.isAdmin) ...[
                          const Divider(height: 1),
                          ListTile(
                            leading: const Icon(
                              Icons.admin_panel_settings_outlined,
                            ),
                            title: const Text('Admin Panel'),
                            subtitle: const Text(
                              'Moderation, metrics, and operational controls',
                            ),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const AdminDashboardScreen(),
                              ),
                            ),
                          ),
                        ],
                        const Divider(height: 1),
                        // ListTile(
                        //   leading: const Icon(Icons.shield_outlined),
                        //   title: const Text('Security'),
                        //   subtitle: const Text(
                        //     'Firebase authentication with secure local storage',
                        //   ),
                        // ),
                        const Divider(height: 1),
                        // ListTile(
                        //   leading: const Icon(Icons.school_rounded),
                        //   title: const Text('Learning Progress'),
                        //   subtitle: const Text(
                        //     'Course progress and quiz scores sync to your profile',
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Launch readiness',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          authService.isDemoAccount
                              ? 'You are in the presentation account. Create a personal account to store your own transactions, budgets, savings goals, forum activity, and quiz progress in Firebase.'
                              : 'Your account stores transactions, budgets, savings goals, literacy progress, and community activity directly in Firebase.',
                          style: GoogleFonts.inter(
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => authService.signOut(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFFDC2626),
                        side: const BorderSide(color: Color(0xFFFECACA)),
                      ),
                      child: Text(
                        'Log Out',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w800,
                        ),
=======
            child: Transform.translate(
              offset: const Offset(0, -28),
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 100),
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stats
                    _buildStatsRow(),
                    const SizedBox(height: 30),

                    // Admin Section (Only for Admin)
                    if (authService.isAdmin) ...[
                      _sectionLabel('ADMINISTRATION'),
                      const SizedBox(height: 12),
                      _buildSettingsGroup([
                        _buildSettingItem(
                          title: 'Admin Dashboard',
                          icon: Icons.admin_panel_settings_rounded,
                          color: AppTheme.secondary,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
                          ),
                        ),
                      ]),
                      const SizedBox(height: 28),
                    ],

                    // Account Settings
                    _sectionLabel('ACCOUNT'),
                    const SizedBox(height: 12),
                    _buildSettingsGroup([
                      _buildSettingItem(
                        title: 'Personal Info',
                        icon: Icons.person_outline_rounded,
                        color: AppTheme.primary,
                        onTap: () => _showPersonalInfo(context, user?.email),
                      ),
                      _buildDivider(),
                      _buildSettingItem(
                        title: 'Change Password',
                        icon: Icons.lock_outline_rounded,
                        color: AppTheme.info,
                        onTap: () => _showChangePassword(context, authService),
                      ),
                    ]),

                    const SizedBox(height: 28),

                    // App
                    _sectionLabel('APP'),
                    const SizedBox(height: 12),
                    _buildSettingsGroup([
                      _buildSettingItem(
                        title: 'About FinEase',
                        icon: Icons.info_outline_rounded,
                        color: AppTheme.primary,
                        onTap: () => _showAboutDialog(context),
                      ),
                      _buildDivider(),
                      _buildSettingItem(
                        title: 'Rate the App',
                        icon: Icons.star_outline_rounded,
                        color: AppTheme.warning,
                        onTap: () => _showSnack(
                            context, '⭐ Thank you for your support!'),
                      ),
                      _buildDivider(),
                      _buildSettingItem(
                        title: 'Share FinEase',
                        icon: Icons.share_rounded,
                        color: AppTheme.success,
                        onTap: () => _shareApp(context),
                      ),
                    ]),

                    const SizedBox(height: 36),

                    // Logout
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _confirmLogout(context, authService),
                        icon: const Icon(Icons.logout_rounded, size: 18),
                        label: Text('Log Out',
                            style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.w800, fontSize: 15)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppTheme.error,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                            side: BorderSide(
                                color: AppTheme.error.withValues(alpha: 0.1), width: 1.5),
                          ),
                        ),
>>>>>>> c281882508291f62fb38dea4bf5b14544423a4e3
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

<<<<<<< HEAD
class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});
=======
  // ── Helpers ───────────────────────────────────────────────────────────────

  Widget _sectionLabel(String label) {
    return Text(label,
        style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: Colors.grey[500],
            letterSpacing: 1.4));
  }

  Widget _buildDivider() {
    return const Divider(
        height: 1, thickness: 1, indent: 60, color: AppTheme.border);
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(child: _buildStatItem('Savings', 'PKR 12.5k')),
        const SizedBox(width: 10),
        Expanded(child: _buildStatItem('Score', '742')),
        const SizedBox(width: 10),
        Expanded(child: _buildStatItem('Goals', '4 / 6')),
      ],
    );
  }
>>>>>>> c281882508291f62fb38dea4bf5b14544423a4e3

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
<<<<<<< HEAD
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
=======
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        children: [
          Text(value,
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary)),
          const SizedBox(height: 4),
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 11,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingItem({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(title,
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary)),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                color: Colors.grey[300], size: 14),
          ],
        ),
      ),
    );
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  void _shareApp(BuildContext context) {
    Clipboard.setData(const ClipboardData(
        text: 'Check out FinEase – your smart finance manager!'));
    _showSnack(context, '📋 Share link copied to clipboard!');
  }

  void _confirmLogout(BuildContext context, AuthService authService) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Log Out',
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800)),
        content: Text('Are you sure you want to log out?',
            style: GoogleFonts.inter(fontSize: 14)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel',
                  style: GoogleFonts.inter(color: Colors.grey))),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                authService.signOut();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.error,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
            child: Text('Log Out',
                style: GoogleFonts.inter(
                    color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _showPersonalInfo(BuildContext context, String? email) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Personal Info',
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoRow(Icons.email_outlined, 'Email', email ?? 'N/A'),
            const SizedBox(height: 12),
            _infoRow(Icons.badge_outlined, 'Member Type', 'Elite Member'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
            child: Text('Close',
                style: GoogleFonts.inter(
                    color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppTheme.primary),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: GoogleFonts.inter(
                    fontSize: 11, color: Colors.grey[500])),
            Text(value,
                style: GoogleFonts.inter(
                    fontSize: 14, fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }

  void _showChangePassword(BuildContext context, AuthService authService) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Reset Password',
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800)),
        content: Text(
            'A password reset link will be sent to your registered email.',
            style: GoogleFonts.inter(fontSize: 14)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel',
                  style: GoogleFonts.inter(color: Colors.grey))),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                if (authService.user?.email != null) {
                  await authService.sendPasswordResetEmail(authService.user!.email!);
                  if (context.mounted) {
                    _showSnack(context, '📧 Password reset email sent! Check your inbox.');
                  }
                }
              } catch (e) {
                if (context.mounted) {
                  _showSnack(context, '❌ Failed to send reset email: $e');
                }
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
            child: Text('Send',
                style: GoogleFonts.inter(
                    color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        insetPadding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // App Logo / Name
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppTheme.primary, AppTheme.primary.withValues(alpha: 0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.account_balance_wallet_rounded,
                      color: Colors.white, size: 36),
                ),
                const SizedBox(height: 16),
                Text('FinEase',
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.primary)),
                Text('Your Finance Manager',
                    style: GoogleFonts.inter(
                        fontSize: 13, color: Colors.grey[500])),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF4FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('Version 1.0.0',
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w600)),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 1,
                  color: const Color(0xFFF0F0F0),
                ),
                const SizedBox(height: 20),
                Text('Meet the Developers',
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary)),
                const SizedBox(height: 16),
                // Dev 1
                _buildDevCard(
                  context: ctx,
                  name: 'Abdullah Khaleeq',
                  role: 'Lead Developer & UI/UX',
                  linkedIn:
                      'https://www.linkedin.com/in/abdullah-khaleeq-8b6588225/',
                  initials: 'AK',
                  color: AppTheme.primary,
                ),
                const SizedBox(height: 12),
                // Dev 2
                _buildDevCard(
                  context: ctx,
                  name: 'Abdul Ahad',
                  role: 'Backend & AI Integration',
                  linkedIn:
                      'https://www.linkedin.com/in/abdul-ahad-66aba6250/',
                  initials: 'AA',
                  color: AppTheme.info,
                ),
                const SizedBox(height: 20),
                Container(
                  height: 1,
                  color: const Color(0xFFF0F0F0),
                ),
                const SizedBox(height: 16),
                Text(
                  'FinEase empowers individuals with smart financial tools — budgeting, savings tracking, AI-driven insights, and welfare access in one seamless platform.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey[500],
                      height: 1.6),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text('Close',
                        style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Widget _buildDevCard({
    required BuildContext context,
    required String name,
    required String role,
    required String linkedIn,
    required String initials,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () => _launchUrl(linkedIn),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.15)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: color.withValues(alpha: 0.15),
              child: Text(initials,
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: color)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary)),
                  Text(role,
                      style: GoogleFonts.inter(
                          fontSize: 12, color: Colors.grey[500])),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.link_rounded,
                      color: Colors.white, size: 14),
                  const SizedBox(width: 4),
                  Text('LinkedIn',
                      style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ],
        ),
>>>>>>> c281882508291f62fb38dea4bf5b14544423a4e3
      ),
    );
  }
}
