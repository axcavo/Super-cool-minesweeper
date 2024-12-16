import 'dart:math';
import 'package:flutter/material.dart';
import 'package:super_cool_minesweeper/cell_entity.dart';

class BoardPainter extends CustomPainter {
  final Paint _paint = Paint();
  final List<Cell> cells = Cell.generateCells(8, 5);

  void setBackgroundPaint() {
    _paint.color = const Color(0xFF30343F);
    Cell.populateCells(cells, 10, 0);
  }

  void setCellPaint(CellState cellState) {
    switch (cellState) {
      case CellState.revealed:
        _paint.color = const Color(0xFF273469);
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

    Rect rect = Rect.fromCenter(center: size.center(const Offset(0, 0)), width: size.width, height: size.height);
    Radius radius = const Radius.circular(10);

    canvas.drawRRect(RRect.fromRectAndRadius(rect, radius), _paint);
  }

  void paintCells(Canvas canvas, Size size) {
    double columns = sqrt(cells.length);
    double cellSeparation = 5;
    double cellBorderRadius = 5;
    double cellSize = ((size.width - cellSeparation - (columns * cellSeparation)) / columns);

    double dx = cellSeparation;
    double dy = cellSeparation;

    for (int i = 0; i < columns; i++) {
      for (int j = 0; j < columns; j++) {
        int cellIndex = (j + (i * columns)).round();
        Cell cell = cells[cellIndex];

        setCellPaint(cell.state);
        Rect rect = Rect.fromLTWH(dx, dy, cellSize, cellSize);
        Radius radius = Radius.circular(cellBorderRadius);

        canvas.drawRRect(RRect.fromRectAndRadius(rect, radius), _paint);
        if (cell.isMine) {
          paintMine(canvas, dx, dy, cellSize);
        }

        dx += cellSize + cellSeparation;
      }
      dx = cellSeparation;
      dy += cellSeparation + cellSize;
    }
  }

  void paintMine(Canvas canvas, double dx, dy, width) async {
    _paint.color = const Color(0xFF30343F);
    double left = dx + 15;
    double top = dy + 15;
    double rectWidth = width -30;

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