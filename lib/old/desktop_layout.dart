import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_cool_minesweeper/old/app_data.dart';
import 'package:super_cool_minesweeper/old/board_painter.dart';

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
    appData.initializeCellParameters();

    double width = widget.size.width;
    double height = widget.size.height;
    appData.resolveCellSize(width, height);

    double boardWidth = appData.columns * (appData.cellGap + appData.cellWidth) + appData.cellGap;
    double boardHeight = appData.rows * (appData.cellGap + appData.cellWidth) + appData.cellGap;

    Size boardSize = Size(boardWidth, boardHeight);

    return Scaffold(
        backgroundColor: const Color(0xFFD8CB96),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onSecondaryTapDown: (details) {
                  appData.flagCell(details, boardSize.width);
                },
                onTapDown: (details) {
                  appData.revealCell(details, width);
                },
                child: CustomPaint(
                  size: boardSize,
                  painter: initializePainter(appData, boardSize),
                ),
              )
            ],
          ),
        ));
  }

  /// Initializes the board painter.
  ///
  /// Resolves the cell size based on the board dimensions, generates
  /// the cells if they are not already generated, and then returns
  /// an instance of `BoardPainter` to draw the grid.
  ///
  BoardPainter initializePainter(AppData appData, Size size) {
    appData.resolveCellSize(size.width, size.height);
    if (appData.cells.isEmpty) appData.generateCells();
    return BoardPainter(appData);
  }

}

