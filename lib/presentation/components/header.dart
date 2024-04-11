import 'package:admin_simpass/providers/side_menu_provider.dart';
import 'package:admin_simpass/globals/global_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class Header extends StatelessWidget {
  final String? title;
  const Header({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        children: [
          Consumer<SideMenuProvider>(
            builder: (context, controller, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: InkWell(
                  borderRadius: BorderRadius.circular(5),
                  onTap: () {
                    controller.isDesktop ? controller.toggleDrawer() : homePageScaffoldKey.currentState?.openDrawer();
                    print(controller.isSideMenuOpen);

                    // print('open drawe clicked');
                  },
                  child: AnimatedRotation(
                    duration: const Duration(milliseconds: 500), // Duration of the animation
                    turns: controller.isSideMenuOpen ? 0.5 : 0, // 0.5 turns for 180 degrees

                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: SvgPicture.asset(
                        "assets/icons/menu_handle.svg",
                        height: 18,
                        width: 18,
                        colorFilter: const ColorFilter.mode(
                          Colors.black,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          // const SizedBox(width: 10),
          if (title != null)
            Text(
              title!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }
}
