import 'package:admin_simpass/controller/side_menu_controller_provider.dart';
import 'package:admin_simpass/globals/global_keys.dart';
import 'package:admin_simpass/presentation/components/header.dart';
import 'package:admin_simpass/presentation/components/side_menu.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homePageScaffoldKey,
      drawer: const SideMenu(),
      body: Row(
        children: [
          Consumer<ResponsiveMenuController>(
            builder: (context, controller, child) {
              controller.updateDrawerBasedOnScreenSize(context); //this should be called whenever screen size changes
              double width = 0;
              if (controller.isDesktop && !controller.sideMenuManuallyClosed) {
                width = 300; // example open width, adjust as needed
              }
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300), // adjsting the duration to control the speed of the animation
                width: width,
                curve: Curves.easeInOut,
                child: const SideMenu(), // Optional: Add a curve for the animation
              );
            },
          ),
          const Expanded(
            child: Column(
              children: [
                Header(),
                Center(
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
