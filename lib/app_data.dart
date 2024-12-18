import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:super_cool_minesweeper/cell_entity.dart';
import 'constants.dart' as constants;

class AppData with ChangeNotifier {

  late int columns;
  late int rows;

  late double cellHeight;
  late double cellWidth;
  late double cellGap;
  late double cellRadius;

  List<Cell> cells = [];

  bool cellsPopulated = false;

  /// Cell generation.
  ///
  /// Generates a Cell list of columns² length.
  /// All cells are defaulted to isMine = false and their origin offset
  /// is undefined.
  ///
  void generateCells() {
    cells = List.generate(columns * rows, (int index) => Cell(index: index),
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
  /// todo Add menu from where to set the cell columns
  void initializeCellParameters() {
    cellGap = 5;
    columns = 6;
    rows = 12;
    cellRadius = 5;
  }

  /// Resolves the size of the cells based on the available board space.
  ///
  /// Calculates the maximum possible size of the cells and the gap between cells
  /// so that the grid fits within the available screen space.
  ///
  void resolveCellSize(double boardWidth, double boardHeight) {
    double minDimension = min(boardWidth, boardHeight);
    cellGap = minDimension * 0.007;

    if (boardWidth == minDimension) {
      boardHeight += cellGap;
    } else if (boardHeight == minDimension) {
      boardWidth += cellGap;
    }

    double maxCellWidth = (boardWidth - (columns + 1) * cellGap) / columns;
    double maxCellHeight = (boardHeight - (rows + 1) * cellGap) / rows;
    double maxCellSize = min(maxCellWidth, maxCellHeight);

    cellWidth = maxCellSize;
    cellHeight = maxCellSize;
    cellRadius = cellWidth * 0.05;
  }

  /// Reveals the clicked cell.
  ///
  /// If it's the first move, mines are populated first.
  /// The revealed cell's state is set to revealed.
  /// Adjacent cells are revealed recursively if needed.
  ///
  void revealCell(TapDownDetails details, double width) {
    int index = resolveCellIndex(details, width);

    if (!cellsPopulated) populateCells(cells, 10, index);

    cells[index].state = CellState.revealed;
    revealAdjacentCells(index);
    notifyListeners();
  }

  /// Recursively reveals adjacent cells for cells with no nearby mines.
  ///
  /// Checks for adjacent cells and reveals them if the current cell has no nearby mines.
  ///
  void revealAdjacentCells(int index) {
    Set<int> visited = {};

    void revealCell(int currentIndex) {
      if (currentIndex < 0 ||
          currentIndex >= cells.length ||
          visited.contains(currentIndex)) {
        return;
      }

      visited.add(currentIndex);

      int x = currentIndex % columns;
      int y = currentIndex ~/ columns;

      Cell currentCell = cells[currentIndex];

      if (currentCell.isMine || currentCell.state == CellState.flagged) return;

      currentCell.state = CellState.revealed;

      if (currentCell.nearbyMines == 0) {
        for (Offset offset in constants.adjacentCellOffsets) {
          int adjacentX = (x + offset.dx).round();
          int adjacentY = (y + offset.dy).round();

          if (adjacentX >= 0 &&
              adjacentX < columns &&
              adjacentY >= 0 &&
              adjacentY < rows) {
            int adjacentIndex = (adjacentX + columns * adjacentY).round();
            revealCell(adjacentIndex);
          }
        }
      }
    }

    revealCell(index);
  }

  /// Resolves the index of the cell based on the tap position.
  ///
  /// Given the tap position, it calculates which cell has been clicked on.
  /// The cell's index is returned based on its position in the grid.
  ///
  int resolveCellIndex(TapDownDetails details, double width) {
    Offset position = details.localPosition;

    double realCellWidth = cellWidth + cellGap;
    double realCellHeight = cellHeight + cellGap;

    int x = (position.dx / realCellWidth).floor();
    int y = (position.dy / realCellHeight).floor();

    x = x.clamp(0, columns - 1);
    y = y.clamp(0, rows - 1);

    int index = x + y * columns;
    return index;
  }

  /// Flags the clicked cell.
  ///
  /// If it's the first move, mines are populated.
  /// The cell's state is set to flagged.
  ///
  void flagCell(TapDownDetails details, double width) {
    int index = resolveCellIndex(details, width);

    if (!cellsPopulated) populateCells(cells, 10, index);

    cells[index].state = CellState.flagged;
    notifyListeners();
  }

  /// Counts the number of nearby mines for a given cell.
  ///
  /// Given the cell's index, it checks all adjacent cells and counts how many mines are nearby.
  ///
  int countNearbyMines(int index) {
    int count = 0;

    int x = index % columns;
    int y = index ~/ columns;

    for (Offset offset in constants.adjacentCellOffsets) {
      int neighborX = x + offset.dx.round();
      int neighborY = y + offset.dy.round();

      if (neighborX >= 0 &&
          neighborX < columns &&
          neighborY >= 0 &&
          neighborY < rows) {
        int neighborIndex = neighborX + columns * neighborY;
        if (cells[neighborIndex].isMine) {
          count++;
        }
      }
    }

    return count;
  }
}
