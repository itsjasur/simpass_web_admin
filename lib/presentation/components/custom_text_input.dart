import 'package:admin_simpass/globals/main_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextInput extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final String? Function(String?)? validator;
  final bool hidden;
  final bool enabled;
  final bool readOnly;
  final int? maxlength;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextInput({
    super.key,
    required this.controller,
    required this.title,
    this.validator,
    this.hidden = false,
    this.enabled = true,
    this.readOnly = false,
    this.inputFormatters,
    this.maxlength,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(
        fontSize: 15,
        color: Colors.black87,
      ),
      controller: controller,
      validator: validator,
      inputFormatters: inputFormatters,
      enabled: enabled,
      maxLength: maxlength,
      readOnly: readOnly,
      obscureText: hidden,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        counterText: '',
        // helperText: '', //leaves empty place for error text
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 18,
        ),

        labelText: title,
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
        constraints: const BoxConstraints(minHeight: 50),
        // isDense: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Colors.black45,
          ),
        ),

        disabledBorder: OutlineInputBorder(
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
