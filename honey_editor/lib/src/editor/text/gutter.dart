import 'dart:convert';

// ignore: implementation_imports
import 'package:honey/src/compiler/antlr.dart';
import 'package:flutter/widgets.dart';
import 'package:honey_editor/src/helpers/line_counter.dart';
import 'package:honey_editor/src/theme/theme.dart';

import 'editor.dart';
import '../controller.dart';

class Gutter extends StatelessWidget {
  const Gutter({
    super.key,
    required this.editorController,
    required this.scrollController,
  });

  final ScrollController scrollController;
  final HoneyTalkEditorController editorController;

  static double get lineHeight =>
      HoneyTalkTextEditor.textStyle.fontSize! *
      HoneyTalkTextEditor.textStyle.height!;

  @override
  Widget build(BuildContext context) {
    final theme = HoneyEditorTheme.of(context);
    return AnimatedBuilder(
      animation: editorController,
      builder: (contex, _) {
        final numberOfLines = const LineCounter().count(editorController.text);
        final selectedLine = editorController.selection.baseOffset < 0
            ? 0
            : const LineCounter().count(
                editorController.text,
                editorController.selection.baseOffset,
              );
        return SizedBox(
          width: 40,
          child: ScrollConfiguration(
            behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: ListView.builder(
              controller: scrollController,
              padding: theme.editor.padding,
              itemCount: numberOfLines,
              itemBuilder: (BuildContext context, int index) {
                final hasError =
                    editorController.compilation?.errorLine == index;
                final isSelectedLine = index == selectedLine - 1;
                return SizedBox(
                  height: lineHeight,
                  child: Text(
                    (index + 1).toString(),
                    style: theme.editor
                        .styleForTokenType(HoneyTalkLexer.TOKEN_COMMENT)!
                        .copyWith(
                          color: hasError
                              ? const Color(0xFFFF0000)
                              : (isSelectedLine
                                  ? const Color(0xFF0000FF)
                                  : null),
                        ),
                    textAlign: TextAlign.end,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
