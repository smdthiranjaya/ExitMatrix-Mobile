import 'dart:math' as math;
import 'package:exitmatrix/core/constants/constants.dart';
import 'package:exitmatrix/services/player_position.dart';
import 'package:flutter/material.dart';

class WowMapPainter extends CustomPainter {
  final List<List<String>> map;
  final PlayerPosition playerPosition;
  final Animation<double> playerAnimation;

  WowMapPainter(
    this.map, {
    required this.playerPosition,
    required this.playerAnimation,
  }) : super(repaint: playerAnimation);

  @override
  void paint(Canvas canvas, Size size) {
    final double cellSize = math.min(
      size.width / map[0].length,
      size.height / map.length,
    );
    
    final double xOffset = (size.width - (cellSize * map[0].length)) / 2;
    final double yOffset = (size.height - (cellSize * map.length)) / 2;

    // Draw grid background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = EmergencyThemeColors.background,
    );

    for (int y = 0; y < map.length; y++) {
      for (int x = 0; x < map[y].length; x++) {
        final rect = Rect.fromLTWH(
          xOffset + (x * cellSize),
          yOffset + (y * cellSize),
          cellSize,
          cellSize,
        );

        // Base cell paint
        Paint cellPaint = Paint();
        Paint? overlayPaint;

        switch (map[y][x]) {
          case '0': // Wall
            cellPaint.color = EmergencyThemeColors.wallColor;
            break;
          case 'S': // Exit
            cellPaint.color = EmergencyThemeColors.exitColor;
            overlayPaint = Paint()
              ..color = EmergencyThemeColors.exitColor.withOpacity(0.3)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 3;
            _drawExitMarker(canvas, rect, cellSize);
            break;
          case 'F': // Fire
            cellPaint.color = EmergencyThemeColors.fireColor;
            _drawFireMarker(canvas, rect, cellSize, playerAnimation.value);
            break;
          case 'Z': // Fire zone
            cellPaint.color = EmergencyThemeColors.fireZoneColor;
            _drawDangerPattern(canvas, rect);
            break;
          case 'P': // Escape path
            cellPaint.color = EmergencyThemeColors.escapePathColor.withOpacity(0.3);
            _drawPathMarker(canvas, rect, cellSize);
            break;
          default: // Open space and others
            cellPaint.color = EmergencyThemeColors.pathColor;
        }

        // Draw base cell
        canvas.drawRect(rect, cellPaint);

        // Draw cell border
        canvas.drawRect(
          rect,
          Paint()
            ..color = EmergencyThemeColors.text.withOpacity(0.1)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1,
        );

        if (overlayPaint != null) {
          canvas.drawRect(rect, overlayPaint);
        }
      }
    }

    // Draw player position
    if (map[playerPosition.y.toInt()][playerPosition.x.toInt()] == 'U') {
      final Offset center = Offset(
        xOffset + (playerPosition.x * cellSize + cellSize / 2),
        yOffset + (playerPosition.y * cellSize + cellSize / 2),
      );

      // Draw pulse effect
      final double pulseRadius = (cellSize * 0.4) * (1 + playerAnimation.value * 0.3);
      canvas.drawCircle(
        center,
        pulseRadius,
        Paint()
          ..color = EmergencyThemeColors.playerColor.withOpacity(0.3 * (1 - playerAnimation.value))
          ..style = PaintingStyle.fill,
      );

      // Draw player
      canvas.drawCircle(
        center,
        cellSize * 0.3,
        Paint()..color = EmergencyThemeColors.playerColor,
      );
    }
  }

  void _drawExitMarker(Canvas canvas, Rect rect, double cellSize) {
    final path = Path();
    path.moveTo(rect.center.dx - cellSize * 0.2, rect.center.dy - cellSize * 0.2);
    path.lineTo(rect.center.dx + cellSize * 0.2, rect.center.dy);
    path.lineTo(rect.center.dx - cellSize * 0.2, rect.center.dy + cellSize * 0.2);

    canvas.drawPath(
      path,
      Paint()
        ..color = EmergencyThemeColors.background
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }

  void _drawFireMarker(Canvas canvas, Rect rect, double cellSize, double animation) {
    final paint = Paint()
      ..color = EmergencyThemeColors.fireColor.withOpacity(0.7 + animation * 0.3);

    final path = Path();
    path.moveTo(rect.center.dx, rect.top + cellSize * 0.2);
    path.quadraticBezierTo(
      rect.center.dx - cellSize * 0.2,
      rect.center.dy,
      rect.center.dx,
      rect.bottom - cellSize * 0.2,
    );
    path.quadraticBezierTo(
      rect.center.dx + cellSize * 0.2,
      rect.center.dy,
      rect.center.dx,
      rect.top + cellSize * 0.2,
    );

    canvas.drawPath(path, paint);
  }

  void _drawDangerPattern(Canvas canvas, Rect rect) {
    final paint = Paint()
      ..color = EmergencyThemeColors.fireColor.withOpacity(0.2)
      ..strokeWidth = 2;

    for (double i = 0; i < rect.width; i += 10) {
      canvas.drawLine(
        rect.topLeft.translate(i, 0),
        rect.topLeft.translate(i + 5, 5),
        paint,
      );
    }
  }

  void _drawPathMarker(Canvas canvas, Rect rect, double cellSize) {
    final paint = Paint()
      ..color = EmergencyThemeColors.escapePathColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final arrowSize = cellSize * 0.2;
    canvas.drawLine(
      rect.center.translate(-arrowSize, 0),
      rect.center.translate(arrowSize, 0),
      paint,
    );
    canvas.drawLine(
      rect.center.translate(arrowSize * 0.5, -arrowSize * 0.5),
      rect.center.translate(arrowSize, 0),
      paint,
    );
    canvas.drawLine(
      rect.center.translate(arrowSize * 0.5, arrowSize * 0.5),
      rect.center.translate(arrowSize, 0),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant WowMapPainter oldDelegate) {
    return oldDelegate.map != map ||
           oldDelegate.playerPosition != playerPosition ||
           oldDelegate.playerAnimation != playerAnimation;
  }
}