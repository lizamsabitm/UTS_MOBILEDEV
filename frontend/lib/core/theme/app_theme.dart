// core/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  // Design tokens as per PRD
  static const Color background = Color(0xFF14181C);
  static const Color surface = Color(0xFF202830);
  static const Color headerBackground = Color(0xFF000000);
  static const Color textPrimary = Color(0xFFF5F7FA);
  static const Color textSecondary = Color(0xFF9EADB9);
  static const Color divider = Color(0xFF303B45);
  static const Color accentGreen = Color(0xFF00E054);
  static const Color accentBlue = Color(0xFF40BCE8);
  static const Color navSlate = Color(0xFF405566);
  static const Color accentOrange = Color(0xFFFF8000);

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    canvasColor: surface,
    appBarTheme: const AppBarTheme(
      backgroundColor: headerBackground,
      foregroundColor: textPrimary,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 20),
      bodyMedium: TextStyle(color: textPrimary, fontSize: 16),
      bodySmall: TextStyle(color: textSecondary, fontSize: 14),
    ),
    dividerColor: divider,
    colorScheme: const ColorScheme.dark(
      primary: accentBlue,
      secondary: accentGreen,
      surface: surface,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    canvasColor: surface,
    appBarTheme: const AppBarTheme(
      backgroundColor: headerBackground,
      foregroundColor: textPrimary,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 20),
      bodyMedium: TextStyle(color: textPrimary, fontSize: 16),
      bodySmall: TextStyle(color: textSecondary, fontSize: 14),
    ),
    dividerColor: divider,
    colorScheme: const ColorScheme.dark(
      primary: accentBlue,
      secondary: accentGreen,
      surface: surface,
    ),
  );
}
