import 'package:admin_simpass/controller/side_menu_controller_provider.dart';
import 'package:admin_simpass/presentation/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResponsiveLayoutBuilder extends StatelessWidget {
  final Widget child;

  const ResponsiveLayoutBuilder({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to get the current width
    final screenWidth = MediaQuery.of(context).size.width;
    final controller = Provider.of<ResponsiveMenuController>(context, listen: false);

    // Logic to determine if the device type changed (mobile to desktop or vice versa)
    // This prevents unnecessary calls to updateDrawerBasedOnScreenSize
    final isCurrentlyDesktop = screenWidth > desktopBreakPoint;
    if (controller.isDesktop != isCurrentlyDesktop) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.updateDrawerBasedOnScreenSize(context);
      });
    }

    return child;
  }
}
