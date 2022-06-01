import 'package:flutter/material.dart';
import '../../utility_methods.dart';

class MyFormWrapper extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  MyFormWrapper({
    Key? key,
    required this.formKey,
    required this.height,
    required this.children,
    this.formWidth = 450.0,
    this.color = Colors.white,
  }) : super(key: key);

  final GlobalKey<FormState> formKey;
  final double height;
  final List<Widget> children;
  final double formWidth;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0),
        child: Center(
          child: Container(
            decoration: kBackgroundContainer.copyWith(
              color: color,
            ),
            width: formWidth,
            height: height,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: children,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
