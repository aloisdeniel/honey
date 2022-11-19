// ignore: implementation_imports
import 'package:honey/src/compiler/antlr.dart';
import 'package:flutter/rendering.dart';

import 'data.dart';

abstract class HoneyEditorThemes {
  static final clickupDark = HoneyEditorThemeData(
    editor: HoneyTextEditorTheme(
      padding: const EdgeInsets.all(8),
      formatStyles: <HoneyTalkTokenStyle>[
        const HoneyTalkTokenStyle(
          [
            HoneyTalkLexer.TOKEN_STRING_LITERAL,
          ],
          TextStyle(
            color: Color(0xFF00FF00),
          ),
        ),
        const HoneyTalkTokenStyle(
          [
            HoneyTalkLexer.TOKEN_COMMENT,
            HoneyTalkLexer.TOKEN_MULTILINE_COMMENT,
          ],
          TextStyle(
            color: Color(0xFFAAAAAA),
          ),
        ),
        HoneyTalkTokenStyle(
          List.generate(265, (index) => index),
          const TextStyle(
            color: Color.fromARGB(255, 159, 56, 206),
          ),
        ),
      ],
    ),
  );
}
