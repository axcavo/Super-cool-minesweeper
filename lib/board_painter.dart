import 'dart:math';
import 'package:flutter/material.dart';
import 'package:super_cool_minesweeper/cell_entity.dart';

class BoardPainter extends CustomPainter {
  final Paint _paint = Paint();
  final List<Cell> cells = Cell.generateCells(8);
  late double width;

  void setBackgroundPaint() {
    _paint.color = const Color(0xFF1B1F24);
    Cell.populateCells(cells, 10, 0);
  }

  void setCellPaint(CellState cellState) {
    switch (cellState) {
      case CellState.revealed:
        //0xFF273469
        _paint.color = const Color(0xFFFAFAFF);
        break;
      case CellState.flagged:
        _paint.color = const Color(0xFF1E2749);
        break;
      default:
        _paint.color = const Color(0xFFE4D9FF);
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
    double columns = sqrt(cells.length);
    double gap = 5;
    double radius = 5;

    // sets the cellWidth to be able to perform other calculations.
    width = ((size.width - gap - (columns * gap)) / columns);

    double dx = gap;
    double dy = gap;

    for (int i = 0; i < columns; i++) {
      for (int j = 0; j < columns; j++) {
        // Get cell with matching index.
        int cellIndex = (j + (i * columns)).round();
        Cell cell = cells[cellIndex];

        // stores cell origin coordinates to be able recognize them.
        cell.origin = Offset(dx, dy);

        drawCell(cell, canvas, dx, dy, radius);
        if (cell.isMine) paintMine(canvas, dx, dy, width);

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
    _paint.color = const Color(0xFF30343F);
    double left = dx + 15;
    double top = dy + 15;
    double rectWidth = width - 30;

    Rect rect = Rect.fromLTWH(left, top, rectWidth, rectWidth);
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
