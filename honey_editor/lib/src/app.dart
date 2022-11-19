import 'package:flutter/material.dart';
import 'package:honey_editor/src/theme/theme.dart';

import 'editor/editor.dart';
import 'theme/themes.dart';

class HoneyEditorApp extends StatelessWidget {
  const HoneyEditorApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return HoneyEditorTheme(
      data: HoneyEditorThemes.clickupDark,
      child: MaterialApp(
        title: 'Honey Editor',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HoneyEditor(),
      ),
    );
  }
}
