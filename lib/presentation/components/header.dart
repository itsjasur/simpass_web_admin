import 'package:admin_simpass/controller/side_menu_controller_provider.dart';
import 'package:admin_simpass/globals/global_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ResponsiveMenuController>(
      builder: (context, controller, child) {
        return SizedBox(
          height: 50,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 10),
              InkWell(
                borderRadius: BorderRadius.circular(5),
                onTap: () {
                  controller.isDesktop ? controller.toggleDrawer() : homePageScaffoldKey.currentState?.openDrawer();
                },
                child: AnimatedRotation(
                  duration: const Duration(milliseconds: 500), // Duration of the animation
                  turns: controller.isSideMenuOpen ? 0.5 : 0, // 0.5 turns for 180 degrees

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
        );
      },
    );
  }
}
