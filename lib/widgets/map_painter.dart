import 'package:flutter/material.dart';
import '../models/position.dart';
import 'dart:math' as math;

class MapPainter extends CustomPainter {
  final List<List<String>> map;
  final MapPosition userPosition;
  final double cellSize = 40.0;
  final Animation<double> animation;

  MapPainter(
    this.map, {
    required this.userPosition,
    required this.animation,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    if (map.isEmpty) return;

    final paint = Paint();
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    // Animation values
    final userPulse = math.sin(animation.value * math.pi * 2) * 0.3 + 0.7;
    final firePulse = math.sin(animation.value * math.pi * 2 + math.pi) * 0.3 + 0.7;

    // First pass: Draw fire zones
    for (int y = 0; y < map.length; y++) {
      for (int x = 0; x < map[y].length; x++) {
        if (map[y][x] == 'F') {
          final rect = Rect.fromLTWH(
            x * cellSize,
            y * cellSize,
            cellSize,
            cellSize,
          );
          _drawFireZone(canvas, rect, firePulse);
        }
      }
    }

    // Second pass: Draw all cells
    for (int y = 0; y < map.length; y++) {
      for (int x = 0; x < map[y].length; x++) {
        final rect = Rect.fromLTWH(
          x * cellSize,
          y * cellSize,
          cellSize,
          cellSize,
        );

        switch (map[y][x]) {
          case '0':
            canvas.drawRect(rect.translate(2, 2), shadowPaint);
            paint.color = Colors.grey[300]!;
            canvas.drawRect(rect, paint);
            break;
          case 'S':
            paint.color = Colors.green[300]!;
            canvas.drawCircle(rect.center, cellSize / 2, paint);
            _drawLabel(canvas, rect, 'SAFE\nEXIT', Colors.green[900]!);
            break;
          case 'F':
            _drawFireCell(canvas, rect, firePulse);
            break;
          case 'U':
            _drawUser(canvas, rect, userPulse);
            break;
          case 'P':
            _drawPathCell(canvas, rect);
            break;
          case 'Z':
            _drawFireZoneCell(canvas, rect);
            break;
          default:
            paint.color = Colors.white;
            canvas.drawRect(rect, paint);
        }

        canvas.drawRect(
          rect,
          Paint()
            ..color = Colors.grey[200]!
            ..style = PaintingStyle.stroke
            ..strokeWidth = 0.5,
        );
      }
    }
  }

  void _drawFireCell(Canvas canvas, Rect rect, double animationValue) {
    // Base fire circle
    final paint = Paint()..color = Colors.red[400]!;
    canvas.drawCircle(rect.center, cellSize / 2, paint);

    // Animated glow effect
    final glowPaint = Paint()
      ..color = Colors.red.withOpacity(0.3 * animationValue)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawCircle(rect.center, cellSize * 0.8 * animationValue, glowPaint);

    // Additional heat wave effect
    final waveGlow = Paint()
      ..color = Colors.orange.withOpacity(0.2 * animationValue)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(rect.center, cellSize * 0.6 * animationValue, waveGlow);

    _drawLabel(canvas, rect, 'FIRE', Colors.white);
  }

  void _drawFireZone(Canvas canvas, Rect rect, double animationValue) {
    final paint = Paint()
      ..color = Colors.orange.withOpacity(0.3 * animationValue)
      ..style = PaintingStyle.fill;

    // Draw the surrounding blocks with animation
    for (int dy = -1; dy <= 1; dy++) {
      for (int dx = -1; dx <= 1; dx++) {
        if (dx == 0 && dy == 0) continue;
        final zoneRect = Rect.fromLTWH(
          rect.left + dx * rect.width,
          rect.top + dy * rect.height,
          rect.width,
          rect.height,
        );
        canvas.drawRect(zoneRect, paint);

        // Add animated heat wave effect
        final wavePaint = Paint()
          ..color = Colors.red.withOpacity(0.1 * animationValue)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
        canvas.drawRect(zoneRect, wavePaint);
      }
    }
  }

  void _drawUser(Canvas canvas, Rect rect, double animationValue) {
    // Draw animated location pulse
    final pulsePaint = Paint()
      ..color = Colors.blue.withOpacity(0.2 * animationValue)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(rect.center, cellSize * 0.8 * animationValue, pulsePaint);

    // Draw outer glow
    final glowPaint = Paint()
      ..color = Colors.blue.withOpacity(0.3 * animationValue)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(rect.center, cellSize * 0.6 * animationValue, glowPaint);

    // Draw base user circle
    final paint = Paint()..color = Colors.blue;
    canvas.drawCircle(rect.center, cellSize / 2, paint);

    // Draw direction arrow
    final arrowPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path()
      ..moveTo(rect.center.dx, rect.top + cellSize * 0.2)
      ..lineTo(rect.center.dx, rect.bottom - cellSize * 0.2)
      ..moveTo(rect.center.dx - cellSize * 0.2, rect.bottom - cellSize * 0.3)
      ..lineTo(rect.center.dx, rect.bottom - cellSize * 0.2)
      ..lineTo(rect.center.dx + cellSize * 0.2, rect.bottom - cellSize * 0.3);

    canvas.drawPath(path, arrowPaint);

    _drawLabel(canvas, rect, 'YOU', Colors.white);
  }

  void _drawLabel(Canvas canvas, Rect rect, String label, Color textColor) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout(
      maxWidth: rect.width,
    );
    textPainter.paint(
      canvas,
      rect.center.translate(-textPainter.width / 2, -textPainter.height / 2),
    );
  }

  void _drawFireZoneCell(Canvas canvas, Rect rect) {
    final paint = Paint()
      ..color = Colors.orange.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    canvas.drawRect(rect, paint);
  }

  void _drawPathCell(Canvas canvas, Rect rect) {
    final paint = Paint()
      ..color = Colors.yellow.withOpacity(0.5)
      ..style = PaintingStyle.fill;
    canvas.drawRect(rect, paint);

    final arrowPaint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path()
      ..moveTo(rect.left + rect.width * 0.2, rect.top + rect.height * 0.5)
      ..lineTo(rect.left + rect.width * 0.8, rect.top + rect.height * 0.5)
      ..lineTo(rect.left + rect.width * 0.7, rect.top + rect.height * 0.3)
      ..moveTo(rect.left + rect.width * 0.8, rect.top + rect.height * 0.5)
      ..lineTo(rect.left + rect.width * 0.7, rect.top + rect.height * 0.7);

    canvas.drawPath(path, arrowPaint);
  }

  @override
  bool shouldRepaint(covariant MapPainter oldDelegate) {
    return true;
  }
}
