import 'package:flutter/material.dart';
import '../painters/ring_chart_painter.dart';

/// Animated ring chart widget with a label in the center
class AnimatedRingChart extends StatefulWidget {
  final double value; // 0.0 to 1.0
  final Color color;
  final double size;
  final String label;
  final String? sublabel;
  final Duration duration;
  final double strokeWidth;

  const AnimatedRingChart({
    super.key,
    required this.value,
    required this.color,
    this.size = 80,
    required this.label,
    this.sublabel,
    this.duration = const Duration(milliseconds: 1500),
    this.strokeWidth = 6,
  });

  @override
  State<AnimatedRingChart> createState() => _AnimatedRingChartState();
}

class _AnimatedRingChartState extends State<AnimatedRingChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = Tween<double>(begin: 0, end: widget.value).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    // Delay for stagger effect
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void didUpdateWidget(AnimatedRingChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: widget.value,
      ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
      );
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final trackColor = isDark
        ? Colors.white.withValues(alpha: 0.12)
        : Colors.black.withValues(alpha: 0.08);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(widget.size, widget.size),
                painter: RingChartPainter(
                  progress: _animation.value,
                  color: widget.color,
                  trackColor: trackColor,
                  strokeWidth: widget.strokeWidth,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.label,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: widget.size * 0.16,
                        ),
                  ),
                  if (widget.sublabel != null)
                    Text(
                      widget.sublabel!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: widget.size * 0.1,
                          ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
