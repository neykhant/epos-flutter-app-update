import 'package:flutter/material.dart';

void showToast(BuildContext context, String message) {
  final ScaffoldMessengerState scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 1),
    ),
  );
}
