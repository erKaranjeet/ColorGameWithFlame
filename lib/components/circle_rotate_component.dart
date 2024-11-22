import 'dart:ui';
import 'dart:math' as math;

import 'package:color_game_with_flame/components/circle_arc_component.dart';
import 'package:color_game_with_flame/ui/colors_flame_game.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

class CircleRotateComponent extends PositionComponent
    with HasGameRef<ColorsFlameGame> {
  CircleRotateComponent({
    required super.position,
    required super.size,
    this.thickness = 8,
    this.rotateSpeed = 2,
  })  : assert(size!.x == size.y),
        super(anchor: Anchor.center);

  final double thickness, rotateSpeed;

  @override
  void onLoad() {
    super.onLoad();

    const circle = math.pi * 2;
    final sweep = circle / gameRef.gameColors.length;
    for (int i = 0; i < gameRef.gameColors.length; i++) {
      add(CircleArcComponent(
        color: gameRef.gameColors[i],
        startAngle: i * sweep,
        sweepAngle: sweep,
      ));
    }
    add(RotateEffect.to(
      math.pi * 2,
      EffectController(
        speed: rotateSpeed,
        infinite: true,
      ),
    ));
  }
}
