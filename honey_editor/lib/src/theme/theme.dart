import 'package:flutter/widgets.dart';

import 'data.dart';

class HoneyEditorTheme extends InheritedWidget {
  const HoneyEditorTheme({
    super.key,
    required super.child,
    required this.data,
  });

  final HoneyEditorThemeData data;

  static HoneyEditorThemeData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<HoneyEditorTheme>()!.data;
  }

  @override
  bool updateShouldNotify(covariant HoneyEditorTheme oldWidget) {
    return oldWidget.data != data;
  }
}
