import 'package:flutter/material.dart';

Future<void> showCustomDialog({
  required BuildContext context,
  double? width,
  double? height,
  required Widget content,
  bool barrierDismissible = true,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: barrierDismissible, // user must tap button!
    useSafeArea: true,
    // barrierColor: Colors.transparent,

    builder: (BuildContext context) {
      return AlertDialog(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5), // Adjust the radius here
        ),
        content: content,
      );
    },
  );
}
