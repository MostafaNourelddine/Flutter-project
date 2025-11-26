import 'package:flutter/material.dart';

class AppTheme {
  // Custom seed color for Material 3
  static const Color seedColor = Color(0xFF6750A4);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.light,
      ),
      textTheme: _textTheme(ThemeData.light().textTheme),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.dark,
      ),
      textTheme: _textTheme(ThemeData.dark().textTheme),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  // Font scaling configuration
  static TextTheme _textTheme(TextTheme base) {
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(fontSize: 32),
      displayMedium: base.displayMedium?.copyWith(fontSize: 28),
      displaySmall: base.displaySmall?.copyWith(fontSize: 24),
      headlineLarge: base.headlineLarge?.copyWith(fontSize: 22),
      headlineMedium: base.headlineMedium?.copyWith(fontSize: 20),
      headlineSmall: base.headlineSmall?.copyWith(fontSize: 18),
      titleLarge: base.titleLarge?.copyWith(fontSize: 16),
      titleMedium: base.titleMedium?.copyWith(fontSize: 14),
      titleSmall: base.titleSmall?.copyWith(fontSize: 12),
    );
  }
}


