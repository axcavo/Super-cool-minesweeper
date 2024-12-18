import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:super_cool_minesweeper/cell_entity.dart';

class AppData with ChangeNotifier {
  List<Cell> cells = [];
  late double cellWidth;
  late double cellGap;
  late int cellColumns;
  late double cellRadius;
  bool cellsPopulated = false;

  /// Cell generation.
  ///
  /// Generates a Cell list of columns² length.
  /// All cells are defaulted to isMine = false and their origin offset
  /// is undefined.
  ///
  void generateCells(int columns) {
    cells = List.generate(columns * columns, (int index) => Cell(index: index),
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

    for (Cell cell in cells) {
      cell.nearbyMines = countNearbyMines(cell.index);
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
    cellWidth =
        ((boardWidth - cellGap - (cellColumns * cellGap)) / cellColumns);
  }

  void revealCell(TapDownDetails details, double width) {
    int index = resolveCellIndex(details, width);

    // Populate the cells with mines if it's the first move.
    if (!cellsPopulated) populateCells(cells, 10, index);

    cells[index].state = CellState.revealed;
    revealAdjacentCells(index);
    notifyListeners();
  }

  void revealAdjacentCells(int index) {
    var offsets = [
      [-1, -1], [0, -1], [1, -1], [-1, 0],
      [1, 0], [-1, 1], [0, 1], [1, 1]
    ];

    Set<int> visited = {};

    void revealCell(int currentIndex) {
      if (currentIndex < 0 || currentIndex >= cells.length || visited.contains(currentIndex)) {
        return;
      }

      visited.add(currentIndex);

      int x = currentIndex % cellColumns;
      int y = currentIndex ~/ cellColumns;

      Cell currentCell = cells[currentIndex];

      if (currentCell.isMine || currentCell.state == CellState.flagged) return;

      currentCell.state = CellState.revealed;

      // If no adjacent mines reveal neighbors
      if (currentCell.nearbyMines == 0) {
        for (var offset in offsets) {
          int adjacentX = x + offset[0];
          int adjacentY = y + offset[1];

          if (adjacentX >= 0 && adjacentX < cellColumns && adjacentY >= 0 && adjacentY < cellColumns) {
            int adjacentIndex = adjacentX + cellColumns * adjacentY;
            revealCell(adjacentIndex);
          }
        }
      }
    }
    revealCell(index);
  }





  int resolveCellIndex(TapDownDetails details, double width) {
    Offset position = details.localPosition;
    double realCellWidth = cellWidth + cellGap;

    int x = (position.dx / realCellWidth).floor();
    int y = (position.dy / realCellWidth).floor();

    if (x > cellColumns) x = cellColumns.round();
    if (y > cellColumns) y = cellColumns.round();

    int index = x + y * cellColumns.round();
    return (index);
  }

  void flagCell(int index) {
    cells[index].state = CellState.flagged;
    notifyListeners();
  }

  int countNearbyMines(int index) {
    int count = 0;

    // Calculate the x and y coordinates from the index
    int x = index % cellColumns;
    int y = index ~/ cellColumns;

    const List<Offset> offsets = [
      Offset(-1, -1),
      Offset(0, -1),
      Offset(1, -1),
      Offset(-1, 0),
      Offset(1, 0),
      Offset(-1, 1),
      Offset(0, 1),
      Offset(1, 1),
    ];

    for (Offset offset in offsets) {
      int neighborX = x + offset.dx.round();
      int neighborY = y + offset.dy.round();

      if (neighborX >= 0 &&
          neighborX < cellColumns &&
          neighborY >= 0 &&
          neighborY < cellColumns) {
        int neighborIndex = neighborX + cellColumns * neighborY;

        if (cells[neighborIndex].isMine) {
          count++;
        }
      }
    }

    return count;
  }
}
