import 'package:color_game_with_flame/components/player_component.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class ColorsFlameGame extends FlameGame with TapCallbacks {

  late PlayerComponent playerComponent;

  @override
  Color backgroundColor() => const Color(0xFF222222);

  @override
  Future<void> onLoad() async {
    return super.onLoad();
  }

  @override
  void onMount() {
    add(playerComponent = PlayerComponent());
    super.onMount();
  }

  @override
  void onTapDown(TapDownEvent event) {
    playerComponent.jumpOnTap();
    super.onTapDown(event);
  }
}