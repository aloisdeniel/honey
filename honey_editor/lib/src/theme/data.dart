// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/rendering.dart';
import 'package:collection/collection.dart';

class HoneyEditorThemeData {
  const HoneyEditorThemeData({
    required this.editor,
  });

  final HoneyTextEditorTheme editor;
}

class HoneyTextEditorTheme {
  const HoneyTextEditorTheme({
    required this.formatStyles,
    required this.padding,
  });
  final List<HoneyTalkTokenStyle> formatStyles;
  final EdgeInsets padding;

  TextStyle? styleForTokenType(int tokenType) {
    return formatStyles
        .firstWhereOrNull((element) => element.tokens.contains(tokenType))
        ?.style;
  }
}

class HoneyTalkTokenStyle {
  const HoneyTalkTokenStyle(
    this.tokens,
    this.style,
  );
  final List<int> tokens;
  final TextStyle style;
}
