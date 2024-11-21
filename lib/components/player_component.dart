import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class PlayerComponent extends PositionComponent {

  final velocity = Vector2(0, 30.0);
  final gravity = 980.0;
  final jumpSpeed = 350.0;

  @override
  void onMount() {
    position = Vector2(100, 100);
    super.onMount();
  }

  @override
  void update(double dt) {
    super.update(dt);

    position += velocity * dt;
    velocity.y += gravity * dt;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    canvas.drawCircle(
      position.toOffset(),
      15,
      Paint()..color = Colors.yellow,
    );
  }

  void jumpOnTap() {
    velocity.y = -jumpSpeed;
  }
}