import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'painters/starfield_painter.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const CosmosExplorerApp());
}

class CosmosExplorerApp extends StatefulWidget {
  const CosmosExplorerApp({super.key});

  @override
  State<CosmosExplorerApp> createState() => _CosmosExplorerAppState();
}

class _CosmosExplorerAppState extends State<CosmosExplorerApp> {
  bool _isDark = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cosmos Explorer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      home: _AppShell(
        isDark: _isDark,
        onThemeChanged: (dark) => setState(() => _isDark = dark),
      ),
    );
  }
}

/// Root shell that layers the animated background beneath pages
class _AppShell extends StatelessWidget {
  final bool isDark;
  final ValueChanged<bool> onThemeChanged;

  const _AppShell({
    required this.isDark,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      color: isDark ? AppTheme.deepSpace : AppTheme.lightBg,
      child: Stack(
        children: [
          // Animated background
          Positioned.fill(
            child: AnimatedStarfield(isDark: isDark),
          ),
          // Main content
          Positioned.fill(
            child: HomePage(
              isDark: isDark,
              onThemeChanged: onThemeChanged,
            ),
          ),
        ],
      ),
    );
  }
}
