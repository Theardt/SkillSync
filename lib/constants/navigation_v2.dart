import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:skillsync/barrel_file.dart';

import 'package:skillsync/ui/screens/main_screen.dart';
import 'package:skillsync/ui/screens/splash/splash_screen.dart';
import 'package:skillsync/ui/screens/auth/login_screen.dart';
import 'package:skillsync/ui/screens/auth/register_screen.dart';
import 'package:skillsync/ui/screens/navigation/navigation_screen.dart';
import 'package:skillsync/ui/screens/profile/edit_profile_screen.dart';

enum MainRoutes {
  home('home');

  const MainRoutes(this.routeName);

  final String routeName;
}

class NavigationV2 {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static List<String> publicRoutes = [
    MainRoutes.home.routeName,
  ];

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: true,

    redirect: (context, state) {

      final isLoggedIn =
          sl.authenticationCubit.state.main.isAuthenticated;

      final currentLocation = state.uri.toString();

      /// PUBLIC ROUTES
      final isAuthRoute =
          currentLocation == '/login' ||
          currentLocation == '/register';

      /// IF NOT LOGGED IN
      if (!isLoggedIn && !isAuthRoute) {
        return '/login';
      }

      /// IF LOGGED IN AND TRYING TO ACCESS LOGIN
      if (isLoggedIn && isAuthRoute) {
        return '/navigation';
      }

      return null;
    },

    routes: [

      /// SPLASH
      GoRoute(
        path: '/',
        builder: (context, state) =>
            const SplashScreen(),
      ),

      /// LOGIN
      GoRoute(
        path: '/login',
        builder: (context, state) =>
            const LoginScreen(),
      ),

      /// REGISTER
      GoRoute(
        path: '/register',
        builder: (context, state) =>
            const RegisterScreen(),
      ),

      /// MAIN NAVIGATION
      GoRoute(
        path: '/navigation',
        builder: (context, state) =>
            const NavigationScreen(),
      ),

      /// EDIT PROFILE
      GoRoute(
        path: '/edit_profile',
        builder: (context, state) =>
            const EditProfileScreen(),
      ),

      /// HOME
      GoRoute(
        path: '/home',
        name: MainRoutes.home.routeName,
        builder: (context, state) =>
            const MainHomeScreen(),
      ),
    ],

    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('Route Error'),
      ),
      body: Center(
        child: Text(
          "This path doesn't exist: ${state.uri.toString()}",
        ),
      ),
    ),
  );

  static void showHomeScreen(BuildContext context) {
    HapticFeedback.heavyImpact();

    context.goNamed(
      MainRoutes.home.routeName,
    );
  }
}