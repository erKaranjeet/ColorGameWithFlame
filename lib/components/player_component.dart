import 'package:color_game_with_flame/components/circle_arc_component.dart';
import 'package:color_game_with_flame/components/color_switch_component.dart';
import 'package:color_game_with_flame/components/ground_component.dart';
import 'package:color_game_with_flame/components/star_component.dart';
import 'package:color_game_with_flame/ui/colors_flame_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flame/particles.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

class PlayerComponent extends PositionComponent with HasGameRef<ColorsFlameGame>, CollisionCallbacks {

  PlayerComponent({
    required super.position,
    this.playerRadius = 12,
  }) : super();

  final velocity = Vector2.zero();
  final gravity = 980.0;
  final jumpSpeed = 350.0;
  final double playerRadius;
  late Color playerColor = Colors.white;

  @override
  void onLoad() {
    super.onLoad();
    add(CircleHitbox(
      radius: playerRadius,
      anchor: anchor,
      collisionType: CollisionType.active,
    ));
  }
  
  @override
  void onMount() {
    size = Vector2.all(playerRadius * 2);
    anchor = Anchor.center;
    super.onMount();
  }

  @override
  void update(double dt) {
    super.update(dt);

    position += velocity * dt;

    GroundComponent groundComponent = gameRef.findByKeyName(
        GroundComponent.keyName)!;

    if (positionOfAnchor(Anchor.bottomCenter).y > groundComponent.position.y) {
      velocity.setValues(0, 0);
      position = Vector2(0, groundComponent.position.y - (height / 2));
    } else {
      velocity.y += gravity * dt;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    canvas.drawCircle(
      (size / 2).toOffset(),
      playerRadius,
      Paint()..color = playerColor,
    );
  }

  void jumpOnTap() {
    velocity.y = -jumpSpeed;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    debugPrint('PlayerComponent.onCollision($intersectionPoints, $other)');

    if (other is ColorSwitchComponent) {
      other.removeFromParent();
      changeColorRandomly();
    } else if (other is CircleArcComponent) {
      if (playerColor != other.color) {
        gameRef.gameOver();
      }
    } else if (other is StarComponent) {
      other.showCollectEffect();
      gameRef.increaseScore();
      FlameAudio.play('collect_score.wav');

      gameRef.checkForTheNextBatch(other);
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    debugPrint('PlayerComponent.onCollisionEnd($other)');
  }

  void changeColorRandomly() {
    playerColor = gameRef.gameColors.random();
  }
}