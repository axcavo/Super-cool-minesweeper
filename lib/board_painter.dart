import 'dart:math';
import 'package:flutter/material.dart';
import 'package:super_cool_minesweeper/cell_entity.dart';

import 'app_data.dart';

class BoardPainter extends CustomPainter {
  final Paint _paint = Paint();
  final TextPainter textPainter = TextPainter(textAlign: TextAlign.center);
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
        _paint.color = const Color(0xFFB49556);
        break;
      case CellState.flagged:
        _paint.color = const Color(0xFF53CB84);
        break;
      default:
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
        if (cell.isMine && cell.state == CellState.revealed) {
          paintMine(canvas, dx, dy, width);
        } else if (cell.state == CellState.revealed) {
          drawNumber(cell, canvas, dx, dy);
        }

        // adjust x coordinate for the next cell.
        dx += width + gap;
      }

      // reset x coordinate for the next row.
      dx = gap;

      // jump to the next row.
      dy += gap + width;
    }
  }

  void drawNumber(Cell cell, Canvas canvas, double dx, dy) {
    // only draw if there is a number greater than 0;
    if (cell.nearbyMines == 0) return;

    TextSpan textSpan = TextSpan(
        text: cell.nearbyMines.toString(),
        style: TextStyle(color: Colors.black, fontSize: (width * 0.45), fontWeight: FontWeight.bold, fontFamily: "Comic"));
    textPainter.text = textSpan;
    textPainter.textDirection = TextDirection.ltr;

    textPainter.layout();
    textPainter.paint(canvas, Offset(dx + width * 0.3718, dy + width * 0.25));
  }

  void drawCell(Cell cell, Canvas canvas, double dx, dy, r) {
    Rect rect = Rect.fromLTWH(dx, dy, width, width);
    Radius radius = Radius.circular(r);

    setCellPaint(cell.state);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, radius), _paint);
  }

  void paintMine(Canvas canvas, double dx, dy, width) async {
    _paint.color = const Color(0xFF1B1F24);
    _paint.strokeWidth = (width * 0.05933);

    double left = dx + (width * 0.178);
    double top = dy + (width * 0.178);
    double rectWidth = width - (width * 0.356);

    Rect rect = Rect.fromLTWH(left, top, rectWidth, rectWidth);

    Offset topLeft = Offset(dx + (width * 0.178), dy + (width * 0.178));
    Offset topRight = Offset(dx + width - (width * 0.178), dy + (width * 0.178));
    Offset bottomLeft = Offset(dx + (width * 0.178), dy + width - (width * 0.178));
    Offset bottomRight = Offset(dx + width - (width * 0.178), dy + width - (width * 0.178));

    Offset centerTop = Offset(dx + width / 2, dy + (width * 0.05933));
    Offset centerBottom = Offset(dx + width / 2, dy + width - (width * 0.05933));
    Offset centerLeft = Offset(dx + (width * 0.05933), dy + width / 2);
    Offset centerRight = Offset(dx + width - (width * 0.05933), dy + width / 2);

    List<List<Offset>> lines = [
      [topLeft, bottomRight], // Diagonal 1
      [topRight, bottomLeft], // Diagonal 2
      [centerTop, centerBottom], // Vertical line
      [centerLeft, centerRight], // Horizontal line
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
