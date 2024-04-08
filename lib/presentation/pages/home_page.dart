import 'package:admin_simpass/controller/side_menu_controller.dart';
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
      body: Row(
        children: [
          // Using Obx here to listen to changes in the controller's variables
          Obx(() {
            if (controller.isDesktop.value && !controller.sideMenuManuallyClosed.value) {
              return const SideMenu();
            }

            if (!controller.isDesktop.value && controller.isSideMenuOpen.value) {
              return const SideMenu();
            }

            return Container();
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
