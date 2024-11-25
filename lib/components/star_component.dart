import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flame/rendering.dart';
import 'package:flutter/material.dart';

class StarComponent extends PositionComponent {
  late Sprite starSprite;

  StarComponent({required super.position})
      : super(
          size: Vector2(28, 28),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    starSprite = await Sprite.load('ic_star_stroke.png');

    add(CircleHitbox(
      radius: size.x / 2,
      collisionType: CollisionType.passive,
    ));
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    starSprite.render(
      canvas,
      position: size / 2,
      size: size,
      anchor: Anchor.center,
    );
  }

  void showCollectEffect() {
    final random = Random();
    Vector2 randomVector2() =>
        (Vector2.random(random) - Vector2.random(random)) * 80;

    parent?.add(
      ParticleSystemComponent(
        position: position,
        particle: Particle.generate(
          count: 30,
          lifespan: 0.8,
          generator: (i) {
            return AcceleratedParticle(
              speed: randomVector2(),
              acceleration: randomVector2(),
              child: RotatingParticle(
                to: random.nextDouble() * pi * 2,
                child: ComputedParticle(
                  renderer: (canvas, particle) {
                    starSprite.render(
                      canvas,
                      size: size * (1 - particle.progress),
                      anchor: Anchor.center,
                      overridePaint: Paint()
                        ..color = Colors.white.withOpacity(
                          1 - particle.progress,
                        ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
    removeFromParent();
  }
}
