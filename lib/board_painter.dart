import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BoardPainter extends CustomPainter {
  final Paint _paint = Paint();

  void setBackgroundPaint() {
    _paint.color = const Color(0xFF30343F);
  }

  void setCellPaint() {
    _paint.color = const Color(0xFFE4D9FF);
    _paint.strokeWidth = 5;
  }

  void paintBackground(Canvas canvas, Size size) {
    setBackgroundPaint();

    Rect rect = Rect.fromCenter(center: size.center(const Offset(0, 0)), width: size.width, height: size.height);
    Radius radius = const Radius.circular(10);

    canvas.drawRRect(RRect.fromRectAndRadius(rect, radius), _paint);
  }

  void paintCells(Canvas canvas, Size size) {
    setCellPaint();

    int numberOfColumns = 8;
    double cellSeparation = 5;
    double cellBorderRadius = 5;
    double cellSize = ((size.width - cellSeparation - (numberOfColumns * cellSeparation)) / numberOfColumns);

    double dx = cellSeparation;
    double dy = cellSeparation;

    for (int i = 0; i < numberOfColumns; i++) {
      for (int j = 0; j < numberOfColumns; j++) {
        Rect rect = Rect.fromLTWH(dx, dy, cellSize, cellSize);

        Radius radius = Radius.circular(cellBorderRadius);
        canvas.drawRRect(RRect.fromRectAndRadius(rect, radius), _paint);

        dx += cellSize + cellSeparation;
      }
      dx = cellSeparation;
      dy += cellSeparation + cellSize;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    paintBackground(canvas, size);
    paintCells(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
  
}