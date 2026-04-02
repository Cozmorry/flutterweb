import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ─── Cosmic Color Palette ───
  static const Color _deepSpace = Color(0xFF0B0E1A);
  static const Color _nebulaPurple = Color(0xFF6C3CE1);
  static const Color _cosmicBlue = Color(0xFF3B82F6);
  static const Color _stellarCyan = Color(0xFF22D3EE);
  static const Color _auroraGreen = Color(0xFF10B981);
  static const Color _solarOrange = Color(0xFFF59E0B);
  static const Color _marsRed = Color(0xFFEF4444);
  static const Color _starWhite = Color(0xFFF8FAFC);
  static const Color _moonGray = Color(0xFFB0BEC5);
  static const Color _surfaceDark = Color(0xFF111827);
  static const Color _cardDark = Color(0xFF1E293B);
  static const Color _cardDarkHover = Color(0xFF263348);

  // Light theme colors
  static const Color _lightBg = Color(0xFFF0F4FF);
  static const Color _lightSurface = Color(0xFFFFFFFF);
  static const Color _lightCard = Color(0xFFF8FAFF);
  static const Color _lightCardHover = Color(0xFFEEF2FF);
  static const Color _lightText = Color(0xFF1E293B);
  static const Color _lightTextSecondary = Color(0xFF475569);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: _deepSpace,
      colorScheme: const ColorScheme.dark(
        primary: _nebulaPurple,
        secondary: _stellarCyan,
        tertiary: _cosmicBlue,
        surface: _surfaceDark,
        error: _marsRed,
        onPrimary: _starWhite,
        onSecondary: _deepSpace,
        onSurface: _starWhite,
        outline: Color(0xFF334155),
      ),
      cardTheme: CardThemeData(
        color: _cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      textTheme: _buildTextTheme(Brightness.dark),
      iconTheme: const IconThemeData(color: _starWhite),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: _lightBg,
      colorScheme: const ColorScheme.light(
        primary: _nebulaPurple,
        secondary: _stellarCyan,
        tertiary: _cosmicBlue,
        surface: _lightSurface,
        error: _marsRed,
        onPrimary: _starWhite,
        onSecondary: _deepSpace,
        onSurface: _lightText,
        outline: Color(0xFFCBD5E1),
      ),
      cardTheme: CardThemeData(
        color: _lightCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      textTheme: _buildTextTheme(Brightness.light),
      iconTheme: const IconThemeData(color: _lightText),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }

  static TextTheme _buildTextTheme(Brightness brightness) {
    final Color textColor =
        brightness == Brightness.dark ? _starWhite : _lightText;
    final Color secondaryColor =
        brightness == Brightness.dark ? _moonGray : _lightTextSecondary;

    return GoogleFonts.outfitTextTheme(
      TextTheme(
        displayLarge: TextStyle(
          fontSize: 56,
          fontWeight: FontWeight.w800,
          color: textColor,
          letterSpacing: -1.5,
          height: 1.1,
        ),
        displayMedium: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w700,
          color: textColor,
          letterSpacing: -1.0,
          height: 1.2,
        ),
        displaySmall: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: textColor,
          letterSpacing: -0.5,
        ),
        headlineLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
        headlineSmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: secondaryColor,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textColor,
          height: 1.6,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: secondaryColor,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: secondaryColor,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // Gradient presets
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [_nebulaPurple, _cosmicBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [_stellarCyan, _auroraGreen],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warmGradient = LinearGradient(
    colors: [_solarOrange, _marsRed],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cosmicGradient = LinearGradient(
    colors: [_nebulaPurple, _stellarCyan, _cosmicBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Color accessors for widgets
  static Color get nebulaPurple => _nebulaPurple;
  static Color get cosmicBlue => _cosmicBlue;
  static Color get stellarCyan => _stellarCyan;
  static Color get auroraGreen => _auroraGreen;
  static Color get solarOrange => _solarOrange;
  static Color get marsRed => _marsRed;
  static Color get starWhite => _starWhite;
  static Color get moonGray => _moonGray;
  static Color get deepSpace => _deepSpace;
  static Color get cardDark => _cardDark;
  static Color get cardDarkHover => _cardDarkHover;
  static Color get lightCard => _lightCard;
  static Color get lightCardHover => _lightCardHover;
  static Color get lightBg => _lightBg;
}
