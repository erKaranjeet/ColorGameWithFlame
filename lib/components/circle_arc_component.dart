import 'dart:math' as math;

import 'package:color_game_with_flame/components/circle_rotate_component.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class CircleArcComponent extends PositionComponent
    with ParentIsA<CircleRotateComponent> {
  final Color color;
  final double startAngle, sweepAngle;

  CircleArcComponent({
    required this.color,
    required this.startAngle,
    required this.sweepAngle,
  }) : super(anchor: Anchor.center);

  @override
  void onMount() {
    size = parent.size;
    position = size / 2;
    
    addPolygonHitBox();

    super.onMount();
  }

  void addPolygonHitBox() {
    final center = size / 2;
    const precision = 8;
    final segment =  sweepAngle / (precision -1);
    final radius = size.x / 2;

    List<Vector2> vertices = [];
    for (int i=0; i<precision; i++) {
      final thisSegment = startAngle + segment * i;
      vertices.add(center + Vector2(math.cos(thisSegment), math.sin(thisSegment)) * radius,);
    }

    for (int i=precision-1; i>=0; i--) {
      final thisSegment = startAngle + segment * i;
      vertices.add(center + Vector2(math.cos(thisSegment), math.sin(thisSegment)) * (radius - parent.thickness),);
    }

    add(PolygonHitbox(vertices, collisionType: CollisionType.passive,));
  }

  @override
  void render(Canvas canvas) {
    canvas.drawArc(
      size.toRect().deflate(parent.thickness / 2),
      startAngle,
      sweepAngle,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = parent.thickness,
    );
  }
}
