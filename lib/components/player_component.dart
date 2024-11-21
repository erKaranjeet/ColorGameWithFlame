import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class PlayerComponent extends PositionComponent {

  PlayerComponent({
    this.playerRadius = 15,
  });

  final velocity = Vector2.zero();
  final gravity = 980.0;
  final jumpSpeed = 350.0;
  final double playerRadius;

  @override
  void onMount() {
    position = Vector2.zero();
    size = Vector2.all(playerRadius * 2);
    anchor = Anchor.center;
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
      (size / 2).toOffset(),
      playerRadius,
      Paint()..color = Colors.yellow,
    );
  }

  void jumpOnTap() {
    velocity.y = -jumpSpeed;
  }
}