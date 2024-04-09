import 'package:admin_simpass/presentation/pages/home_page.dart';
import 'package:admin_simpass/presentation/pages/login_page.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  // errorBuilder: (context, state) => ErrorPage(),
  // redirect: (context, state) => '/home',

  routes: [
    ShellRoute(
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => LoginPage(),
        ),
        GoRoute(
          name: 'home',
          path: '/',
          builder: (context, state) => HomePage(),
          // routes: [
          //   GoRoute(
          //     path: 'child',
          //     builder: (context, state) => const ChildPage(),
          //   ),
          // ],
        ),
      ],
      // builder: (context, state, child) => BottomNavigationPage(child: child),
    ),
  ],
);
