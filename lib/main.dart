import 'package:flutter/material.dart';
import 'ui/screens/splash/splash_screen.dart';
import 'ui/screens/auth/login_screen.dart';
import 'ui/screens/auth/register_screen.dart';
import 'ui/screens/dashboard/dashboard_screen.dart';

void main() {
  runApp(const SkillSyncApp());
}

class SkillSyncApp extends StatelessWidget {
  const SkillSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'SkillSync',

      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      initialRoute: '/',

      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}