
import 'dart:math' as math;

class Particle {
  double x;
  double y;
  double speed;
  double size;
  double opacity;

  Particle({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.opacity,
  });

  factory Particle.random() {
    return Particle(
      x: math.Random().nextDouble(),
      y: math.Random().nextDouble(),
      speed: math.Random().nextDouble() * 0.2 + 0.1,
      size: math.Random().nextDouble() * 2 + 1,
      opacity: math.Random().nextDouble() * 0.5 + 0.1,
    );
  }

  void update(double animation) {
    y = (y + speed * animation) % 1.0;
  }
}