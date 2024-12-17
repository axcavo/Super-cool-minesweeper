import 'dart:ui';

enum CellState { hidden, revealed, flagged }

class Cell {
  final int index;
  late Offset origin;
  int nearbyMines = 0;
  bool isMine = false;
  CellState state = CellState.hidden;

  Cell({required this.index});
}
