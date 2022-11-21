import 'package:flutter/material.dart';
import 'package:honey_editor/src/editor/text/editor.dart';
import 'package:honey_editor/src/editor/text/gutter.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

import 'controller.dart';

class HoneyEditor extends StatefulWidget {
  const HoneyEditor({
    super.key,
  });

  @override
  State<HoneyEditor> createState() => _HoneyEditorState();
}

class _HoneyEditorState extends State<HoneyEditor> {
  final editorController = HoneyTalkEditorController();
  final _controllers = LinkedScrollControllerGroup();
  late final gutterScrollController = _controllers.addAndGet();
  late final textScrollController = _controllers.addAndGet();

  @override
  void dispose() {
    editorController.dispose();
    gutterScrollController.dispose();
    textScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Positioned.fill(
            child: Gutter(
              scrollController: gutterScrollController,
              editorController: editorController,
            ),
          ),
          Positioned.fill(
            child: HoneyTalkTextEditor(
              scrollController: textScrollController,
              editorController: editorController,
            ),
          )
        ],
      ),
    );
  }
}
