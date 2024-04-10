import 'package:admin_simpass/globals/main_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ClickableLogo extends StatelessWidget {
  final Color color;
  const ClickableLogo({super.key, this.color = MainUi.mainColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.go('/');
      },
      child: Container(
        alignment: Alignment.center,
        child: Image.asset(
          "assets/logo.png",
          color: color,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
