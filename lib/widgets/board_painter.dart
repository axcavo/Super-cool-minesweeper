import 'package:flutter/cupertino.dart';
import 'package:super_cool_minesweeper/entities/AppColors.dart';
import 'package:super_cool_minesweeper/entities/board.dart';

import '../entities/cell.dart';
import 'package:super_cool_minesweeper/constants.dart' as constants;

class BoardPainter extends CustomPainter {
  final Board board;
  final AppColors colors;
  final Paint _paint;
  final TextPainter _textPainter = TextPainter(textAlign: TextAlign.center);

  BoardPainter(this.board, this.colors) : _paint = Paint();

  void drawBackground(Canvas canvas, Size size) {
    _paint.color = colors.main;
    Rect rect = Rect.fromCenter(
        center: size.center(const Offset(0, 0)),
        width: size.width,
        height: size.height);
    Radius radius = Radius.circular(board.getCellRadius());

    canvas.drawRRect(RRect.fromRectAndRadius(rect, radius), _paint);
  }

  void drawCells(Canvas canvas, Size size) {
    double dx = board.cellGap;
    double dy = board.cellGap;

    for (int i = 0; i < board.rows; i++) {
      for (int j = 0; j < board.columns; j++) {
        int index = (j + (i * board.columns)).round();
        Cell cell = board.cells[index];
        cell.origin = Offset(dx, dy);

        drawCell(canvas, cell, dx, dy);
        if (cell.status == CellStatus.flagged) {
          drawFlag(canvas, dx, dy);
        } else if (cell.status != CellStatus.hidden && cell.isMine) {
          drawMine(canvas, dx, dy);
        } else if (cell.status == CellStatus.revealed) {
          drawNumber(canvas, cell, dx, dy);
        }

        dx += board.cellSize + board.cellGap;
      }
      dx = board.cellGap;
      dy += board.cellSize + board.cellGap;
    }
  }

  void drawCell(Canvas canvas, Cell cell, double dx, double dy) {
    Rect rect = Rect.fromLTWH(dx, dy, board.cellSize, board.cellSize);
    Radius radius = Radius.circular(board.getCellRadius());

    CellStatus status = cell.status;
    switch (status) {
      case CellStatus.flagged:
        _paint.color = colors.revealed;
        break;
      case CellStatus.revealed:
        _paint.color = colors.revealed;
        break;
      default:
        _paint.color = colors.hidden;
    }
    canvas.drawRRect(RRect.fromRectAndRadius(rect, radius), _paint);
  }

  void drawNumber(Canvas canvas, Cell cell, double dx, double dy) {
    if (cell.nearbyMines == 0) return;

    TextSpan textSpan = TextSpan(
        text: cell.nearbyMines.toString(),
        style: TextStyle(color: colors.hidden, fontSize: (board.cellSize * 0.45), fontWeight: FontWeight.bold, fontFamily: "Azeret"));
    _textPainter.text = textSpan;
    _textPainter.textDirection = TextDirection.ltr;

    _textPainter.layout();
    _textPainter.paint(canvas, Offset(dx + board.cellSize * 0.3718, dy + board.cellSize * 0.25));
  }

  void drawMine(Canvas canvas, double dx, double dy) {
    _paint.color = colors.hidden;
    _paint.strokeWidth = board.cellSize * constants.strokeOffsetFactor;

    double offset = board.cellSize * constants.cornerOffsetFactor;
    double rectSize = board.cellSize - (2 * offset);
    double center = board.cellSize / 2;
    double strokeOffset = board.cellSize * constants.strokeOffsetFactor;

    Rect rect = Rect.fromLTWH(
      dx + offset,
      dy + offset,
      rectSize,
      rectSize,
    );

    List<Offset> points = [
      Offset(dx + offset, dy + offset),
      Offset(dx + board.cellSize - offset, dy + offset),
      Offset(dx + board.cellSize - offset, dy + board.cellSize - offset),
      Offset(dx + offset, dy + board.cellSize - offset),
      Offset(dx + center, dy + strokeOffset),
      Offset(dx + center, dy + board.cellSize - strokeOffset),
      Offset(dx + strokeOffset, dy + center),
      Offset(dx + board.cellSize - strokeOffset, dy + center),
    ];

    List<List<int>> lineIndices = [
      [0, 2], // Diagonal from Top Left to Bottom Right
      [1, 3], // Diagonal from Top Right to Bottom Left
      [4, 5], // Vertical center line
      [6, 7], // Horizontal center line
    ];

    for (var indices in lineIndices) {
      canvas.drawLine(points[indices[0]], points[indices[1]], _paint);
    }

    canvas.drawOval(rect, _paint);
  }

  void drawFlag(Canvas canvas, double dx, double dy) {
    double width = board.cellSize;

   _paint.color = colors.hidden;
   _paint.strokeWidth = width * 0.05933;

   Offset centerTop = Offset(dx + width / 2.5, dy + (width * 0.2));
   Offset centerBottom = Offset(dx + width / 2.5, dy + width - (width * 0.2));

   Offset flagTop = Offset(dx + width / 2.5, dy + (width * 0.2));
   Offset flagRight = Offset(dx + width * 0.7, dy + (width * 0.35));
   Offset flagBottom = Offset(dx + width / 2.5, dy + width - (width * 0.5));

   Path path = Path()
     ..moveTo(flagTop.dx, flagTop.dy)
     ..lineTo(flagRight.dx, flagRight.dy)
     ..lineTo(flagBottom.dx, flagBottom.dy)
     ..close();

   canvas.drawLine(centerTop, centerBottom, _paint);
   canvas.drawPath(path, _paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    drawBackground(canvas, size);
    drawCells(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
