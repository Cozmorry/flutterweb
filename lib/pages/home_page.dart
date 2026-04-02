import 'package:flutter/material.dart';
import '../models/planet.dart';
import '../widgets/glass_card.dart';
import '../widgets/planet_card.dart';
import '../widgets/theme_toggle.dart';
import '../widgets/animated_ring_chart.dart';
import '../theme/app_theme.dart';
import 'planet_detail_page.dart';

class HomePage extends StatefulWidget {
  final bool isDark;
  final ValueChanged<bool> onThemeChanged;

  const HomePage({
    super.key,
    required this.isDark,
    required this.onThemeChanged,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _headerController;
  late Animation<double> _headerSlide;
  late Animation<double> _headerFade;
  late ScrollController _scrollController;
  int _selectedNavIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _headerSlide = Tween<double>(begin: -30, end: 0).animate(
      CurvedAnimation(
        parent: _headerController,
        curve: Curves.easeOutCubic,
      ),
    );
    _headerFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _headerController,
        curve: Curves.easeOut,
      ),
    );
    _headerController.forward();
  }

  @override
  void dispose() {
    _headerController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 800;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            if (!isWide) _buildMobileNav(context),
            Expanded(
              child: Row(
                children: [
                  if (isWide) _buildSideNav(context),
                  Expanded(
                    child: _buildContent(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return AnimatedBuilder(
      animation: _headerController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _headerSlide.value),
          child: Opacity(
            opacity: _headerFade.value,
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
        child: Row(
          children: [
            // Logo
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: AppTheme.primaryGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.nebulaPurple.withValues(alpha: 0.4),
                    blurRadius: 12,
                    spreadRadius: -2,
                  ),
                ],
              ),
              child: const Center(
                child: Text('🌌', style: TextStyle(fontSize: 22)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cosmos Explorer',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  Text(
                    'Journey through our solar system',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            ThemeToggle(
              isDark: widget.isDark,
              onChanged: widget.onThemeChanged,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSideNav(BuildContext context) {
    final isDark = widget.isDark;
    final items = _navItems;

    return Container(
      width: 72,
      margin: const EdgeInsets.only(left: 16, bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isDark
            ? const Color(0xFF151D2E)
            : Colors.white.withValues(alpha: 0.8),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: items.asMap().entries.map((entry) {
          final isActive = entry.key == _selectedNavIndex;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: _NavItem(
              icon: entry.value.icon,
              label: entry.value.label,
              isActive: isActive,
              color: entry.value.color,
              onTap: () => setState(() => _selectedNavIndex = entry.key),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMobileNav(BuildContext context) {
    final items = _navItems;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: items.asMap().entries.map((entry) {
            final isActive = entry.key == _selectedNavIndex;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _MobileNavChip(
                icon: entry.value.icon,
                label: entry.value.label,
                isActive: isActive,
                color: entry.value.color,
                onTap: () => setState(() => _selectedNavIndex = entry.key),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    switch (_selectedNavIndex) {
      case 0:
        return _buildOverviewTab(context);
      case 1:
        return _buildPlanetsGrid(context);
      case 2:
        return _buildStatsTab(context);
      default:
        return _buildOverviewTab(context);
    }
  }

  Widget _buildOverviewTab(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero banner
          GlassCard(
            glowColor: AppTheme.nebulaPurple,
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) =>
                      AppTheme.cosmicGradient.createShader(bounds),
                  child: Text(
                    'Explore the\nSolar System',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Discover the wonders of our cosmic neighborhood. '
                  'From the scorching surface of Mercury to the icy winds of Neptune — '
                  'every planet has a story to tell.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 20),
                _GradientButton(
                  label: 'Start Exploring',
                  icon: Icons.rocket_launch_rounded,
                  gradient: AppTheme.primaryGradient,
                  onTap: () => setState(() => _selectedNavIndex = 1),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Quick stats row
          Text(
            'Quick Stats',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 500;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _QuickStatCard(
                    icon: Icons.public_rounded,
                    label: '8 Planets',
                    sublabel: 'In our solar system',
                    color: AppTheme.cosmicBlue,
                    width: isNarrow
                        ? constraints.maxWidth
                        : (constraints.maxWidth - 24) / 3,
                  ),
                  _QuickStatCard(
                    icon: Icons.nightlight_round,
                    label: '290+ Moons',
                    sublabel: 'Known natural satellites',
                    color: AppTheme.stellarCyan,
                    width: isNarrow
                        ? constraints.maxWidth
                        : (constraints.maxWidth - 24) / 3,
                  ),
                  _QuickStatCard(
                    icon: Icons.wb_sunny_rounded,
                    label: '4.6B Years',
                    sublabel: 'Age of our solar system',
                    color: AppTheme.solarOrange,
                    width: isNarrow
                        ? constraints.maxWidth
                        : (constraints.maxWidth - 24) / 3,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),

          // Featured planets
          Text(
            'Featured Planets',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          ...solarSystemPlanets.take(3).toList().asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: PlanetCard(
                planet: entry.value,
                index: entry.key,
                onTap: () => _openPlanetDetail(entry.value),
              ),
            );
          }),
          // CTA to see all
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: _GradientButton(
                label: 'View All Planets',
                icon: Icons.grid_view_rounded,
                gradient: AppTheme.accentGradient,
                onTap: () => setState(() => _selectedNavIndex = 1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanetsGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 1000
            ? 3
            : constraints.maxWidth > 600
                ? 2
                : 1;

        return GridView.builder(
          padding: const EdgeInsets.all(20),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
          ),
          itemCount: solarSystemPlanets.length,
          itemBuilder: (context, index) {
            return PlanetCard(
              planet: solarSystemPlanets[index],
              index: index,
              onTap: () => _openPlanetDetail(solarSystemPlanets[index]),
            );
          },
        );
      },
    );
  }

  Widget _buildStatsTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Solar System Comparison',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Compare the planets across different metrics',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),

          // Size comparison
          GlassCard(
            glowColor: AppTheme.cosmicBlue,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionHeader(context, 'Planet Sizes', Icons.straighten_rounded,
                    AppTheme.cosmicBlue),
                const SizedBox(height: 20),
                ...solarSystemPlanets.map((planet) {
                  final normalized = planet.diameter / 142984; // Jupiter max
                  return _ComparisonBar(
                    label: planet.name,
                    value: normalized,
                    displayValue: '${planet.diameter.toStringAsFixed(0)} km',
                    color: planet.primaryColor,
                    emoji: planet.emoji,
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Gravity comparison
          GlassCard(
            glowColor: AppTheme.solarOrange,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionHeader(context, 'Surface Gravity',
                    Icons.fitness_center_rounded, AppTheme.solarOrange),
                const SizedBox(height: 20),
                ...solarSystemPlanets.map((planet) {
                  final normalized = planet.gravity / 24.79;
                  return _ComparisonBar(
                    label: planet.name,
                    value: normalized,
                    displayValue: '${planet.gravity} m/s²',
                    color: planet.primaryColor,
                    emoji: planet.emoji,
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Moon count
          GlassCard(
            glowColor: AppTheme.stellarCyan,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionHeader(context, 'Moon Count',
                    Icons.nightlight_round, AppTheme.stellarCyan),
                const SizedBox(height: 20),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isNarrow = constraints.maxWidth < 400;
                    return Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: solarSystemPlanets.map((planet) {
                        final maxMoons = 146.0; // Saturn
                        return SizedBox(
                          width: isNarrow ? (constraints.maxWidth - 12) / 2 : 100,
                          child: AnimatedRingChart(
                            value: planet.moons / maxMoons,
                            color: planet.primaryColor,
                            size: 80,
                            label: '${planet.moons}',
                            sublabel: planet.name,
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(
      BuildContext context, String title, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: color.withValues(alpha: 0.15),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }

  void _openPlanetDetail(Planet planet) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) {
          return PlanetDetailPage(
            planet: planet,
            isDark: widget.isDark,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );
          return FadeTransition(
            opacity: curvedAnimation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.05, 0),
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: child,
            ),
          );
        },
      ),
    );
  }

  List<_NavItemData> get _navItems => [
        _NavItemData(
          icon: Icons.dashboard_rounded,
          label: 'Overview',
          color: AppTheme.nebulaPurple,
        ),
        _NavItemData(
          icon: Icons.public_rounded,
          label: 'Planets',
          color: AppTheme.cosmicBlue,
        ),
        _NavItemData(
          icon: Icons.insights_rounded,
          label: 'Stats',
          color: AppTheme.stellarCyan,
        ),
      ];
}

class _NavItemData {
  final IconData icon;
  final String label;
  final Color color;
  _NavItemData({required this.icon, required this.label, required this.color});
}

class _NavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final Color color;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.color,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isActive = widget.isActive;
    final color = widget.color;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: isActive
                ? color.withValues(alpha: isDark ? 0.25 : 0.15)
                : _isHovered
                    ? (isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.black.withValues(alpha: 0.06))
                    : Colors.transparent,
            border: Border.all(
              color: isActive
                  ? color.withValues(alpha: 0.3)
                  : Colors.transparent,
            ),
          ),
          child: Tooltip(
            message: widget.label,
            child: Icon(
              widget.icon,
              size: 22,
              color: isActive
                  ? color
                  : (isDark ? AppTheme.moonGray : AppTheme.moonGray),
            ),
          ),
        ),
      ),
    );
  }
}

class _MobileNavChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final Color color;
  final VoidCallback onTap;

  const _MobileNavChip({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isActive
                ? color.withValues(alpha: isDark ? 0.2 : 0.1)
                : Colors.transparent,
            border: Border.all(
              color: isActive
                  ? color.withValues(alpha: 0.3)
                  : (isDark
                      ? Colors.white.withValues(alpha: 0.06)
                      : Colors.black.withValues(alpha: 0.06)),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: isActive ? color : AppTheme.moonGray,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive
                      ? color
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GradientButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _GradientButton({
    required this.label,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  State<_GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<_GradientButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: widget.gradient,
            boxShadow: [
              BoxShadow(
                color: widget.gradient.colors.first
                    .withValues(alpha: _isHovered ? 0.5 : 0.3),
                blurRadius: _isHovered ? 20 : 12,
                spreadRadius: -4,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 18, color: Colors.white),
              const SizedBox(width: 10),
              Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;
  final Color color;
  final double width;

  const _QuickStatCard({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.color,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      width: width,
      glowColor: color,
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: color.withValues(alpha: 0.2),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                Text(
                  sublabel,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ComparisonBar extends StatefulWidget {
  final String label;
  final double value; // 0 to 1
  final String displayValue;
  final Color color;
  final String emoji;

  const _ComparisonBar({
    required this.label,
    required this.value,
    required this.displayValue,
    required this.color,
    required this.emoji,
  });

  @override
  State<_ComparisonBar> createState() => _ComparisonBarState();
}

class _ComparisonBarState extends State<_ComparisonBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animation = Tween<double>(begin: 0, end: widget.value).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(
              widget.emoji,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(
            width: 70,
            child: Text(
              widget.label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, _) {
                return Container(
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.black.withValues(alpha: 0.07),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: _animation.value.clamp(0.02, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          colors: [
                            widget.color.withValues(alpha: 0.8),
                            widget.color,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: widget.color.withValues(alpha: 0.3),
                            blurRadius: 8,
                            spreadRadius: -2,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 80,
            child: Text(
              widget.displayValue,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
