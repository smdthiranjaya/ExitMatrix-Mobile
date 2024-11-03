import 'package:exitmatrix/core/constants/constants.dart';
import 'package:exitmatrix/models/Particle.dart';
import 'package:exitmatrix/views/map_screen.dart';
import 'package:exitmatrix/widgets/wow/wow_background_painter.dart';
import 'package:flutter/material.dart';

class WowBackground extends StatefulWidget {
  final Widget child;

  const WowBackground({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<WowBackground> createState() => _WowBackgroundState();
}

class _WowBackgroundState extends State<WowBackground>
    with TickerProviderStateMixin {
  late AnimationController _particleController;
  late AnimationController _glowController;
  final List<Particle> _particles = [];
  final int numberOfParticles = 50;

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    // Initialize particles
    for (int i = 0; i < numberOfParticles; i++) {
      _particles.add(Particle.random());
    }
  }

  @override
  void dispose() {
    _particleController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base background color
        Container(color: MapThemeColors.background),

        // Animated background effects
        AnimatedBuilder(
          animation: _particleController,
          builder: (context, child) {
            return CustomPaint(
              painter: WowBackgroundPainter(
                particles: _particles,
                animation: _particleController,
                glowAnimation: _glowController,
              ),
              child: Container(),
            );
          },
        ),

        // Radial gradient overlay
        Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.5,
              colors: [
                MapThemeColors.background.withOpacity(0),
                MapThemeColors.background.withOpacity(0.7),
              ],
              stops: const [0.4, 1.0],
            ),
          ),
        ),

        // Vignette effect
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                MapThemeColors.background.withOpacity(0.8),
                MapThemeColors.background.withOpacity(0),
                MapThemeColors.background.withOpacity(0),
                MapThemeColors.background.withOpacity(0.8),
              ],
              stops: const [0.0, 0.15, 0.85, 1.0],
            ),
          ),
        ),

        // Main content
        widget.child,
      ],
    );
  }
}