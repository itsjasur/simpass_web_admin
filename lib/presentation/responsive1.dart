// import 'package:admin_simpass/controller/menu_drawer_controller.dart';
// import 'package:flutter/material.dart';

// class Responsive extends StatelessWidget {
//   final Widget mobile;
//   final Widget? tablet;
//   final Widget desktop;

//   const Responsive({
//     super.key,
//     required this.mobile,
//     this.tablet,
//     required this.desktop,
//   });

// // This size work fine on my design, maybe you need some customization depends on your design

//   // This isMobile, isTablet, isDesktop help us later
//   static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 850;

//   static bool isTablet(BuildContext context) => MediaQuery.of(context).size.width < 1100 && MediaQuery.of(context).size.width >= 850;

//   static bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 1100;

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;
//     // If our width is more than 1100 then we consider it a desktop
//     if (size.width >= 1100) {
//       print(sideMenuController.sideMenuStatus);
//       sideMenuController.openSideMenu();
//       return desktop;
//     }

//     // If width it less then 1100 and more then 850 we consider it as tablet
//     else if (size.width >= 850 && tablet != null) {
//       sideMenuController.closeSideMenu();
//       return tablet!;
//     }
//     // Or less then that we called it mobile
//     else {
//       sideMenuController.closeSideMenu();

//       return mobile;
//     }
//   }
// }
