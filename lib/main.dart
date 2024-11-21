import 'package:color_game_with_flame/ui/colors_flame_game.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(GameWidget(game: ColorsFlameGame()));
}