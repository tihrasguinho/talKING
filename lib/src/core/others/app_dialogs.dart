import 'package:flutter/material.dart';
import 'package:talking/src/core/utils/navigator_key.dart';

class AppDialogs {
  static Future<void> simple({required Widget child, bool barrierDismissible = true}) async {
    await showGeneralDialog(
      context: navigator.context,
      barrierLabel: '',
      barrierDismissible: barrierDismissible,
      transitionDuration: const Duration(milliseconds: 350),
      transitionBuilder: (context, first, second, child) {
        final tween = Tween(begin: 0.0, end: 1.0);
        final curved = CurvedAnimation(parent: first, curve: Curves.elasticInOut);

        return ScaleTransition(
          scale: curved.drive(tween),
          child: child,
        );
      },
      pageBuilder: (context, first, second) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: child,
        );
      },
    );
  }
}
