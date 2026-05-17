import 'dart:ui';

import 'package:flutter/material.dart';
<<<<<<< HEAD

import '../models/app_config.dart';
import '../services/app_config_service.dart';
import '../widgets/app_config_gate.dart';
import '../theme/app_theme.dart';
import 'budget/ai_budget_advisor_page.dart';
import 'chatbot/chatbot_page.dart';
import 'home/home_page.dart';
import 'loans/loan_simulator_page.dart';
=======
import '../theme/app_theme.dart';
import 'home/home_page.dart';
import 'literacy/literacy_hub_page.dart';
import 'savings/savings_tracker_page.dart';
import 'budget/ai_budget_advisor_page.dart';
import 'analytics/analytics_screen.dart';
>>>>>>> c281882508291f62fb38dea4bf5b14544423a4e3
import 'profile/profile_page.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

<<<<<<< HEAD
=======
  final List<Widget> _pages = const [
    HomePage(),
    LiteracyHubPage(),
    SavingsTrackerPage(),
    AIBudgetAdvisorPage(),
    AnalyticsScreen(),
    ProfilePage(),
  ];

>>>>>>> c281882508291f62fb38dea4bf5b14544423a4e3
  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AppConfig>(
      stream: AppConfigService().watchConfig(),
      initialData: AppConfig.defaults(),
      builder: (context, snapshot) {
        final config = snapshot.data ?? AppConfig.defaults();
        final primaryColor = appConfigColor(
          config.primaryColorHex,
          AppTheme.primary,
        );
        if (config.maintenanceMode) {
          return Scaffold(
            backgroundColor: const Color(0xFFF8F9FF),
            body: AppBlockedView(
              title: '${config.brandName} is under maintenance',
              message: config.supportMessage,
              icon: Icons.construction_rounded,
              color: primaryColor,
            ),
          );
        }

        final pages = [
          HomePage(appConfig: config),
          const AIBudgetAdvisorPage(),
          const LoanSimulatorPage(embedded: true),
          config.chatbotEnabled
              ? const ChatbotPage(embedded: true)
              : AppBlockedView(
                  title: 'AI chatbot is paused',
                  message: config.supportMessage,
                  icon: Icons.smart_toy_outlined,
                  color: primaryColor,
                ),
          const ProfilePage(),
        ];

        return Scaffold(
          extendBody: true,
          body: Column(
            children: [
              AppAnnouncementBanner(config: config),
              Expanded(
                child: IndexedStack(index: _selectedIndex, children: pages),
              ),
            ],
          ),
          bottomNavigationBar: _buildPremiumNavBar(config, primaryColor),
        );
      },
    );
  }

  Widget _buildPremiumNavBar(AppConfig config, Color primaryColor) {
    return Container(
      height: 85,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.88),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.4),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withValues(alpha: 0.10),
                  blurRadius: 24,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
<<<<<<< HEAD
                _buildNavItem(
                  0,
                  Icons.home_rounded,
                  'Home',
                  activeColor: primaryColor,
                ),
                _buildNavItem(
                  1,
                  Icons.account_balance_wallet_rounded,
                  'Budget',
                  activeColor: primaryColor,
                ),
                _buildNavItem(
                  2,
                  Icons.calculate_rounded,
                  'Loans',
                  activeColor: primaryColor,
                ),
                _buildNavItem(
                  3,
                  Icons.smart_toy_rounded,
                  'Chatbot',
                  enabled: config.chatbotEnabled,
                  activeColor: primaryColor,
                ),
                _buildNavItem(
                  4,
                  Icons.person_rounded,
                  'Profile',
                  activeColor: primaryColor,
                ),
=======
                _buildNavItem(0, Icons.dashboard_rounded, 'Home'),
                _buildNavItem(1, Icons.school_rounded, 'Literacy'),
                _buildNavItem(2, Icons.savings_rounded, 'Savings'),
                _buildNavItem(3, Icons.smart_toy_rounded, 'Budget'),
                _buildNavItem(4, Icons.analytics_rounded, 'Analytics'),
                _buildNavItem(5, Icons.person_rounded, 'Profile'),
>>>>>>> c281882508291f62fb38dea4bf5b14544423a4e3
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData icon,
    String label, {
    bool enabled = true,
    Color activeColor = const Color(0xFF2E3192),
  }) {
    final isSelected = _selectedIndex == index;
<<<<<<< HEAD
    final color = isSelected
        ? activeColor
        : enabled
        ? const Color(0xFF94A3B8)
        : const Color(0xFFCBD5E1);
=======
    final color = isSelected ? AppTheme.primary : AppTheme.textHint;
>>>>>>> c281882508291f62fb38dea4bf5b14544423a4e3

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primary.withValues(alpha: 0.09)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 25),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
