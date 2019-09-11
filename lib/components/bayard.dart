import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:mobile_gameflutterflame/langaw-game.dart';

class Backyard {
  final LangawGame game;
  Sprite bgSprite;
  Rect bgRect;

  Backyard(this.game) {
    bgSprite = Sprite('bg/backyard.png');
    bgRect = Rect.fromLTWH(0, game.screenSize.height - (game.tileSize * 23),
        game.tileSize * 9, game.tileSize * 23);
  }

  void render(Canvas canvas) {
    bgSprite.renderRect(canvas, bgRect);
  }

  void update(double t) {}
}
