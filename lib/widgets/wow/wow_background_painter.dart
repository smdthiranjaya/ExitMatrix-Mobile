import 'package:exitmatrix/core/constants/constants.dart';
import 'package:exitmatrix/models/Particle.dart';
import 'package:flutter/material.dart';

class WowBackgroundPainter extends CustomPainter {
  final List<Particle> particles;
  final Animation<double> animation;
  final Animation<double> glowAnimation;

  WowBackgroundPainter({
    required this.particles,
    required this.animation,
    required this.glowAnimation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw background patterns
    final patternPaint = Paint()
      ..color = MapThemeColors.primary.withOpacity(0.05)
      ..strokeWidth = 1;

    // Draw grid pattern
    for (int i = 0; i < size.width; i += 30) {
      canvas.drawLine(
        Offset(i.toDouble(), 0),
        Offset(i.toDouble(), size.height),
        patternPaint,
      );
    }
    for (int i = 0; i < size.height; i += 30) {
      canvas.drawLine(
        Offset(0, i.toDouble()),
        Offset(size.width, i.toDouble()),
        patternPaint,
      );
    }

    // Draw particles
    for (var particle in particles) {
      particle.update(animation.value);

      final paint = Paint()
        ..color = MapThemeColors.primary
            .withOpacity(particle.opacity * (1 - animation.value % 1))
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(
          particle.x * size.width,
          particle.y * size.height,
        ),
        particle.size,
        paint,
      );

      // Draw particle trail
      final trailPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            MapThemeColors.primary.withOpacity(particle.opacity * 0.5),
            MapThemeColors.primary.withOpacity(0),
          ],
        ).createShader(Rect.fromLTWH(
          particle.x * size.width - particle.size,
          particle.y * size.height - particle.size * 4,
          particle.size * 2,
          particle.size * 4,
        ));

      canvas.drawRect(
        Rect.fromLTWH(
          particle.x * size.width - particle.size,
          particle.y * size.height - particle.size * 4,
          particle.size * 2,
          particle.size * 4,
        ),
        trailPaint,
      );
    }

    // Draw glow effects
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          MapThemeColors.primary.withOpacity(0.1 * glowAnimation.value),
          MapThemeColors.primary.withOpacity(0),
        ],
      ).createShader(Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: size.width,
        height: size.height,
      ));

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant WowBackgroundPainter oldDelegate) {
    return true;
  }
}
