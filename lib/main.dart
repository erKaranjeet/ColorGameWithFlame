import 'dart:ui';

import 'package:color_game_with_flame/ui/colors_flame_game.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MaterialApp(
      home: MyApp(),
      theme: ThemeData.dark(),
    ));
  });
}

class MyApp extends StatefulWidget {

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {

  late ColorsFlameGame flameGame;

  @override
  void initState() {
    flameGame = ColorsFlameGame();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GameWidget(game: flameGame),
          if (!flameGame.isGamePaused)
            Positioned(
            left: 0,
            top: 40,
            child: IconButton(
              onPressed: () {
                setState(() {
                  flameGame.pauseGame();
                });
              },
              icon: const Icon(
                Icons.pause_circle_outline_rounded,
                size: 32.0,
              ),
            ),
          ),
          if (flameGame.isGamePaused)
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 5,
                sigmaY: 5,
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'PAUSED!',
                      style: GoogleFonts.nunito(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 48.0,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          flameGame.resumeGame();
                        });
                      },
                      icon: const Icon(
                        Icons.play_circle_outline_rounded,
                        size: 68.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}