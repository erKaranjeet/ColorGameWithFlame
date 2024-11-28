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
            SafeArea(
              child: IconButton(
                onPressed: () {
                  setState(() {
                    flameGame.pauseGame();
                  });
                },
                icon: const Icon(
                  Icons.pause_circle_outline_rounded,
                  size: 48.0,
                ),
              ),
            ),
          if (!flameGame.isGamePaused)
            Positioned(
            left: 50,
            right: 50,
            child: SafeArea(
              child: ValueListenableBuilder(
                valueListenable: flameGame.currentScore,
                builder: (context, value, child) {
                  return Text(
                    'Score: ${value.toString()}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 32.0,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 4.0,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          if (flameGame.isGamePaused)
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 5,
                sigmaY: 5,
              ),
              child: Container(
                color: Colors.black45,
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
            ),
          ValueListenableBuilder(
              valueListenable: flameGame.isGameOver,
              builder: (context, value, child) {
                return value ? BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 5,
                    sigmaY: 5,
                  ),
                  child: Container(
                    color: Colors.black45,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ValueListenableBuilder(
                            valueListenable: flameGame.currentScore,
                            builder: (context, value, child) {
                              return Text(
                                'GAME OVER!\nScores: $value',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.nunito(
                                  textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 48.0,
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                flameGame.isGameOver.value = false;
                                flameGame.initGameComponents();
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
                ) : const SizedBox.shrink();
              },
            ),
        ],
      ),
    );
  }
}