import 'package:flutter/material.dart';
import '../../utility_methods.dart';

void showAlertDialog({required BuildContext context, required String message}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Alert Dialog"),
        content: Text(
          message,
          style: kTextStyle(size: 16.0),
        ),
        actions: [
          TextButton(
            child: const Text("Continue"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
