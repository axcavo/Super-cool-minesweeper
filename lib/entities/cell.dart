import 'package:flutter/material.dart';

enum CellStatus { hidden, revealed, flagged }

class Cell {
  final int _index;

  Offset origin;
  int nearbyMines;
  bool isMine;
  CellStatus status;

  Cell._(this._index, this.origin, this.nearbyMines, this.isMine, this.status);

  factory Cell(int index) {
    return Cell._(index, const Offset(0, 0), 0, false, CellStatus.hidden);
  }

  int get index => _index;
}
