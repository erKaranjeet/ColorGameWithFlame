import 'dart:ui';

import 'package:color_game_with_flame/models/menu_model.dart';
import 'package:color_game_with_flame/ui/colors_flame_game.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

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
  final scaffoldDrawerKey = GlobalKey<ScaffoldState>();

  List<MenuModel> menuList = [];

  @override
  void initState() {
    flameGame = ColorsFlameGame();
    super.initState();

    initMenuList();
  }

  void initMenuList() {
    menuList.clear();
    menuList.add(MenuModel(id: 1, menuName: 'Home', menuIcon: 'assets/images/ic_home_colored.png'));
    menuList.add(MenuModel(id: 2, menuName: 'Leaderboard', menuIcon: 'assets/images/ic_leader_colored.png'));
    menuList.add(MenuModel(id: 3, menuName: 'Share', menuIcon: 'assets/images/ic_share_colored.png'));
    menuList.add(MenuModel(id: 4, menuName: 'Rate Us', menuIcon: 'assets/images/ic_rating_colored.png'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldDrawerKey,
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
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    flameGame.pauseGame();
                    scaffoldDrawerKey.currentState?.openEndDrawer();
                  });
                },
                icon: const Icon(
                  Icons.menu_rounded,
                  size: 44.0,
                ),
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
      endDrawer: Drawer(
        width: 270.0,
        backgroundColor: Colors.white,
        elevation: 8.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/drawer_header.png',
              fit: BoxFit.fitWidth,
            ),
            const Divider(
              height: 1.0,
              thickness: 1.0,
              color: Colors.black,
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width * 1.0,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/background_dots_pattern.png',
                    ),
                    fit: BoxFit.cover,
                    opacity: 0.75,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    16.heightBox,
                    ListView.builder(
                      itemCount: menuList.length,
                      padding: EdgeInsets.zero,
                      reverse: false,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(right: 20.0, top: 16.0),
                          padding: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 10.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: const BorderRadius.horizontal(
                              right: Radius.circular(25.0),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.greenAccent.withOpacity(0.85),
                                Colors.blueAccent.withOpacity(0.85),
                              ],
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4.0,
                                spreadRadius: 1.0,
                                offset: Offset(0, 2.0),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                menuList[index].menuName ?? '',
                                style: GoogleFonts.nunito(
                                  textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                              16.widthBox,
                              Image.asset(
                                menuList[index].menuIcon ?? '',
                                width: 24.0,
                                height: 24.0,
                              ),
                              8.widthBox,
                            ],
                          ),
                        );
                      },
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(22.0),
                        gradient: const LinearGradient(
                          colors: [
                            Colors.blueAccent,
                            Colors.greenAccent,
                          ],
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6.0,
                            spreadRadius: 1.0,
                            offset: Offset(0, 2.0),
                          ),
                        ],
                      ),
                      child: Text(
                        'Sign In',
                        style: GoogleFonts.nunito(
                          textStyle: TextStyle(
                            color: Colors.black.withOpacity(0.9),
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                    20.heightBox,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}