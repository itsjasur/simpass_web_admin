import 'package:admin_simpass/globals/constants.dart';
import 'package:admin_simpass/presentation/pages/applications_page.dart';
import 'package:admin_simpass/presentation/pages/customer_requests_page.dart';
import 'package:admin_simpass/presentation/pages/empty_page.dart';
import 'package:admin_simpass/presentation/pages/manage_plans_page.dart';
import 'package:admin_simpass/presentation/pages/manage_users_page.dart';
import 'package:admin_simpass/presentation/pages/menu_shell.dart';
import 'package:admin_simpass/presentation/pages/login_page.dart';
import 'package:admin_simpass/presentation/pages/not_found_page.dart';
import 'package:admin_simpass/presentation/pages/profile_page.dart';
import 'package:admin_simpass/presentation/pages/retailers_page.dart';
import 'package:admin_simpass/presentation/pages/signup_page.dart';
import 'package:admin_simpass/providers/auth_provider.dart';
import 'package:admin_simpass/providers/menu_provider.dart';
import 'package:admin_simpass/providers/myinfo_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final appRouter = GoRouter(
  initialLocation: '/customer-requests',
  errorBuilder: (context, state) => const NotFoundPage(),
  routes: [
    // GoRoute(
    //   name: 'test',
    //   path: '/',
    //   builder: (context, state) => const ScrollFormImageViewer(binaryImageList: applyformlists),
    // ),
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
            name: 'emptyhome',
            path: '/',
            builder: (context, state) {
              WidgetsBinding.instance.addPostFrameCallback((_) => Provider.of<MenuProvider>(context, listen: false).updateMenu(-1));
              return const EmptyHomePage();
            }),
        GoRoute(
            name: 'profile',
            path: '/profile',
            builder: (context, state) {
              WidgetsBinding.instance.addPostFrameCallback((_) => Provider.of<MenuProvider>(context, listen: false).updateMenu(0));
              return const ProfilePage();
            }),
        GoRoute(
            name: 'manage-users',
            path: '/manage-users',
            builder: (context, state) {
              WidgetsBinding.instance.addPostFrameCallback((_) => Provider.of<MenuProvider>(context, listen: false).updateMenu(1));
              return const ManageUsersPage();
            }),
        GoRoute(
            name: 'manager-plans',
            path: '/manage-plans',
            builder: (context, state) {
              WidgetsBinding.instance.addPostFrameCallback((_) => Provider.of<MenuProvider>(context, listen: false).updateMenu(2));
              return const ManagePlansPage();
            }),
        GoRoute(
            name: 'applications',
            path: '/applications',
            builder: (context, state) {
              WidgetsBinding.instance.addPostFrameCallback((_) => Provider.of<MenuProvider>(context, listen: false).updateMenu(3));
              return const ApplicationsPage();
            }),
        GoRoute(
            name: 'retailers',
            path: '/retailers',
            builder: (context, state) {
              WidgetsBinding.instance.addPostFrameCallback((_) => Provider.of<MenuProvider>(context, listen: false).updateMenu(4));
              return const RetailersPage();
            }),
        GoRoute(
            name: 'customer-requests',
            path: '/customer-requests',
            builder: (context, state) {
              WidgetsBinding.instance.addPostFrameCallback((_) => Provider.of<MenuProvider>(context, listen: false).updateMenu(5));
              return const CustomerRequestsPage();
            }),
      ],
      builder: (context, state, child) => MenuShell(child: child),
    ),
  ],
  redirect: (context, state) async {
    final isLoggedIn = context.read<AuthServiceProvider>().isLoggedIn;

    // User is not logged in and not heading to login and not going to signup, redirects to login
    if (!isLoggedIn && state.matchedLocation != '/signup') return '/login';

    final myInfoProvider = Provider.of<MyinfoProvifer>(context, listen: false);
    List<String> myRoles = await myInfoProvider.getRolesList();
    // List<String> myRoles = ["ROLE_MANAGERs"];

    String headingLocation = state.matchedLocation;

    // checking if headingLocation exists as a key in pathAccessInfo
    bool isHeadingLocationInMap = rolePathAccessInfo.containsKey(headingLocation);

    // assuming headingLocation matches key in pathAccessInfo
    List<dynamic> allowedRoles = isHeadingLocationInMap ? rolePathAccessInfo[headingLocation]! : [];

    // checking if the path is available to everyone
    bool isAccessibleToAll = allowedRoles.isEmpty || allowedRoles.contains("ALL");

    // checking if the user has access to the specified headingLocation based on their roles
    bool userHasAccess = isAccessibleToAll || myRoles.any((role) => allowedRoles.contains(role));

    if (!userHasAccess) return "/profile";

    // No need to redirect
    return null;
  },
);
