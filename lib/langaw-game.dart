import 'dart:math';
import 'dart:ui';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flutter/gestures.dart';

import 'package:mobile_gameflutterflame/components/fly.dart';
import 'package:mobile_gameflutterflame/components/backyard.dart';
import 'package:mobile_gameflutterflame/components/house-fly.dart';
import 'package:mobile_gameflutterflame/components/drooler-fly.dart';
import 'package:mobile_gameflutterflame/components/agile-fly.dart';
import 'package:mobile_gameflutterflame/components/hungry-fly.dart';
import 'package:mobile_gameflutterflame/components/macho-fly.dart';
import 'package:mobile_gameflutterflame/components/start-button.dart';

import 'package:mobile_gameflutterflame/view.dart';
import 'package:mobile_gameflutterflame/views/home-view.dart';
import 'package:mobile_gameflutterflame/views/lost-view.dart';
import 'package:mobile_gameflutterflame/controllers/spawner.dart';

class LangawGame extends Game {
  Size screenSize;
  double tileSize;
  Backyard background;
  List<Fly> flies;
  StartButton startButton;
  FlySpawner spawner;
  Random rnd;

  View activeView = View.home;
  HomeView homeView;
  LostView lostView;

  LangawGame() {
    initialize();
  }

  void initialize() async {
    flies = List<Fly>();
    rnd = Random();
    resize(await Flame.util.initialDimensions());

    background = Backyard(this);
    startButton = StartButton(this);
    homeView = HomeView(this);
    lostView = LostView(this);
    spawner = FlySpawner(this);
  }

  void spawnFly() {
    double x = rnd.nextDouble() * (screenSize.width - tileSize * 2.025);
    double y = rnd.nextDouble() * (screenSize.height - tileSize * 2.025);
    switch (rnd.nextInt(5)) {
      case 0:
        flies.add(HouseFly(this, x, y));
        break;
      case 1:
        flies.add(DroolerFly(this, x, y));
        break;
      case 2:
        flies.add(AgileFly(this, x, y));
        break;
      case 3:
        flies.add(HungryFly(this, x, y));
        break;
      case 4:
        flies.add(MachoFly(this, x, y));
        break;
    }
  }

  void render(Canvas canvas) {
    background.render(canvas);

    flies.forEach((Fly fly) => fly.render(canvas));
    if (activeView == View.home) homeView.render(canvas);
    if (activeView == View.lost) lostView.render(canvas);
    if (activeView == View.home || activeView == View.lost) {
      startButton.render(canvas);
    }
  }

  void update(double t) {
    flies.forEach((Fly fly) => fly.update(t));
    flies.removeWhere((Fly fly) => fly.isOffScreen);
    spawner.update(t);
  }

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 9;
  }

  void onTapDown(TapDownDetails d) {
    bool isHandled = false;
    bool didHitAFly = false;

    if (!isHandled && startButton.rect.contains(d.globalPosition)) {
      if (activeView == View.home || activeView == View.lost) {
        startButton.onTapDown();
        isHandled = true;
      }
    }

    if (!isHandled) {
      flies.forEach((Fly fly) {
        if (fly.flyRect.contains(d.globalPosition)) {
          fly.onTapDown();
          isHandled = true;
          didHitAFly = true;
        }
      });
      if (activeView == View.playing && !didHitAFly) {
        activeView = View.lost;
      }
    }
  }
}
