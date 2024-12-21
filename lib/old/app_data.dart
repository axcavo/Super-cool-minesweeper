import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:super_cool_minesweeper/old/cell_entity.dart';
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

  void generateCells() {
    cells = List.generate(columns * rows, (int index) => Cell(index: index),
        growable: false);
  }

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

  void initializeCellParameters() {
    //cellGap = 5;
    columns = 6;
    rows = 12;
    //cellRadius = 5;
  }

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

  void revealCell(TapDownDetails details, double width) {
    int index = resolveCellIndex(details, width);

    if (!cellsPopulated) populateCells(cells, 10, index);

    cells[index].state = CellState.revealed;
    revealAdjacentCells(index);
    notifyListeners();
  }

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

  void flagCell(TapDownDetails details, double width) {
    int index = resolveCellIndex(details, width);

    if (!cellsPopulated) populateCells(cells, 10, index);

    cells[index].state = CellState.flagged;
    notifyListeners();
  }

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
