import 'dart:math';
import 'package:flutter/material.dart';
import '../models/planet.dart';

import '../widgets/glass_card.dart';
import '../widgets/animated_ring_chart.dart';
import '../theme/app_theme.dart';

class PlanetDetailPage extends StatefulWidget {
  final Planet planet;
  final bool isDark;

  const PlanetDetailPage({
    super.key,
    required this.planet,
    required this.isDark,
  });

  @override
  State<PlanetDetailPage> createState() => _PlanetDetailPageState();
}

class _PlanetDetailPageState extends State<PlanetDetailPage>
    with TickerProviderStateMixin {
  late AnimationController _orbitalController;
  late AnimationController _entranceController;
  late Animation<double> _heroScale;
  late Animation<double> _contentSlide;
  late Animation<double> _contentFade;

  @override
  void initState() {
    super.initState();
    _orbitalController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _heroScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _contentSlide = Tween<double>(begin: 60, end: 0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _contentFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.2, 0.7, curve: Curves.easeOut),
      ),
    );

    _entranceController.forward();
  }

  @override
  void dispose() {
    _orbitalController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final planet = widget.planet;
    final isDark = widget.isDark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 900;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Orbital background animation
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _orbitalController,
              builder: (context, _) {
                return CustomPaint(
                  painter: _PlanetBgPainter(
                    animationValue: _orbitalController.value,
                    color: planet.primaryColor,
                    isDark: isDark,
                  ),
                );
              },
            ),
          ),
          // Content
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(context),
                Expanded(
                  child: isWide
                      ? _buildWideLayout(context)
                      : _buildNarrowLayout(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final planet = widget.planet;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          GlassCard(
            padding: const EdgeInsets.all(10),
            borderRadius: 14,
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.arrow_back_rounded, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  planet.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  planet.subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: planet.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWideLayout(BuildContext context) {
    return AnimatedBuilder(
      animation: _entranceController,
      builder: (context, _) {
        return Row(
          children: [
            // Left: Planet hero
            Expanded(
              flex: 4,
              child: Transform.scale(
                scale: _heroScale.value,
                child: _buildPlanetHero(context),
              ),
            ),
            // Right: Details
            Expanded(
              flex: 6,
              child: Transform.translate(
                offset: Offset(_contentSlide.value, 0),
                child: Opacity(
                  opacity: _contentFade.value,
                  child: _buildDetailsScroll(context),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNarrowLayout(BuildContext context) {
    return AnimatedBuilder(
      animation: _entranceController,
      builder: (context, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Transform.scale(
                scale: _heroScale.value,
                child: SizedBox(
                  height: 250,
                  child: _buildPlanetHero(context),
                ),
              ),
              Transform.translate(
                offset: Offset(0, _contentSlide.value),
                child: Opacity(
                  opacity: _contentFade.value,
                  child: _buildDetailsColumn(context),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlanetHero(BuildContext context) {
    final planet = widget.planet;
    final isDark = widget.isDark;

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Orbital rings
          AnimatedBuilder(
            animation: _orbitalController,
            builder: (context, _) {
              return SizedBox(
                width: 280,
                height: 280,
                child: CustomPaint(
                  painter: _OrbitRingsPainter(
                    animationValue: _orbitalController.value,
                    color: planet.primaryColor,
                    isDark: isDark,
                  ),
                ),
              );
            },
          ),
          // Planet emoji
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  planet.primaryColor.withValues(alpha: isDark ? 0.45 : 0.25),
                  planet.primaryColor.withValues(alpha: 0.1),
                  Colors.transparent,
                ],
                stops: const [0.3, 0.6, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: planet.primaryColor.withValues(alpha: isDark ? 0.5 : 0.25),
                  blurRadius: 40,
                  spreadRadius: -5,
                ),
              ],
            ),
            child: Center(
              child: Text(
                planet.emoji,
                style: const TextStyle(fontSize: 56),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsScroll(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(0, 10, 30, 40),
      child: _buildDetailsColumn(context),
    );
  }

  Widget _buildDetailsColumn(BuildContext context) {
    final planet = widget.planet;
    final isDark = widget.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Description card
        GlassCard(
          glowColor: planet.primaryColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      gradient: LinearGradient(
                        colors: [planet.primaryColor, planet.secondaryColor],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'About',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                planet.description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Stats grid
        GlassCard(
          glowColor: planet.primaryColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      gradient: LinearGradient(
                        colors: [planet.primaryColor, planet.secondaryColor],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Vital Statistics',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _buildStatItem(
                    context,
                    Icons.social_distance_rounded,
                    'Distance',
                    '${planet.distanceFromSun} AU',
                    planet.primaryColor,
                    planet.distanceFromSun / 30.06, // normalize to Neptune
                  ),
                  _buildStatItem(
                    context,
                    Icons.straighten_rounded,
                    'Diameter',
                    '${planet.diameter.toStringAsFixed(0)} km',
                    planet.primaryColor,
                    planet.diameter / 142984, // normalize to Jupiter
                  ),
                  _buildStatItem(
                    context,
                    Icons.access_time_rounded,
                    'Orbital Period',
                    '${planet.orbitalPeriod} yrs',
                    planet.primaryColor,
                    min(planet.orbitalPeriod / 164.8, 1.0),
                  ),
                  _buildStatItem(
                    context,
                    Icons.fitness_center_rounded,
                    'Gravity',
                    '${planet.gravity} m/s²',
                    planet.primaryColor,
                    planet.gravity / 24.79, // normalize to Jupiter
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Fun facts
        GlassCard(
          glowColor: planet.primaryColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      gradient: LinearGradient(
                        colors: [planet.primaryColor, planet.secondaryColor],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Did You Know?',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ...planet.facts.asMap().entries.map((entry) {
                return _buildFactItem(
                  context,
                  entry.value,
                  entry.key,
                  planet.primaryColor,
                  isDark,
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color color,
    double ringValue,
  ) {
    return SizedBox(
      width: 140,
      child: Column(
        children: [
          AnimatedRingChart(
            value: ringValue,
            color: color,
            size: 80,
            label: value,
            sublabel: label,
            strokeWidth: 5,
          ),
        ],
      ),
    );
  }

  Widget _buildFactItem(
    BuildContext context,
    String fact,
    int index,
    Color color,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                colors: [
                  color.withValues(alpha: 0.4),
                  color.withValues(alpha: 0.15),
                ],
              ),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              fact,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.9),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Background painter with radial glow
class _PlanetBgPainter extends CustomPainter {
  final double animationValue;
  final Color color;
  final bool isDark;

  _PlanetBgPainter({
    required this.animationValue,
    required this.color,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.3, size.height * 0.4);
    final pulseRadius = size.width * 0.4 +
        sin(animationValue * 2 * pi) * size.width * 0.02;

    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          color.withValues(alpha: isDark ? 0.12 : 0.06),
          color.withValues(alpha: isDark ? 0.04 : 0.02),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(
        Rect.fromCircle(center: center, radius: pulseRadius),
      );

    canvas.drawCircle(center, pulseRadius, paint);
  }

  @override
  bool shouldRepaint(covariant _PlanetBgPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue || oldDelegate.isDark != isDark;
  }
}

/// Orbital rings around the planet hero
class _OrbitRingsPainter extends CustomPainter {
  final double animationValue;
  final Color color;
  final bool isDark;

  _OrbitRingsPainter({
    required this.animationValue,
    required this.color,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = min(size.width, size.height) / 2;

    for (int i = 0; i < 3; i++) {
      final radius = maxRadius * (0.55 + 0.18 * i);
      final opacity = (isDark ? 0.25 : 0.15) - (i * 0.04);

      final paint = Paint()
        ..color = color.withValues(alpha: opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2;

      // Dashed circle
      final dashCount = 50 + i * 15;
      for (int j = 0; j < dashCount; j++) {
        final startAngle = (j / dashCount) * 2 * pi;
        final sweepAngle = (1 / dashCount) * pi * 0.5;

        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle + animationValue * 2 * pi * (i.isEven ? 0.15 : -0.15),
          sweepAngle,
          false,
          paint,
        );
      }

      // Orbiting dot
      final dotAngle =
          animationValue * 2 * pi * (i.isEven ? 0.4 : -0.4) + i * 2.1;
      final dotPos = Offset(
        center.dx + radius * cos(dotAngle),
        center.dy + radius * sin(dotAngle),
      );

      // No MaskFilter.blur for performance
      canvas.drawCircle(
        dotPos,
        3.5,
        Paint()..color = color.withValues(alpha: 0.7),
      );
      canvas.drawCircle(dotPos, 1.5, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant _OrbitRingsPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
