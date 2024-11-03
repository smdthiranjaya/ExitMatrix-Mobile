import 'package:exitmatrix/core/constants/constants.dart';
import 'package:exitmatrix/services/player_position.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class WowMiniMapPainter extends CustomPainter {
  final List<List<String>> map;
  final PlayerPosition? playerPosition;

  WowMiniMapPainter({
    required this.map,
    required this.playerPosition,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double cellWidth = size.width / map[0].length;
    final double cellHeight = size.height / map.length;
    final double cellSize = math.min(cellWidth, cellHeight);

    final double xOffset = (size.width - (map[0].length * cellSize)) / 2;
    final double yOffset = (size.height - (map.length * cellSize)) / 2;

    // Draw grid
    for (int y = 0; y < map.length; y++) {
      for (int x = 0; x < map[y].length; x++) {
        final rect = Rect.fromLTWH(
          xOffset + (x * cellSize),
          yOffset + (y * cellSize),
          cellSize,
          cellSize,
        );

        Color cellColor;
        switch (map[y][x]) {
          case '0':
            cellColor = EmergencyThemeColors.wallColor;
            break;
          case 'S':
            cellColor = EmergencyThemeColors.exitColor;
            break;
          case 'F':
            cellColor = EmergencyThemeColors.fireColor;
            break;
          case 'Z':
            cellColor = EmergencyThemeColors.fireZoneColor;
            break;
          case 'P':
            cellColor = EmergencyThemeColors.escapePathColor;
            break;
          default:
            cellColor = EmergencyThemeColors.pathColor;
        }

        canvas.drawRect(
          rect,
          Paint()..color = cellColor,
        );

        // Draw grid lines
        canvas.drawRect(
          rect,
          Paint()
            ..color = EmergencyThemeColors.text.withOpacity(0.1)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 0.5,
        );
      }
    }

    // Draw player position
    if (playerPosition != null) {
      final Offset center = Offset(
        xOffset + (playerPosition!.x * cellSize + cellSize / 2),
        yOffset + (playerPosition!.y * cellSize + cellSize / 2),
      );

      // Draw player indicator
      canvas.drawCircle(
        center,
        cellSize * 0.4,
        Paint()..color = EmergencyThemeColors.playerColor,
      );

      // Draw player border
      canvas.drawCircle(
        center,
        cellSize * 0.4,
        Paint()
          ..color = EmergencyThemeColors.text
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
    }
  }

  @override
  bool shouldRepaint(covariant WowMiniMapPainter oldDelegate) {
    return oldDelegate.map != map || oldDelegate.playerPosition != playerPosition;
  }
}