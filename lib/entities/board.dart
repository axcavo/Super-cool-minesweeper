import 'package:flutter/material.dart';

import 'cell.dart';


class Board {
  final int columns, rows, mines;
  final List<Cell> cells;

  late double cellGap, cellSize;
  late Size size;

  bool isFirstMove = true;

  Board(this.columns, this.rows, this.mines)
      : cells = List.generate(columns * rows, (int index) => Cell(index),
            growable: false);

  void updateSize(Size newSize, double newCellGap, double newCellSize) {
    size = newSize;
    cellGap = newCellGap;
    cellSize = newCellSize;
  }

  double getCellRadius() {
    return cellSize * 0.05;
  }
}
