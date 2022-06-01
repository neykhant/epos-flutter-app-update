import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  MyTextFormField({
    Key? key,
    required this.controller,
    this.obscureText = false,
    this.autocorrect = false,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.none,
    this.decoration,
    this.textInputAction,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLines = 1,
    this.minLines,
    this.onChanged,
    this.onFieldSubmitted,
  }) : super(key: key);

  final TextEditingController controller;
  final bool obscureText;
  final bool autocorrect;
  final bool autofocus;
  final TextCapitalization textCapitalization;
  final InputDecoration? decoration;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final TextInputType keyboardType;
  final int maxLines;
  final int? minLines;
  final void Function(String?)? onChanged;
  final void Function(String?)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFormField(
        obscureText: obscureText,
        controller: controller,
        autocorrect: autocorrect,
        textCapitalization: textCapitalization,
        autofocus: autofocus,
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        decoration: decoration,
        maxLines: maxLines,
        minLines: minLines,
        onChanged: onChanged,
        validator: validator,
        onFieldSubmitted: onFieldSubmitted,
      ),
    );
  }
}
