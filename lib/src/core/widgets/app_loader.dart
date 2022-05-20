import 'dart:ui';

import 'package:flutter/material.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({
    Key? key,
    required this.loading,
    required this.child,
  }) : super(key: key);

  final bool loading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (loading) {
          return false;
        } else {
          return true;
        }
      },
      child: Stack(
        children: [
          Positioned.fill(child: child),
          Positioned.fill(
            child: loading
                ? BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Container(
                      color: Colors.black12,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}
