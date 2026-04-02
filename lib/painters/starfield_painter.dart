import 'dart:math';
import 'package:flutter/material.dart';

/// A single star in the starfield
class Star {
  double x;
  double y;
  double size;
  double baseOpacity;
  double twinkleSpeed;
  double twinkleOffset;
  Color color;

  Star({
    required this.x,
    required this.y,
    required this.size,
    required this.baseOpacity,
    required this.twinkleSpeed,
    required this.twinkleOffset,
    required this.color,
  });
}

/// Lightweight starfield painter — no blur filters, just solid circles
class StarFieldPainter extends CustomPainter {
  final double animationValue;
  final List<Star> stars;
  final bool isDark;

  StarFieldPainter({
    required this.animationValue,
    required this.stars,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (!isDark) {
      _paintLightBackground(canvas, size);
      return;
    }

    final paint = Paint();

    for (final star in stars) {
      final twinkle =
          (sin((animationValue * star.twinkleSpeed * 2 * pi) +
                      star.twinkleOffset) +
                  1) /
              2;
      final opacity = star.baseOpacity * (0.4 + 0.6 * twinkle);
      final pos = Offset(star.x * size.width, star.y * size.height);

      // Simple solid circle — no MaskFilter.blur
      paint.color = star.color.withValues(alpha: opacity);
      canvas.drawCircle(pos, star.size, paint);

      // Bright core for larger stars
      if (star.size > 1.8) {
        paint.color = Colors.white.withValues(alpha: opacity * 0.9);
        canvas.drawCircle(pos, star.size * 0.35, paint);
      }
    }
  }

  void _paintLightBackground(Canvas canvas, Size size) {
    final t = animationValue * 2 * pi;
    final paint = Paint();

    final orbs = [
      (
        center: Offset(
          size.width * (0.15 + 0.06 * sin(t * 0.3)),
          size.height * (0.25 + 0.06 * cos(t * 0.4)),
        ),
        radius: size.width * 0.32,
        color: const Color(0xFF6C3CE1),
        alpha: 0.08,
      ),
      (
        center: Offset(
          size.width * (0.8 + 0.05 * cos(t * 0.5)),
          size.height * (0.15 + 0.05 * sin(t * 0.3)),
        ),
        radius: size.width * 0.28,
        color: const Color(0xFF3B82F6),
        alpha: 0.07,
      ),
      (
        center: Offset(
          size.width * (0.55 + 0.04 * sin(t * 0.4)),
          size.height * (0.75 + 0.04 * cos(t * 0.6)),
        ),
        radius: size.width * 0.26,
        color: const Color(0xFF22D3EE),
        alpha: 0.06,
      ),
    ];

    for (final orb in orbs) {
      paint.shader = RadialGradient(
        colors: [
          orb.color.withValues(alpha: orb.alpha),
          orb.color.withValues(alpha: 0),
        ],
      ).createShader(
        Rect.fromCircle(center: orb.center, radius: orb.radius),
      );
      canvas.drawCircle(orb.center, orb.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant StarFieldPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.isDark != isDark;
  }
}

/// Generate stars — fewer, bolder
List<Star> generateStars(int count) {
  final rand = Random(42);
  final starColors = [
    Colors.white,
    const Color(0xFFCCE4FF),
    const Color(0xFFFFE4B5),
    const Color(0xFFB8D4FF),
    const Color(0xFFE0C0FF),
  ];

  return List.generate(count, (_) {
    return Star(
      x: rand.nextDouble(),
      y: rand.nextDouble(),
      size: rand.nextDouble() * 2.0 + 0.5,
      baseOpacity: rand.nextDouble() * 0.5 + 0.5, // 0.5–1.0 (bolder)
      twinkleSpeed: rand.nextDouble() * 1.5 + 0.3,
      twinkleOffset: rand.nextDouble() * 2 * pi,
      color: starColors[rand.nextInt(starColors.length)],
    );
  });
}

/// Animated background widget — uses RepaintBoundary for isolation
class AnimatedStarfield extends StatefulWidget {
  final bool isDark;
  const AnimatedStarfield({super.key, required this.isDark});

  @override
  State<AnimatedStarfield> createState() => _AnimatedStarfieldState();
}

class _AnimatedStarfieldState extends State<AnimatedStarfield>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Star> _stars;

  @override
  void initState() {
    super.initState();
    _stars = generateStars(80); // 80 instead of 150
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30), // slower = fewer repaints
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: StarFieldPainter(
              animationValue: _controller.value,
              stars: _stars,
              isDark: widget.isDark,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}
