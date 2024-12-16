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
    Size boardSize = Size(widget.size.height * 0.95, widget.size.height * 0.95);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: CustomPaint(
                size: boardSize,
                painter: BoardPainter(),
              )
            )
          ],
        ),
      )
    );
  }
}