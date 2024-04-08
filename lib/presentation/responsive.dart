// import 'package:flutter/material.dart';

// class ResponsiveMenu extends StatelessWidget {
//   final Widget mobileDrawer;
//   final Widget desktopDrawer;
//   final Widget child;

//   const ResponsiveMenu({
//     super.key,
//     required this.mobileDrawer,
//     required this.desktopDrawer,
//     required this.child,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // Determine the screen width
//     final screenWidth = MediaQuery.of(context).size.width;

//     // Set a breakpoint for desktop size
//     const desktopBreakpoint = 720.0;

//     return screenWidth < desktopBreakpoint
//         ? Scaffold(
//             drawer: mobileDrawer, // Drawer for mobile size
//             body: child,
//           )
//         : Scaffold(
//             body: Row(
//               children: [
//                 desktopDrawer, // Permanent side menu for desktop size
//                 Expanded(child: child),
//               ],
//             ),
//           );
//   }
// }
