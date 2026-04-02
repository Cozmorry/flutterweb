import 'package:flutter/material.dart';

/// Animated theme toggle button with sun/moon transition
class ThemeToggle extends StatefulWidget {
  final bool isDark;
  final ValueChanged<bool> onChanged;

  const ThemeToggle({
    super.key,
    required this.isDark,
    required this.onChanged,
  });

  @override
  State<ThemeToggle> createState() => _ThemeToggleState();
}

class _ThemeToggleState extends State<ThemeToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      value: widget.isDark ? 1.0 : 0.0,
    );
  }

  @override
  void didUpdateWidget(ThemeToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isDark != oldWidget.isDark) {
      if (widget.isDark) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final value = _controller.value;
        return GestureDetector(
          onTap: () => widget.onChanged(!widget.isDark),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              width: 64,
              height: 34,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(17),
                gradient: LinearGradient(
                  colors: [
                    Color.lerp(
                      const Color(0xFF87CEEB), // sky blue
                      const Color(0xFF1A1A3E), // deep night
                      value,
                    )!,
                    Color.lerp(
                      const Color(0xFFFFD700), // golden
                      const Color(0xFF2D1B69), // purple night
                      value,
                    )!,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.lerp(
                      const Color(0xFFFFD700).withValues(alpha: 0.3),
                      const Color(0xFF6C3CE1).withValues(alpha: 0.3),
                      value,
                    )!,
                    blurRadius: 12,
                    spreadRadius: -2,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Stars in dark mode
                  ...List.generate(3, (i) {
                    final positions = [
                      const Offset(12, 8),
                      const Offset(42, 12),
                      const Offset(24, 24),
                    ];
                    return Positioned(
                      left: positions[i].dx,
                      top: positions[i].dy,
                      child: Opacity(
                        opacity: value * 0.8,
                        child: Container(
                          width: 2,
                          height: 2,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    );
                  }),
                  // Toggle knob
                  Positioned(
                    left: 3 + (value * 30),
                    top: 3,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.lerp(
                          const Color(0xFFFFD700),
                          const Color(0xFFF0F0FF),
                          value,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color.lerp(
                              const Color(0xFFFFD700).withValues(alpha: 0.5),
                              const Color(0xFFF0F0FF).withValues(alpha: 0.3),
                              value,
                            )!,
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Sun rays
                          Opacity(
                            opacity: 1 - value,
                            child: const Icon(
                              Icons.wb_sunny_rounded,
                              size: 16,
                              color: Color(0xFFB8860B),
                            ),
                          ),
                          // Moon crescent
                          Opacity(
                            opacity: value,
                            child: Transform.rotate(
                              angle: value * 0.5,
                              child: const Icon(
                                Icons.nightlight_round,
                                size: 16,
                                color: Color(0xFF9090B0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
