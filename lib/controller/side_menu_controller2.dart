// import 'package:admin_simpass/presentation/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class ResponsiveMenuController extends GetxController {
//   // Observable variable to handle the drawer's visibility
//   var isSideMenuOpen = false.obs;
//   var sideMenuManuallyClosed = false.obs;
//   var isDesktop = true.obs;

//   // Function to toggle the drawer's state
//   void toggleDrawer() {
//     isSideMenuOpen.value = !isSideMenuOpen.value;
//     if (isDesktop.value) sideMenuManuallyClosed.value = !sideMenuManuallyClosed.value;
//   }

//   // Determine if the device is desktop based on the width
//   void updateDrawerBasedOnScreenSize(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;

//     if (screenWidth > desktopBreakPoint) {
//       isDesktop.value = true;
//       isSideMenuOpen.value = true;
//     }
//     if (screenWidth < desktopBreakPoint) {
//       isDesktop.value = false;
//       isSideMenuOpen.value = false;
//     }
//   }
// }
