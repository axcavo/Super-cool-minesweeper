import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:super_cool_minesweeper/app_data.dart';
import 'package:super_cool_minesweeper/entities/cell.dart';
import 'package:super_cool_minesweeper/widgets/board_painter.dart';

import '../../entities/AppColors.dart';
import '../../entities/board.dart';

class GameLayout extends StatefulWidget {
  const GameLayout({super.key});

  @override
  State<StatefulWidget> createState() => GameLayoutState();
}

class GameLayoutState extends State<GameLayout> {
  late Future<AppColors> colorsFuture;
  late Timer? timer;
  Stopwatch stopwatch = Stopwatch();

  @override
  void initState() {
    super.initState();
    colorsFuture = loadColors();

    stopwatch.start();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AppData appData = context.watch<AppData>();;

    return FutureBuilder<AppColors>(
      future: colorsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold();
        } else if (snapshot.hasData) {
          AppColors colors = snapshot.data!;
          Board board = appData.board;


          appData.adjustBoard(MediaQuery.sizeOf(context));

          return Stack(
            children: [
              Scaffold(
                backgroundColor: colors.background,
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                          padding: EdgeInsets.all(board.cellGap * 2),
                          child: SizedBox(
                              height: min(board.size.width, board.size.height) *
                                  0.05,
                              width: board.size.width,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  SizedBox(
                                    width: board.size.width * 0.11,
                                  ),
                                  Text(
                                    getGameTime(),
                                    style: TextStyle(
                                        color: colors.hidden,
                                        fontFamily: 'Azeret',
                                        fontWeight: FontWeight.bold,
                                        fontSize: board.cellSize * 0.25),
                                    textAlign: TextAlign.center,
                                  ),
                                  IconButton(
                                      color: colors.hidden,
                                      hoverColor: Colors.transparent,
                                      onPressed: () {
                                        setState(() {
                                        });
                                      },
                                      icon: Icon(
                                        Icons.settings,
                                        size: board.size.width * 0.04,
                                      ))
                                ],
                              ))),
                      GestureDetector(
                        onTapDown: (details) => appData.updateCellStatus(
                            CellStatus.revealed, details),
                        onSecondaryTapDown: (details) => appData
                            .updateCellStatus(CellStatus.flagged, details),
                        child: CustomPaint(
                          size: board.size,
                          painter: initializeBoardPainter(board, colors),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (appData.isGameOver)
                const Scaffold(
                  backgroundColor: Color(0x3A85679D),
                  body: Center(
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Game over', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Azeret', fontWeight: FontWeight.bold, fontSize: 50),)
                      ],
                    ),
                  )
                )
            ],
          );
        } else {
          return const SizedBox.shrink(); // Fallback if no data
        }
      },
    );
  }

  String getGameTime() {
    int seconds = stopwatch.elapsed.inSeconds;
    if (seconds >= Duration.secondsPerMinute) {
      int minutes = (seconds / Duration.secondsPerMinute).floor();
      return '$minutes:${'${seconds % Duration.secondsPerMinute}'.padLeft(2, '0')}';
    }
    return seconds.toString();
  }

  BoardPainter initializeBoardPainter(Board board, AppColors colors) {
    return BoardPainter(board, colors);
  }

  Future<AppColors> loadColors() async {
    Map<String, dynamic> source = await loadJson('assets/settings.json');
    Map<String, dynamic> colors = source['colors'];

    Color background = Color(int.parse(colors['background']));
    Color revealed = Color(int.parse(colors['revealed']));
    Color flagged = Color(int.parse(colors['flagged']));
    Color hidden = Color(int.parse(colors['hidden']));
    Color main = Color(int.parse(colors['main']));

    return AppColors(
      background: background,
      revealed: revealed,
      flagged: flagged,
      hidden: hidden,
      main: main,
    );
  }

  Future<Map<String, dynamic>> loadJson(String path) async {
    final String source = await rootBundle.loadString(path);
    final data = jsonDecode(source);
    return data;
  }
}
