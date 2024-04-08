import 'package:admin_simpass/controller/side_menu_controller.dart';
import 'package:admin_simpass/globals/global_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class Header extends StatelessWidget {
  Header({super.key});

  final ResponsiveMenuController sideMenuController = Get.find<ResponsiveMenuController>();

  @override
  Widget build(BuildContext context) {
    // return AppBar(
    //   leading: AnimatedRotation(
    //     duration: const Duration(milliseconds: 500), // Duration of the animation
    //     turns: sideMenuController.isSideMenuOpen.value ? 0.5 : 0, // 0.5 turns for 180 degrees
    //     child: InkWell(
    //       borderRadius: BorderRadius.circular(20),
    //       onTap: () {
    //         sideMenuController.isDesktop.value ? sideMenuController.toggleDrawer() : homePageScaffoldKey.currentState?.openDrawer();
    //       },
    //       child: Container(
    //         color: Colors.amber,
    //         // padding: const EdgeInsets.all(15),
    //         width: 20,
    //         height: 20,
    //         child: FittedBox(
    //           fit: BoxFit.contain,
    //           child: SvgPicture.asset(
    //             "assets/icons/menu_handle.svg",
    //             colorFilter: const ColorFilter.mode(
    //               Colors.black,
    //               BlendMode.srcIn,
    //             ),
    //             fit: BoxFit.contain,
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
    return Obx(
      () => SizedBox(
        height: 50,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 10),
            InkWell(
              borderRadius: BorderRadius.circular(5),
              onTap: () {
                sideMenuController.isDesktop.value ? sideMenuController.toggleDrawer() : homePageScaffoldKey.currentState?.openDrawer();
              },
              child: AnimatedRotation(
                duration: const Duration(milliseconds: 500), // Duration of the animation
                turns: sideMenuController.isSideMenuOpen.value ? 0.5 : 0, // 0.5 turns for 180 degrees
                child: Container(
                  padding: const EdgeInsets.all(7),
                  width: 30,
                  height: 30,
                  child: SvgPicture.asset(
                    "assets/icons/menu_handle.svg",
                    colorFilter: const ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
