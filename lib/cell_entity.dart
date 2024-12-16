import 'dart:ui';

enum CellState { hidden, revealed, flagged }

class Cell {
  final int index;
  late Offset origin;
  bool isMine = true;
  CellState state = CellState.hidden;

  Cell({required this.index});

  static List<Cell> generateCells(int columns, int bombs) {
    List<Cell> cells = List.generate(
        columns * columns, (int index) => Cell(index: index),
        growable: false);

    return cells;
  }

  static List<Cell> populateCells(List<Cell> cells, int bombs, int safeSpotIndex) {
    List<Cell> potentialMines = cells;
    potentialMines.remove(cells[safeSpotIndex]);

    for (bombs; bombs > 0; bombs--) {
      potentialMines.shuffle();
      cells[potentialMines.last.index].isMine = true;
      potentialMines.remove(potentialMines.last);
    }
    return cells;
  }
}
