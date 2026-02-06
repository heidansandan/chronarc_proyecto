import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData dark() {
    const seed = Color(0xFF8B5CF6);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seed,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF0B0B12),
      cardColor: const Color(0xFF151528),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0B0B12),
        elevation: 0,
      ),
    );
  }
}