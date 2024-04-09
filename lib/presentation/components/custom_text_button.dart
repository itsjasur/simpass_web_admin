import 'package:admin_simpass/globals/main_ui.dart';
import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final void Function()? onTap;
  final String title;
  const CustomTextButton({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.red,
      onTap: onTap,
      child: Text(
        title,
        style: const TextStyle(
          color: MainUi.mainColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
