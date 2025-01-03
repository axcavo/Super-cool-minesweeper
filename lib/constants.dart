import 'dart:ui';

const List<Offset> adjacentCellOffsets = [
  Offset(-1, 0),  // Left
  Offset(1, 0),   // Right
  Offset(0, -1),  // Top
  Offset(0, 1),   // Bottom
  Offset(-1, -1), // Top-left
  Offset(1, -1),  // Top-right
  Offset(-1, 1),  // Bottom-left
  Offset(1, 1)    // Bottom-right
];

const double maxMobileLayoutWidth = 767;

const double cornerOffsetFactor = 0.178; // Factor for corner offsets
const double strokeOffsetFactor = 0.05933; // Factor for stroke offsets
