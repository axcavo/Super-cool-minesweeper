import 'dart:math';

import 'package:flutter/material.dart';

import 'entities/board.dart';
import 'entities/cell.dart';
import 'constants.dart' as constants;

class AppData with ChangeNotifier {
  late Stopwatch? _stopwatch;
  bool isGameOver = false;

  Board board = Board(6, 9, 10);
  bool isLayoutLoading = true;

  void startGame() {
    _stopwatch = Stopwatch();
    _stopwatch!.start();

    notifyListeners();
  }

  String getTime() {
    return _stopwatch!.elapsed.inSeconds.toString();
  }

  void initializeCells(int safeIndex) {
    List<Cell> potentialMines = List.from(board.cells);
    potentialMines.removeAt(safeIndex);

    int mines = board.mines;
    for (mines; mines > 0; mines--) {
      potentialMines.shuffle();
      board.cells[potentialMines.last.index].isMine = true;
      potentialMines.remove(potentialMines.last);
    }

    for (Cell cell in board.cells) {
      cell.nearbyMines = countNearbyMines(cell.index);
    }

    board.isFirstMove = false;
  }

  int countNearbyMines(int index) {
    int count = 0;

    int x = index % board.columns;
    int y = index ~/ board.columns;

    for (Offset offset in constants.adjacentCellOffsets) {
      int neighborX = x + offset.dx.round();
      int neighborY = y + offset.dy.round();

      if (neighborX >= 0 &&
          neighborX < board.columns &&
          neighborY >= 0 &&
          neighborY < board.rows) {
        int neighborIndex = neighborX + board.columns * neighborY;
        if (board.cells[neighborIndex].isMine) {
          count++;
        }
      }
    }

    return count;
  }

  void adjustBoard(Size availableSize) {
    Size adjustedSize =
        Size(availableSize.width * 0.95, availableSize.height * 0.95);
    double minDimension = min(adjustedSize.width, adjustedSize.height);
    double cellGap = minDimension * 0.004;

    double maxCellWidth =
        (adjustedSize.width - (board.columns + 1) * cellGap) / board.columns;
    double maxCellHeight =
        (adjustedSize.height - (board.rows + 1) * cellGap) / board.rows;
    double cellSize = min(maxCellWidth, maxCellHeight);

    double boardWidth = board.columns * (cellSize + cellGap) + cellGap;
    double boardHeight = board.rows * (cellSize + cellGap) + cellGap;

    board.updateSize(Size(boardWidth, boardHeight), cellGap, cellSize);
  }

  void updateCellStatus(
      CellStatus newStatus, TapDownDetails details) {
    int index = findCellIndex(details);

    if (board.isFirstMove) {
      initializeCells(index);
    }

    board.cells[index].status = newStatus;
    if (newStatus == CellStatus.revealed) {
      if (board.cells[index].isMine) {
        isGameOver = true;
      }
      revealAdjacentCells(index);
    }
    notifyListeners();
  }

  int findCellIndex(TapDownDetails details) {
    Offset position = details.localPosition;
    double realSize = board.cellSize + board.cellGap;

    int x = (position.dx / realSize).floor();
    int y = (position.dy / realSize).floor();

    x = x.clamp(0, board.columns - 1);
    y = y.clamp(0, board.rows - 1);

    return (x + y * board.columns);
  }

  void revealAdjacentCells(int index) {
    Set<int> visited = {};

    void revealCell(int currentIndex) {
      if (currentIndex < 0 ||
          currentIndex >= board.cells.length ||
          visited.contains(currentIndex)) {
        return;
      }

      visited.add(currentIndex);

      int x = currentIndex % board.columns;
      int y = currentIndex ~/ board.columns;

      Cell currentCell = board.cells[currentIndex];

      if (currentCell.isMine || currentCell.status == CellStatus.flagged) return;

      currentCell.status = CellStatus.revealed;

      if (currentCell.nearbyMines == 0) {
        for (Offset offset in constants.adjacentCellOffsets) {
          int adjacentX = (x + offset.dx).round();
          int adjacentY = (y + offset.dy).round();

          if (adjacentX >= 0 &&
              adjacentX < board.columns &&
              adjacentY >= 0 &&
              adjacentY < board.rows) {
            int adjacentIndex = (adjacentX + board.columns * adjacentY).round();
            revealCell(adjacentIndex);
          }
        }
      }
    }

    revealCell(index);
  }
}
