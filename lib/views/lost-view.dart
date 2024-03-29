import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:mobile_gameflutterflame/langaw-game.dart';

class LostView {
  final LangawGame game;
  Rect rect;
  Sprite sprite;

  LostView(this.game) {
    rect = Rect.fromLTWH(
        game.tileSize,
        (game.screenSize.height / 2) - (game.tileSize * 5),
        game.tileSize * 7,
        game.tileSize * 5);
    sprite = Sprite('bg/lose-splash.png');
  }

  void render(Canvas canvas) {
    sprite.renderRect(canvas, rect);
  }

  void update(double t) {}
}
