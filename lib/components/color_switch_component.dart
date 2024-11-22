import 'dart:ui';
import 'dart:math' as math;

import 'package:color_game_with_flame/ui/colors_flame_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ColorSwitchComponent extends PositionComponent with HasGameRef<ColorsFlameGame>, CollisionCallbacks {
  ColorSwitchComponent({
    required super.position,
    this.radius = 24,
  }) : super(anchor: Anchor.center, size: Vector2.all(radius * 2),);

  final double radius;

  @override
  void onLoad() {
    super.onLoad();
    add(CircleHitbox(
      position: size / 2,
      radius: radius,
      anchor: anchor,
      collisionType: CollisionType.passive,
    ));
  }

  @override
  void render(Canvas canvas) {
   final length = gameRef.gameColors.length;
   final sweepAngle = (math.pi * 2) / length;

   for (int i=0; i<length; i++) {
     canvas.drawArc(
       size.toRect(),
       i * sweepAngle,
       sweepAngle,
       true,
       Paint()..color = gameRef.gameColors[i],
     );
   }
  }
}
