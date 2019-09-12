import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:mobile_gameflutterflame/langaw-game.dart';
import 'package:mobile_gameflutterflame/view.dart';

class HelpButton {
  final LangawGame game;
  Rect rect;
  Sprite sprite;

  HelpButton(this.game) {
    rect = Rect.fromLTWH(
        game.tileSize * .25,
        game.screenSize.height - (game.tileSize * 1.25),
        game.tileSize,
        game.tileSize);
    sprite = Sprite('ui/icon-help.png');
  }

  void render(Canvas canvas) {
    sprite.renderRect(canvas, rect);
  }

  void onTapDown() {
    game.activeView = View.help;
  }
}
