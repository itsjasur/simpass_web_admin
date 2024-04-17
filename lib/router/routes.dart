import 'package:admin_simpass/presentation/pages/manage_plans.dart';
import 'package:admin_simpass/presentation/pages/manage_users.dart';
import 'package:admin_simpass/presentation/pages/menu_shell.dart';
import 'package:admin_simpass/presentation/pages/login_page.dart';
import 'package:admin_simpass/presentation/pages/not_found_page.dart';
import 'package:admin_simpass/presentation/pages/profile_page.dart';
import 'package:admin_simpass/presentation/pages/application_receipt_status.dart';
import 'package:admin_simpass/presentation/pages/signup_page.dart';
import 'package:admin_simpass/providers/auth_provider.dart';
import 'package:admin_simpass/providers/menu_navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  errorBuilder: (context, state) => const NotFoundPage(),
  routes: [
    GoRoute(
      name: 'login',
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      name: 'signup',
      path: '/signup',
      builder: (context, state) => const SignupPage(),
    ),
    ShellRoute(
      routes: [
        GoRoute(
          name: 'profile',
          path: '/profile',
          builder: (context, state) => const ProfilePage(),
        ),
        GoRoute(
          name: 'manage-users',
          path: '/',
          builder: (context, state) => const ManageUsers(),
        ),
        GoRoute(
          name: 'manager-plans',
          path: '/manage-plans',
          builder: (context, state) => const ManagePlans(),
        ),
      ],
      builder: (context, state, child) => MenuShell(child: child),
    ),
  ],
  redirect: (context, state) {
    final isLoggedIn = context.read<AuthServiceProvider>().isLoggedIn;
    final goingToLogin = state.matchedLocation == '/login';

    //updating side menu state if user opens from url
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MenuIndexProvider>().updateMenuIndexWithUrl(state.matchedLocation);
      // Provider.of<MenuIndexProvider>(context, listen: false).updateMenuIndex(state.matchedLocation);
    });

    // User is not logged in and not heading to login, redirects to login
    if (!isLoggedIn && !goingToLogin) {
      print("redirecting to login");
      return '/login';
    }

    // User is logged in but heading to login, redirects to home
    if (isLoggedIn && goingToLogin) {
      return '/';
    }

    // No need to redirect
    return null;
  },
);
