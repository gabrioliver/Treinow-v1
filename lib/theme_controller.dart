import 'package:flutter/material.dart';

class MyAppThemeController extends InheritedWidget {
  final ThemeMode themeMode;
  final void Function(ThemeMode) setThemeMode;

  const MyAppThemeController({
    super.key,
    required this.themeMode,
    required this.setThemeMode,
    required super.child,
  });

  static MyAppThemeController? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyAppThemeController>();
  }

  @override
  bool updateShouldNotify(MyAppThemeController oldWidget) {
    return oldWidget.themeMode != themeMode;
  }
}
