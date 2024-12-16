import 'dart:ui';

enum CellState { hidden, revealed, flagged }

class Cell {
  final int index;
  late Offset origin;
  bool isMine = false;
  CellState state = CellState.hidden;

  Cell({required this.index});
}
