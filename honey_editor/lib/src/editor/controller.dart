// ignore_for_file: implementation_imports, depend_on_referenced_packages

import 'package:flutter/widgets.dart';
import 'package:honey/src/compiler/antlr.dart';
import 'package:honey/src/compiler/compile.dart';
import 'package:antlr4/antlr4.dart';
import 'package:honey_editor/src/helpers/line_counter.dart';

import '../theme/theme.dart';

class HoneyTalkEditorController extends TextEditingController {
  HoneyTalkEditorController({
    super.text,
  });

  CompilationResult? compilation;

  int get numberOfLines {
    return const LineCounter().count(value.text);
  }

  int get selectedLine {
    return selection.baseOffset < 0
        ? 0
        : const LineCounter().count(
            text,
            selection.baseOffset,
          );
  }

  @override
  set value(TextEditingValue newValue) {
    compilation = compileHoneyTalk(newValue.text);
    super.value = newValue;
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final theme = HoneyEditorTheme.of(context);
    final chars = InputStream.fromString(text);
    final lexer = HoneyTalkLexer(chars);
    final tokens = CommonTokenStream(lexer);
    tokens.fill();

    final children = <TextSpan>[];
    var previousTokenEnd = 0;

    for (var token in tokens.tokens) {
      if (previousTokenEnd < token.startIndex) {
        children.add(
          TextSpan(
            text: text.substring(previousTokenEnd, token.startIndex),
          ),
        );
      }
      if (token.type >= 0) {
        final tokenStyle = theme.editor.styleForTokenType(token.type);
        children.add(
          TextSpan(
            text: token.text,
            style: style?.merge(tokenStyle) ?? tokenStyle,
          ),
        );
      }
      previousTokenEnd = token.stopIndex + 1;
    }

    if (previousTokenEnd < text.length) {
      children.add(
        TextSpan(
          text: text.substring(previousTokenEnd, text.length),
        ),
      );
    }

    return TextSpan(
      style: style,
      children: children,
    );
  }
}
