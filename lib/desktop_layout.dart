import 'package:flutter/material.dart';
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
    double boardWidth = widget.size.width < widget.size.height
        ? widget.size.width
        : widget.size.height;
    Size boardSize = Size(boardWidth * 0.95, boardWidth * 0.95);

    return Scaffold(
        backgroundColor: const Color(0xFF273469),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomPaint(
                size: boardSize,
                painter: BoardPainter(),
              )
            ],
          ),
        ));
  }
}
