import 'dart:ui';

import 'package:flutter/painting.dart';
import 'package:mobile_gameflutterflame/langaw-game.dart';

class HighScoreDisplay {
  final LangawGame game;
  TextPainter painter;
  TextStyle textStyle;
  Offset position;

  HighScoreDisplay(this.game) {
    painter = TextPainter(
        textAlign: TextAlign.center, textDirection: TextDirection.ltr);

    Shadow shadow =
        Shadow(blurRadius: 3, color: Color(0xff000000), offset: Offset.zero);

    textStyle = TextStyle(
      color: Color(0xffffffff),
      fontSize: 30,
      shadows: [
        shadow,
        shadow,
        shadow,
        shadow,
      ],
    );

    position = Offset.zero;

    updateHighScore();
  }

  void updateHighScore() {
    int highscore = game.storage.getInt('highscore') ?? 0;

    painter.text =
        TextSpan(text: 'High-Score:' + highscore.toString(), style: textStyle);

    painter.layout();

    position = Offset(
      game.screenSize.width - (game.tileSize * .25) - painter.width,
      game.tileSize * .25,
    );
  }

  void render(Canvas canvas) {
    painter.paint(canvas, position);
  }
}
