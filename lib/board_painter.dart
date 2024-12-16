import 'dart:math';
import 'package:flutter/material.dart';
import 'package:super_cool_minesweeper/cell_entity.dart';

import 'app_data.dart';

class BoardPainter extends CustomPainter {
  final Paint _paint = Paint();
  final AppData appData;
  late double width;

  BoardPainter(this.appData) {
    width = appData.cellWidth;
  }

  void setBackgroundPaint() {
    _paint.color = const Color(0xFF1B1F24);
  }

  void setCellPaint(CellState cellState) {
    switch (cellState) {
      case CellState.revealed:
        //0xFF273469
        _paint.color = const Color(0xFFB49556);
        break;
      case CellState.flagged:
        // Color(0xFFFAFAFF)
        _paint.color = const Color(0xFF53CB84);
        break;
      default:
        // Color(0xFFD8CB96)
        _paint.color = const Color(0xFF583072);
    }
    _paint.strokeWidth = 5;
  }

  void paintBackground(Canvas canvas, Size size) {
    setBackgroundPaint();

    Rect rect = Rect.fromCenter(
        center: size.center(const Offset(0, 0)),
        width: size.width,
        height: size.height);
    Radius radius = const Radius.circular(10);

    canvas.drawRRect(RRect.fromRectAndRadius(rect, radius), _paint);
  }

  void paintCells(Canvas canvas, Size size) {
    double columns = sqrt(appData.cells.length);
    double gap = 5;
    double radius = 5;

    // sets the cellWidth to be able to perform other calculations.
    //width = ((size.width - gap - (columns * gap)) / columns);

    double dx = gap;
    double dy = gap;

    for (int i = 0; i < columns; i++) {
      for (int j = 0; j < columns; j++) {
        // Get cell with matching index.
        int cellIndex = (j + (i * columns)).round();
        Cell cell = appData.cells[cellIndex];

        // stores cell origin coordinates to be able recognize them.
        cell.origin = Offset(dx, dy);

        drawCell(cell, canvas, dx, dy, radius);
        if (cell.isMine && cell.state == CellState.revealed) paintMine(canvas, dx, dy, width);

        // adjust x coordinate for the next cell.
        dx += width + gap;
      }

      // reset x coordinate for the next row.
      dx = gap;

      // jump to the next row.
      dy += gap + width;
    }
  }

  void drawCell(Cell cell, Canvas canvas, double dx, dy, r) {
    Rect rect = Rect.fromLTWH(dx, dy, width, width);
    Radius radius = Radius.circular(r);

    setCellPaint(cell.state);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, radius), _paint);
  }

  void paintMine(Canvas canvas, double dx, dy, width) async {
    _paint.color = const Color(0xFF1B1F24);
    double left = dx + 15;
    double top = dy + 15;
    double rectWidth = width - 30;

    Rect rect = Rect.fromLTWH(left, top, rectWidth, rectWidth);

    Offset topLeft = Offset(dx + 15, dy + 15);
    Offset topRight = Offset(dx + width - 15, dy + 15);
    Offset bottomLeft = Offset(dx + 15, dy + width - 15);
    Offset bottomRight = Offset(dx + width - 15, dy + width - 15);

    Offset centerTop = Offset(dx + width / 2, dy + 5);
    Offset centerBottom = Offset(dx + width / 2, dy + width - 5);
    Offset centerLeft = Offset(dx + 5, dy + width / 2);
    Offset centerRight = Offset(dx + width - 5, dy + width / 2);

    List<List<Offset>> lines = [
      [topLeft, bottomRight],      // Diagonal 1
      [topRight, bottomLeft],      // Diagonal 2
      [centerTop, centerBottom],   // Vertical line
      [centerLeft, centerRight],   // Horizontal line
    ];

    for (var line in lines) {
      canvas.drawLine(line[0], line[1], _paint);
    }
    canvas.drawOval(rect, _paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    paintBackground(canvas, size);
    paintCells(canvas, size);
  }

  @override
  bool shouldRepaint(covariant BoardPainter oldDelegate) {
    return false;
  }
}
