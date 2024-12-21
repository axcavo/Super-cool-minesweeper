import 'dart:convert';

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

  @override
  void initState() {
    super.initState();
    colorsFuture = loadColors();
  }

  @override
  Widget build(BuildContext context) {
    AppData appData = context.watch<AppData>();

    return FutureBuilder<AppColors>(
      future: colorsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold();
        } else if (snapshot.hasData) {
          AppColors colors = snapshot.data!;
          appData.adjustBoard(MediaQuery.sizeOf(context));
          Board board = appData.board;

          return Scaffold(
            backgroundColor: colors.background,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTapDown: (details) =>
                        appData.updateCellStatus(CellStatus.revealed, details),
                    onSecondaryTapDown: (details) =>
                        appData.updateCellStatus(CellStatus.flagged, details),
                    child: CustomPaint(
                      size: board.size,
                      painter: initializeBoardPainter(board, colors),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const SizedBox.shrink(); // Fallback if no data
        }
      },
    );
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
