import 'package:flutter/material.dart';

class SnackBarService {
  static showSnackBar({
    required BuildContext context,
    required String message,
    SnackBarBehavior? behavior,
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
        backgroundColor: backgroundColor,
        content: Text(
          message,
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
      ),
    );
  }
}
