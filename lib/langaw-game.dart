import 'dart:math';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
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
import 'package:mobile_gameflutterflame/components/help-button.dart';
import 'package:mobile_gameflutterflame/components/credits-button.dart';
import 'package:mobile_gameflutterflame/components/score-display.dart';
import 'package:mobile_gameflutterflame/components/highscore-display.dart';
import 'package:mobile_gameflutterflame/components/music-button.dart';
import 'package:mobile_gameflutterflame/components/sound-control.dart';

import 'package:mobile_gameflutterflame/view.dart';
import 'package:mobile_gameflutterflame/views/home-view.dart';
import 'package:mobile_gameflutterflame/views/lost-view.dart';
import 'package:mobile_gameflutterflame/views/help-view.dart';
import 'package:mobile_gameflutterflame/views/credits-view.dart';
import 'package:mobile_gameflutterflame/controllers/spawner.dart';

class LangawGame extends Game {
  Size screenSize;
  double tileSize;
  Backyard background;
  List<Fly> flies;
  StartButton startButton;
  HelpButton helpButton;
  HelpView helpView;
  CreditsView creditsView;
  CreditsButton creditsButton;
  FlySpawner spawner;
  Random rnd;
  int score;
  ScoreDisplay scoreDisplay;
  HighScoreDisplay highScoreDisplay;
  final SharedPreferences storage;
  AudioPlayer homeBGM;
  AudioPlayer playingBGM;
  MusicButton musicButton;
  SoundButton soundButton;

  View activeView = View.home;
  HomeView homeView;
  LostView lostView;

  LangawGame(this.storage) {
    initialize();
  }

  void initialize() async {
    flies = List<Fly>();
    rnd = Random();
    resize(await Flame.util.initialDimensions());

    background = Backyard(this);
    startButton = StartButton(this);
    helpButton = HelpButton(this);
    creditsButton = CreditsButton(this);
    homeView = HomeView(this);
    lostView = LostView(this);
    helpView = HelpView(this);
    creditsView = CreditsView(this);
    spawner = FlySpawner(this);
    scoreDisplay = ScoreDisplay(this);
    highScoreDisplay = HighScoreDisplay(this);
    musicButton = MusicButton(this);
    soundButton = SoundButton(this);
    homeBGM = await Flame.audio.loop('bgm/home.mp3', volume: .25);

    playingBGM = await Flame.audio.loop('bgm/playing.mp3', volume: .25);

    playHomeBGM();

    score = 0;
  }

  void playHomeBGM() {
    homeBGM.resume();
  }

  void playPlayingBGM() {
    playingBGM.resume();
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
    highScoreDisplay.render(canvas);
    musicButton.render(canvas);
    soundButton.render(canvas);

    flies.forEach((Fly fly) => fly.render(canvas));
    if (activeView == View.home) homeView.render(canvas);
    if (activeView == View.lost) lostView.render(canvas);

    if (activeView == View.home || activeView == View.lost) {
      startButton.render(canvas);
      helpButton.render(canvas);
      creditsButton.render(canvas);
    }
    if (activeView == View.help) helpView.render(canvas);
    if (activeView == View.credits) creditsView.render(canvas);
    if (activeView == View.playing) scoreDisplay.render(canvas);
  }

  void update(double t) {
    flies.forEach((Fly fly) => fly.update(t));
    flies.removeWhere((Fly fly) => fly.isOffScreen);
    spawner.update(t);
    if (activeView == View.playing) scoreDisplay.update(t);
  }

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 9;
  }

  void onTapDown(TapDownDetails d) {
    bool isHandled = false;
    bool didHitAFly = false;
// dialog boxes
    if (!isHandled) {
      if (activeView == View.help || activeView == View.credits) {
        activeView = View.home;
        isHandled = true;
      }
    }
    // music button
    if (!isHandled && musicButton.rect.contains(d.globalPosition)) {
      musicButton.onTapDown();
      isHandled = true;
    }

// sound button
    if (!isHandled && soundButton.rect.contains(d.globalPosition)) {
      soundButton.onTapDown();
      isHandled = true;
    }
    // credits button
    if (!isHandled && startButton.rect.contains(d.globalPosition)) {
      if (activeView == View.home || activeView == View.lost) {
        startButton.onTapDown();
        isHandled = true;
      }
    }
    // help button
    if (!isHandled && helpButton.rect.contains(d.globalPosition)) {
      if (activeView == View.home || activeView == View.lost) {
        helpButton.onTapDown();
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
        Flame.audio.play('sfx/haha' + (rnd.nextInt(5) + 1).toString() + '.ogg');
        activeView = View.lost;
      }
    }
    // help button
    if (!isHandled && helpButton.rect.contains(d.globalPosition)) {
      if (activeView == View.home || activeView == View.lost) {
        helpButton.onTapDown();
        isHandled = true;
      }
    }
    if (soundButton.isEnabled) {
      Flame.audio.play('sfx/haha' + (rnd.nextInt(5) + 1).toString() + '.ogg');
    }

    // credits button
    if (!isHandled && creditsButton.rect.contains(d.globalPosition)) {
      if (activeView == View.home || activeView == View.lost) {
        creditsButton.onTapDown();
        isHandled = true;
      }
    }
  }
}
