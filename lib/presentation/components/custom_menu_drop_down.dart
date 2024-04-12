import 'package:admin_simpass/globals/main_ui.dart';
import 'package:flutter/material.dart';

class CustomDropDownMenu extends StatelessWidget {
  final List<DropdownMenuEntry> items;
  final double width;
  final dynamic selectedItem;
  final Widget label;
  final bool enabled;
  final Function(dynamic)? onSelected;
  final TextEditingController? controller;
  final String? errorText;

  const CustomDropDownMenu({
    super.key,
    required this.items,
    this.width = 200,
    this.selectedItem,
    this.onSelected,
    required this.label,
    this.enabled = true,
    this.controller,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      width: width + 7,
      menuHeight: 300,
      errorText: errorText,
      controller: controller,
      requestFocusOnTap: false,
      expandedInsets: const EdgeInsets.all(0),
      label: label,
      initialSelection: selectedItem,
      onSelected: onSelected,
      enabled: enabled,
      menuStyle: MenuStyle(
        padding: MaterialStateProperty.all(EdgeInsets.zero),
        // backgroundColor: MaterialStateProperty.all(Colors.white),
        // shadowColor: MaterialStateProperty.all(Colors.white),
        surfaceTintColor: MaterialStateProperty.all(Colors.white),
      ),
      dropdownMenuEntries: items,
      inputDecorationTheme: InputDecorationTheme(
        // fillColor: Colors.white,

        // helperText: '', //leaves empty place for error text
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 18,
        ),

        labelStyle: const TextStyle(
          fontSize: 15,
          color: Colors.black45,
        ),
        floatingLabelStyle: const TextStyle(
          color: Colors.black87,
          // fontSize: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: MainUi.mainColor,
          ),
        ),
        constraints: const BoxConstraints(
          minHeight: 50,
          // minWidth: 100,
        ),

        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Colors.black45,
          ),
        ),

        // isDense: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Colors.black45,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),

        errorMaxLines: 3,

        errorStyle: const TextStyle(
          color: Colors.red,
          // height: 0.5,
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
