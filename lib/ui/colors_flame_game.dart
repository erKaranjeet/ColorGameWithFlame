import 'dart:math';

import 'package:color_game_with_flame/components/circle_rotate_component.dart';
import 'package:color_game_with_flame/components/color_switch_component.dart';
import 'package:color_game_with_flame/components/ground_component.dart';
import 'package:color_game_with_flame/components/player_component.dart';
import 'package:color_game_with_flame/components/star_component.dart';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

class ColorsFlameGame extends FlameGame
    with TapCallbacks, HasCollisionDetection {
  late PlayerComponent playerComponent;
  final List<Color> gameColors;

  ValueNotifier<int> currentScore = ValueNotifier(0);
  final List<PositionComponent> gameComponents = [];
  ValueNotifier<bool> isGameOver = ValueNotifier(false);

  ColorsFlameGame({
    this.gameColors = const [
      Colors.redAccent,
      Colors.greenAccent,
      Colors.blueAccent,
      Colors.yellowAccent,
    ],
  }) : super(
          camera: CameraComponent.withFixedResolution(
            width: 600,
            height: 1000,
          ),
        );

  @override
  Color backgroundColor() => const Color(0xFF222222);

  @override
  Future<void> onLoad() async {
    FlameAudio.bgm.initialize();
    return super.onLoad();
  }

  @override
  void onMount() {
    initGameComponents();
    super.onMount();
  }

  Future<void> initGameComponents() async {
    currentScore.value = 0;
    world.add(GroundComponent(position: Vector2(0, 400)));
    world.add(playerComponent = PlayerComponent(position: Vector2(0, 250)));
    try {
      await FlameAudio.bgm.stop();
    } on Exception catch (e) {
      debugPrint(e.toString());
    } finally {
      await FlameAudio.bgm.play('background_music.mp3');
    }

    setupGameComponents(Vector2(0, 0));
    camera.moveTo(Vector2.zero());
  }

  void setupGameComponents(Vector2 randomPosition) {
    final random = Random().nextInt(1000);
    bool isEven = random % 2 == 0;
    //First batch
    addComponentsToGame(ColorSwitchComponent(
      position: randomPosition + Vector2(0, 200),
    ));
    addComponentsToGame(CircleRotateComponent(
      position: randomPosition + Vector2(0, 0),
      size: Vector2(220, 220),
    ));
    addComponentsToGame(StarComponent(position: randomPosition + Vector2(0, 0)));

    //Second batch
    randomPosition -= Vector2(0, 400);
    addComponentsToGame(ColorSwitchComponent(
      position: randomPosition + Vector2(0, 150),
    ));
    addComponentsToGame(CircleRotateComponent(
      position: randomPosition + Vector2(0, -100),
      size: Vector2(220, 220),
    ));
    addComponentsToGame(StarComponent(position: randomPosition + Vector2(0, -100)));

    //Third batch
    randomPosition -= Vector2(0, 400);
    addComponentsToGame(ColorSwitchComponent(
      position: randomPosition + Vector2(0, 50),
    ));
    if (isEven) {
      addComponentsToGame(CircleRotateComponent(
      position: randomPosition + Vector2(0, -200),
      size: Vector2(180, 180),
    ));
    }
    addComponentsToGame(CircleRotateComponent(
      position: randomPosition + Vector2(0, -200),
      size: Vector2(220, 220),
    ));
    addComponentsToGame(StarComponent(position: randomPosition + Vector2(0, -200)));
  }

  void addComponentsToGame(PositionComponent component) {
    gameComponents.add(component);
    world.add(component);
  }

  @override
  void update(double dt) {
    final cameraY = camera.viewfinder.position.y;
    final playerY = playerComponent.position.y;

    if (playerY < cameraY) {
      camera.viewfinder.position = Vector2(0, playerY);
    }

    super.update(dt);
  }

  @override
  void onTapDown(TapDownEvent event) {
    playerComponent.jumpOnTap();
    super.onTapDown(event);
  }

  void gameOver() {
    FlameAudio.bgm.stop();
    for (var element in world.children) {
      element.removeFromParent();
    }
    isGameOver.value = true;
  }

  bool get isGamePaused => paused;
  void pauseGame() {
    FlameAudio.bgm.pause();
    pauseEngine();
  }

  void resumeGame() {
    FlameAudio.bgm.resume();
    resumeEngine();
  }

  void increaseScore() {
    currentScore.value ++;
  }

  void checkForTheNextBatch(StarComponent starComponent) {
    final allStars = gameComponents.whereType<StarComponent>().toList();
    final length = allStars.length;

    for (int i=0; i<allStars.length; i++) {
      if (starComponent == allStars[i] && i >= length - 2) {
        final lastStar = allStars.last;
        setupGameComponents(lastStar.position - Vector2(0, 400));
        removeOuterComponents(starComponent);
      }
    }
  }

  void removeOuterComponents(StarComponent starComponent) {
    final length = gameComponents.length;
    for (int i=0; i<gameComponents.length; i++) {
      if (starComponent == gameComponents[i] && i >= 15) {
        for (int j=i-6; j>=0; j--) {
          gameComponents[j].removeFromParent();
          gameComponents.removeAt(j);
        }
        break;
      }
    }
  }
}