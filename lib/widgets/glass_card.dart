import 'package:flutter/material.dart';

/// A premium card with solid backgrounds, glow borders, and hover effects.
/// No BackdropFilter — fast on Flutter web.
class GlassCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final double borderRadius;
  final Color? glowColor;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.onTap,
    this.borderRadius = 20,
    this.glowColor,
  });

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final glowColor = widget.glowColor;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          width: widget.width,
          height: widget.height,
          margin: widget.margin,
          transform: widget.onTap != null && _isHovered
              ? (Matrix4.identity()..scale(1.015, 1.015))
              : Matrix4.identity(),
          transformAlignment: Alignment.center,
          padding: widget.padding ?? const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: _isHovered && glowColor != null
                  ? glowColor.withValues(alpha: isDark ? 0.5 : 0.4)
                  : isDark
                      ? Colors.white.withValues(alpha: 0.12)
                      : Colors.black.withValues(alpha: 0.08),
              width: _isHovered ? 1.5 : 1,
            ),
            // Solid, opaque backgrounds — no blur needed
            color: isDark
                ? (_isHovered
                    ? const Color(0xFF1F2A3F)
                    : const Color(0xFF182033))
                : (_isHovered
                    ? const Color(0xFFFFFFFF)
                    : const Color(0xFFF5F7FF)),
            boxShadow: [
              if (_isHovered && glowColor != null)
                BoxShadow(
                  color: glowColor.withValues(alpha: isDark ? 0.25 : 0.15),
                  blurRadius: 24,
                  spreadRadius: -4,
                ),
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
                blurRadius: _isHovered ? 16 : 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
