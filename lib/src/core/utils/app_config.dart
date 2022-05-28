import 'package:flutter/material.dart';

class AppConfig extends InheritedWidget {
  AppConfig(Widget child, {Key? key}) : super(key: key, child: child);

  final _size = ValueNotifier<Size>(Size.zero);

  void setSize(Size size) => _size.value = size;

  Size get size => _size.value;

  static AppConfig of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppConfig>()!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}
