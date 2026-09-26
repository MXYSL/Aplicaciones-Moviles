import 'package:flutter/material.dart';

class AppTheme {
  static const Color basilGreen = Color(0xFF2E7D32);
  static const Color warmOrange = Color(0xFFF57C00);
  static const Color cream = Color(0xFFFFF8E7);

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: basilGreen,
      brightness: Brightness.light,
    ).copyWith(primary: basilGreen, secondary: warmOrange, surface: cream);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFFFFFBF2),
      appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
      cardTheme: const CardThemeData(elevation: 1, margin: EdgeInsets.zero),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: basilGreen,
          brightness: Brightness.dark,
        ).copyWith(
          primary: const Color(0xFF81C784),
          secondary: const Color(0xFFFFB74D),
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFF171A17),
      appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
      cardTheme: const CardThemeData(elevation: 1, margin: EdgeInsets.zero),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
