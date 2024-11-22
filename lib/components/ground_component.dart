import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class GroundComponent extends PositionComponent {
  static const String keyName = 'single_ground_key';

  GroundComponent({required super.position})
      : super(
          size: Vector2(
            200,
            2,
          ),
          anchor: Anchor.center,
          key: ComponentKey.named(keyName),
        );

  late Sprite fingerTapSprite;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    fingerTapSprite = await Sprite.load('ic_finger_tap.png');
  }

  @override
  void render(Canvas canvas) {
    fingerTapSprite.render(
      canvas,
      position: Vector2(90, 0),
      size: Vector2(80, 80),
    );
  }
}
