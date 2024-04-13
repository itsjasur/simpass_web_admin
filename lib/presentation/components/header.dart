import 'package:admin_simpass/providers/auth_provider.dart';
import 'package:admin_simpass/providers/side_menu_provider.dart';
import 'package:admin_simpass/globals/global_keys.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class Header extends StatelessWidget {
  final String? title;
  const Header({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthServiceProvider>(builder: (context, authController, child) {
      return Container(
        // color: Colors.amber.shade100,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 60,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.start,
                children: [
                  Consumer<SideMenuProvider>(
                    builder: (context, controller, child) {
                      return InkWell(
                        borderRadius: BorderRadius.circular(5),
                        onTap: () {
                          controller.isDesktop ? controller.toggleDrawer() : homePageScaffoldKey.currentState?.openDrawer();
                          print(controller.isSideMenuOpen);

                          // print('open drawe clicked');
                        },
                        child: AnimatedRotation(
                          duration: const Duration(milliseconds: 500), // Duration of the animation
                          turns: controller.isSideMenuOpen ? 0 : 0.5, // 0.5 turns for 180 degrees

                          child: SvgPicture.asset(
                            "assets/icons/menu_handle.svg",
                            height: 16,
                            width: 16,
                            colorFilter: const ColorFilter.mode(
                              Colors.black,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  if (title != null)
                    Text(
                      title!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.end,
                children: [
                  Text(
                    authController.isLoggedIn ? "User logged in" : 'Not logged in',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 10),
                  OutlinedButton(
                    onPressed: () async {
                      await authController.loggedOut(context);
                    },
                    child: const Text('로그아웃'),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
