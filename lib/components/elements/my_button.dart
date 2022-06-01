import 'package:flutter/material.dart';
import '../../utility_methods.dart';

class MyButton extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  MyButton({
    Key? key,
    required this.label,
    required this.onPressed,
    required this.primary,
    this.fontSize = 18.0,
    this.verticalPadding = 20,
    this.horizontalPadding = 30,
  }) : super(key: key);

  final String label;
  final double fontSize;
  final double verticalPadding;
  final double horizontalPadding;
  final Color primary;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        side: const BorderSide(
          width: 1.0,
          color: Colors.white,
        ),
        primary: primary,
        shape: kRoundedRectangleBorder,
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: horizontalPadding,
        ),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: kTextStyle(size: fontSize).copyWith(
          color: Theme.of(context).textTheme.bodyText1?.color,
        ),
      ),
    );
  }
}
