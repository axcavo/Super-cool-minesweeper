import 'package:flutter/cupertino.dart';
import 'package:super_cool_minesweeper/cell_entity.dart';

class AppData with ChangeNotifier {
  List<Cell> cells = [];
  late double cellWidth;
  late double cellGap;
  late double cellColumns;
  late double cellRadius;
  bool cellsPopulated = false;

  /// Cell generation.
  ///
  /// Generates a Cell list of columns² length.
  /// All cells are defaulted to isMine = false and their origin offset
  /// is undefined.
  ///
  void generateCells(int columns) {
    cells = List.generate(
        columns * columns, (int index) => Cell(index: index),
        growable: false);
  }

  /// Cell mine population.
  ///
  /// Algorithm to populate a cell list with n mines.
  /// The function assumes all cells are in their default state.
  ///  A safe spot is defined to avoid detonating a mine on the first
  ///  move.
  ///
  void populateCells(List<Cell> cells, int mines, int safeSpotIndex) {
    List<Cell> potentialMines = List.from(cells);
    potentialMines.remove(cells[safeSpotIndex]);

    for (mines; mines > 0; mines--) {
      potentialMines.shuffle();
      cells[potentialMines.last.index].isMine = true;
      potentialMines.remove(potentialMines.last);
    }

    cellsPopulated = true;
  }

  /// Sets the cell parameters.
  /// For now they are hardcoded but they are meant to be taken
  /// from a file.
  ///
  void initializeCellParameters() {
    cellGap = 5;
    cellColumns = 8;
    cellRadius = 5;
  }

  void resolveCellWidth(double boardWidth) {
    cellWidth = ((boardWidth - cellGap - (cellColumns * cellGap)) / cellColumns);
  }

  int resolveCellIndex(TapDownDetails details, double width) {
      Offset position = details.localPosition;
      double realCellWidth = cellWidth + cellGap;

      int x = (position.dx / realCellWidth).floor();
      int y = (position.dy / realCellWidth).floor();

      if (x > cellColumns) x = cellColumns.round();
      if (y > cellColumns) y = cellColumns.round();

      return (x + y * cellColumns.round());
  }

  void revealCell(int index) {
    cells[index].state = CellState.revealed;
    notifyListeners();
  }
}