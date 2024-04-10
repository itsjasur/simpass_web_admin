import 'package:admin_simpass/presentation/pages/menu_shell.dart';
import 'package:admin_simpass/presentation/pages/login_page.dart';
import 'package:admin_simpass/presentation/pages/not_found_page.dart';
import 'package:admin_simpass/presentation/pages/profile_page.dart';
import 'package:admin_simpass/presentation/pages/application_receipt_status.dart';
import 'package:admin_simpass/presentation/pages/signup_page.dart';
import 'package:admin_simpass/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final appRouter = GoRouter(
  initialLocation: '/profile',
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
          name: 'application-receipt-status',
          path: '/', // this pages opens whenever user visits base url
          builder: (context, state) => const ApplicationReceiptStatusPage(),
        ),
      ],
      builder: (context, state, child) => MenuShell(child: child),
    ),
  ],
  redirect: (context, state) {
    final isLoggedIn = context.read<AuthServiceProvider>().isLoggedIn;
    final goingToLogin = state.matchedLocation == '/login';

    // if (!isLoggedIn && !goingToLogin) {
    //   print("redirecting to login");
    //   // User is not logged in and not heading to login, redirects to login
    //   return '/login';
    // } else if (isLoggedIn && goingToLogin) {
    //   // User is logged in but heading to login, redirects to home
    //   print("redirecting to home");
    //   return '/';
    // }

    // No need to redirect
    return null;
  },
);
