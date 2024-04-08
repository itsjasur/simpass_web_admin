// // Import Riverpod
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final drawerStateProvider = StateProvider<bool>((ref) {
//   // Initial state, you can decide based on the platform or screen size
//   return false; // Closed by default, you might want to change this based on screen size
// });

import 'package:admin_simpass/presentation/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResponsiveMenuController extends GetxController {
  // Observable variable to handle the drawer's visibility
  var isSideMenuOpen = false.obs;
  var sideMenuManuallyClosed = false.obs;
  var isDesktop = true.obs;

  // @override
  // void onInit() {
  //   super.onInit();
  //   // Assuming 600 as the breakpoint for desktop vs mobile
  //   isSideMenuOpen.value = Get.width > 600;
  // }

  // Function to toggle the drawer's state
  void toggleDrawer() {
    isSideMenuOpen.value = !isSideMenuOpen.value;
    if (isDesktop.value) sideMenuManuallyClosed.value = !sideMenuManuallyClosed.value;
  }

  // Determine if the device is desktop based on the width
  void updateDrawerBasedOnScreenSize(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth > desktopBreakPoint) {
      isDesktop.value = true;
      isSideMenuOpen.value = true;
    }
    if (screenWidth < desktopBreakPoint) {
      isDesktop.value = false;
      isSideMenuOpen.value = false;
    }
  }

  // // Determine if the device is desktop based on the width
  // bool isDeviceDesktop(BuildContext context) {
  //   return MediaQuery.of(context).size.width > 800;
  // }
}
