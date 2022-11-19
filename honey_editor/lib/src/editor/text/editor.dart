import 'package:flutter/material.dart';
import 'package:honey_editor/src/theme/theme.dart';

import '../controller.dart';

class HoneyTalkTextEditor extends StatelessWidget {
  const HoneyTalkTextEditor({
    super.key,
    required this.editorController,
    required this.scrollController,
  });

  final ScrollController scrollController;
  final HoneyTalkEditorController editorController;

  static const textStyle = TextStyle(
    fontFamily: 'FiraCode',
    fontSize: 12,
    height: 1.4,
  );

  @override
  Widget build(BuildContext context) {
    final theme = HoneyEditorTheme.of(context);
    return TextField(
      scrollController: scrollController,
      controller: editorController,
      maxLines: null,
      style: HoneyTalkTextEditor.textStyle,
      expands: true,
      scrollPadding: EdgeInsets.zero,
      decoration: InputDecoration(
        contentPadding: theme.editor.padding.copyWith(left: 0),
        isDense: true,
      ),
    );
  }
}
