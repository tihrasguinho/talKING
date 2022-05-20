import 'package:flutter/material.dart';
import 'package:talking/src/core/utils/navigator_key.dart';

class AppSnackbars {
  static void error(String message) {
    ScaffoldMessenger.of(navigator.context).hideCurrentSnackBar();
    ScaffoldMessenger.of(navigator.context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: Theme.of(navigator.context).textTheme.subtitle2!.copyWith(
                color: Colors.white,
              ),
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 5),
      ),
    );
  }

  static void success(String message) {
    ScaffoldMessenger.of(navigator.context).hideCurrentSnackBar();
    ScaffoldMessenger.of(navigator.context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: Theme.of(navigator.context).textTheme.subtitle2!.copyWith(
                color: Colors.white,
              ),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 5),
      ),
    );
  }
}
