import 'dart:ui';

enum CellState { hidden, revealed, flagged }

class Cell {
  final int index;
  late Offset origin;
  bool isMine = false;
  CellState state = CellState.hidden;

  Cell({required this.index});

  /// Cell generation.
  ///
  /// Generates a Cell list of columns² length.
  /// All cells are defaulted to isMine = false and their origin offset
  /// is undefined.
  ///
  static List<Cell> generateCells(int columns) {
    List<Cell> cells = List.generate(
        columns * columns, (int index) => Cell(index: index),
        growable: false);

    return cells;
  }

  /// Cell mine population.
  ///
  /// Algorithm to populate a cell list with n mines.
  /// The function assumes all cells are in their default state.
  ///  A safe spot is defined to avoid detonating a mine on the first
  ///  move.
  ///
  static void populateCells(List<Cell> cells, int mines, int safeSpotIndex) {
    List<Cell> potentialMines = List.from(cells);
    potentialMines.remove(cells[safeSpotIndex]);

    for (mines; mines > 0; mines--) {
      potentialMines.shuffle();
      cells[potentialMines.last.index].isMine = true;
      potentialMines.remove(potentialMines.last);
    }
  }
}
