import 'package:flutter/material.dart';

class SnackbarUtil {
  static void showSnackbar(BuildContext context, String message, int time) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: time), // Adjust the duration as needed
      ),
    );
  }
}
