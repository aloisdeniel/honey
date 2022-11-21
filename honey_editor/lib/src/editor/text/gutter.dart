// ignore: implementation_imports
import 'package:honey/src/compiler/antlr.dart';
import 'package:flutter/widgets.dart';
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
        final numberOfLines = editorController.numberOfLines;
        final selectedLine = editorController.selectedLine;
        return ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.zero,
            itemCount: numberOfLines,
            itemBuilder: (BuildContext context, int index) {
              final hasError = index == editorController.compilation?.errorLine;
              final isSelectedLine = index == selectedLine - 1;
              return Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF000000)
                      .withAlpha(isSelectedLine ? 10 : 0),
                ),
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: lineHeight,
                  width: 40,
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
                ),
              );
            },
          ),
        );
      },
    );
  }
}
