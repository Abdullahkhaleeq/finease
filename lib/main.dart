import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'models/app_config.dart';
import 'services/app_config_service.dart';
import 'services/auth_service.dart';
import 'services/bootstrap_service.dart';
import 'pages/auth/email_verification_page.dart';
import 'pages/auth/login_page.dart';
import 'pages/admin/admin_dashboard_screen.dart';
import 'pages/main_scaffold.dart';
import 'pages/admin/admin_dashboard_screen.dart';
import 'app_constants.dart';
import 'theme/app_theme.dart';
import 'services/security_service.dart';
import 'widgets/security_overlay.dart';
import 'widgets/security_check_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await BootstrapService.ensureSpecialAccounts();
  runApp(
    MultiProvider(
<<<<<<< HEAD
      providers: [ChangeNotifierProvider(create: (_) => AuthService())],
=======
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => SecurityService()),
      ],
>>>>>>> c281882508291f62fb38dea4bf5b14544423a4e3
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return StreamBuilder<AppConfig>(
      stream: AppConfigService().watchConfig(),
      initialData: AppConfig.defaults(),
      builder: (context, snapshot) {
        final config = snapshot.data ?? AppConfig.defaults();
        return MaterialApp(
          title: config.brandName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: const AuthWrapper(),
        );
      },
=======
    return MaterialApp(
      title: 'FinEase',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      builder: (context, child) => SecurityOverlay(
        child: SecurityCheckWrapper(child: child!),
      ),
      home: const AuthWrapper(),
>>>>>>> c281882508291f62fb38dea4bf5b14544423a4e3
    );
  }
}


class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
<<<<<<< HEAD

    if (authService.user == null) {
      return const LoginPage();
    } else if (authService.isAdmin) {
      return const AdminDashboardScreen();
    } else if (!authService.isEmailVerified) {
      return const EmailVerificationPage();
    } else {
      return const MainScaffold();
=======
    final user = authService.user;

    if (user == null) {
      return const LoginPage();
>>>>>>> c281882508291f62fb38dea4bf5b14544423a4e3
    }

    // Route admin email directly to admin dashboard
    final email = (user.email ?? '').toLowerCase().trim();
    final adminEmail = AppConstants.adminEmail.toLowerCase().trim();
    
    if (kDebugMode) {
      print('AuthWrapper: Current User Email: "$email"');
      print('AuthWrapper: Target Admin Email: "$adminEmail"');
      print('AuthWrapper: Is Admin? ${email == adminEmail}');
    }

    if (email == adminEmail && email.isNotEmpty) {
      return const AdminDashboardScreen();
    }

    return const MainScaffold();
  }
}
