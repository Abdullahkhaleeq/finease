import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'services/auth_service.dart';
import 'pages/auth/login_page.dart';
import 'pages/main_scaffold.dart';
import 'pages/admin/admin_dashboard_screen.dart';
import 'app_constants.dart';
import 'theme/app_theme.dart';
import 'services/security_service.dart';
import 'widgets/security_overlay.dart';
import 'widgets/security_check_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => SecurityService()),
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinEase',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      builder: (context, child) => SecurityOverlay(
        child: SecurityCheckWrapper(child: child!),
      ),
      home: const AuthWrapper(),
    );
  }
}


class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.user;

    if (user == null) {
      return const LoginPage();
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
