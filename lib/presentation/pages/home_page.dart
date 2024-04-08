import 'package:admin_simpass/controller/side_menu_controller.dart';
import 'package:admin_simpass/globals/global_keys.dart';
import 'package:admin_simpass/presentation/components/header.dart';
import 'package:admin_simpass/presentation/components/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResponsiveMenuPage extends StatelessWidget {
  final ResponsiveMenuController controller = Get.find<ResponsiveMenuController>();

  ResponsiveMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    //updating the side menu visibility depending on the toggle
    controller.updateDrawerBasedOnScreenSize(context);

    return Scaffold(
      key: homePageScaffoldKey,
      drawer: const SideMenu(),
      body: Row(
        children: [
          // Using Obx here to listen to changes in the controller's variables
          // Obx(() {
          //   if (controller.isDesktop.value && !controller.sideMenuManuallyClosed.value) {
          //     return const SideMenu();
          //   }

          //   if (!controller.isDesktop.value && controller.isSideMenuOpen.value) {
          //     return const SideMenu();
          //   }

          //   return Container();
          // }),

          Obx(() {
            double width = 0;
            if (controller.isDesktop.value && !controller.sideMenuManuallyClosed.value) {
              width = 250; // Example open width, adjust as needed
            }

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300), // Adjust the duration to control the speed of the animation
              width: width,
              curve: Curves.easeInOut,
              child: const SideMenu(), // Optional: Add a curve for the animation
            );
          }),
          Expanded(
            child: Column(
              children: [
                Header(),
                const Center(
                  child: Text("Main Content Area"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
