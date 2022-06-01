import 'package:flutter/material.dart';
import '../../utility_methods.dart';

void showConfirmDialog({
  required BuildContext context,
  required String message,
  required void Function()? onPressed,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Confirm Dialog"),
        content: Text(
          message,
          style: kTextStyle(size: 16.0),
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: const Text("OK"),
            onPressed: onPressed,
          ),
        ],
      );
    },
  );
}
