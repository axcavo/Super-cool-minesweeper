import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_cool_minesweeper/app_data.dart';
import 'package:super_cool_minesweeper/board_painter.dart';

class DesktopLayout extends StatefulWidget {
  static double maxMobileLayoutWidth = 767;
  final Size size;

  const DesktopLayout({super.key, required this.size});

  @override
  State<StatefulWidget> createState() => DesktopLayoutState();
}

class DesktopLayoutState extends State<DesktopLayout> {
  @override
  Widget build(BuildContext context) {
    AppData appData = context.watch<AppData>();
    double boardWidth = widget.size.width < widget.size.height
        ? widget.size.width
        : widget.size.height;
    Size boardSize = Size(boardWidth * 0.95, boardWidth * 0.95);

    return Scaffold(
        backgroundColor: const Color(0xFFD8CB96),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onSecondaryTapDown: (details) {
                  int index = appData.resolveCellIndex(details, boardSize.width);
                  if (!appData.cellsPopulated) {
                    appData.populateCells(appData.cells, 10, index);
                  }
                  appData.flagCell(index);
                },
                onTapDown: (details) {
                  int index = appData.resolveCellIndex(details, boardSize.width);
                  if (!appData.cellsPopulated) {
                    appData.populateCells(appData.cells, 10, index);
                  }
                  appData.revealCell(index);
                },
                child: CustomPaint(
                  size: boardSize,
                  painter: initializePainter(appData, boardSize.width),
                ),
              )
            ],
          ),
        ));
  }

  BoardPainter initializePainter(AppData appData, double width) {
    appData.initializeCellParameters();
    appData.resolveCellWidth(width);
    if (appData.cells.isEmpty) appData.generateCells(appData.cellColumns.round());
    return BoardPainter(appData);
  }
}
