import 'package:admin_simpass/controller/side_menu_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Header extends StatelessWidget {
  Header({super.key});

  final ResponsiveMenuController sideMenuController = Get.find<ResponsiveMenuController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            sideMenuController.toggleDrawer();
          },
          child: Icon(Icons.arrow_back),
        ),

        // if (!Responsive.isDesktop(context))
        //   IconButton(
        //     icon: const Icon(Icons.menu),
        //     onPressed: context.read<MenuDrawerController>().openSideMenu,
        //   ),

        // if (!Responsive.isMobile(context))
        //   Text(
        //     "Dashboard",
        //     style: Theme.of(context).textTheme.titleLarge,
        //   ),
        // if (!Responsive.isMobile(context)) Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
        // Expanded(child: SearchField()),
        // ProfileCard()
      ],
    );
  }
}
