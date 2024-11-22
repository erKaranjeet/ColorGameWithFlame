import 'package:color_game_with_flame/components/circle_rotate_component.dart';
import 'package:color_game_with_flame/components/color_switch_component.dart';
import 'package:color_game_with_flame/components/ground_component.dart';
import 'package:color_game_with_flame/components/player_component.dart';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class ColorsFlameGame extends FlameGame with TapCallbacks, HasCollisionDetection {
  late PlayerComponent playerComponent;
  final List<Color> gameColors;

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
    return super.onLoad();
  }

  @override
  void onMount() {
    initGameComponents();
    debugMode = true;
    super.onMount();
  }

  void initGameComponents() {
    world.add(GroundComponent(position: Vector2(0, 400)));
    world.add(playerComponent = PlayerComponent(position: Vector2(0, 250)));
    world.add(ColorSwitchComponent(
      position: Vector2(0, 200),
    ));
    world.add(CircleRotateComponent(
      position: Vector2(0, 0),
      size: Vector2(220, 220),
    ));

    camera.moveTo(Vector2.zero());
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
    for (var element in world.children) {
      element.removeFromParent();
    }

    initGameComponents();
  }
}
