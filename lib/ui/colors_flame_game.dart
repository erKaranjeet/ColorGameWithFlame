import 'package:color_game_with_flame/components/player_component.dart';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class ColorsFlameGame extends FlameGame with TapCallbacks {

  late PlayerComponent playerComponent;

  ColorsFlameGame() : super(
    camera: CameraComponent.withFixedResolution(
      width: 600,
      height: 1000,
    ),
  );

  @override
  Color backgroundColor() => const Color(0xFF222222);

  @override
  Future<void> onLoad() async {
    return super.onLoad();
  }

  @override
  void onMount() {
    world.add(playerComponent = PlayerComponent());
    super.onMount();
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
}