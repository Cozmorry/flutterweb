import 'dart:math';
import 'package:flutter/material.dart';

/// Animated ring chart painter - used for planet stats
class RingChartPainter extends CustomPainter {
  final double progress; // 0.0 to 1.0
  final Color color;
  final Color trackColor;
  final double strokeWidth;

  RingChartPainter({
    required this.progress,
    required this.color,
    required this.trackColor,
    this.strokeWidth = 8.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - strokeWidth / 2;

    // Track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    // Progress arc
    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: -pi / 2,
        endAngle: 3 * pi / 2,
        colors: [
          color.withValues(alpha: 0.6),
          color,
          color.withValues(alpha: 0.8),
        ],
        stops: const [0.0, 0.7, 1.0],
        transform: const GradientRotation(-pi / 2),
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      progressPaint,
    );

    // Glow dot at the end of the arc
    if (progress > 0.01) {
      final dotAngle = -pi / 2 + 2 * pi * progress;
      final dotCenter = Offset(
        center.dx + radius * cos(dotAngle),
        center.dy + radius * sin(dotAngle),
      );

      // Larger color dot for glow effect (no blur for perf)
      final glowPaint = Paint()
        ..color = color.withValues(alpha: 0.35);
      canvas.drawCircle(dotCenter, strokeWidth * 0.7, glowPaint);

      // Bright white dot
      final dotPaint = Paint()..color = Colors.white;
      canvas.drawCircle(dotCenter, strokeWidth * 0.35, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant RingChartPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color;
  }
}

/// Orbital path painter for the planet detail view
class OrbitalPathPainter extends CustomPainter {
  final double animationValue;
  final Color color;
  final int ringCount;

  OrbitalPathPainter({
    required this.animationValue,
    required this.color,
    this.ringCount = 3,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = min(size.width, size.height) / 2;

    for (int i = 0; i < ringCount; i++) {
      final radius = maxRadius * (0.4 + 0.2 * i);
      final opacity = 0.15 - (i * 0.03);

      final paint = Paint()
        ..color = color.withValues(alpha: opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;

      // Draw dashed orbital path
      final dashCount = 60 + i * 20;
      for (int j = 0; j < dashCount; j++) {
        final startAngle = (j / dashCount) * 2 * pi;
        final sweepAngle = (1 / dashCount) * pi * 0.6;

        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle + animationValue * 2 * pi * (i.isEven ? 1 : -1) * 0.2,
          sweepAngle,
          false,
          paint,
        );
      }

      // Orbiting dot
      final dotAngle = animationValue * 2 * pi * (i.isEven ? 1 : -1) * 0.5 + i * 2;
      final dotPos = Offset(
        center.dx + radius * cos(dotAngle),
        center.dy + radius * sin(dotAngle),
      );
      canvas.drawCircle(dotPos, 3.5, Paint()..color = color.withValues(alpha: 0.6));
      canvas.drawCircle(dotPos, 1.5, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant OrbitalPathPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
