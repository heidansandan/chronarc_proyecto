import 'package:flutter/material.dart';

// Clase encargada de definir la identidad visual de la aplicación
class AppTheme {
  // Configuración del tema oscuro global
  static ThemeData dark() {
    const Color primaryColor = Color(0xFF8B5CF6);
    const Color backgroundColor = Color(0xFF0B0B12);
    const Color cardColor = Color(0xFF14121B);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundColor,
      cardColor: cardColor,
      // Definición de la paleta de colores basada en una semilla
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
        primary: primaryColor,
        surface: cardColor,
      ),
      // Estilo personalizado para las barras superiores de la app
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
      // Configuración por defecto para botones rellenos
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        ),
      ),
      // Estilo de la barra de navegación inferior
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: cardColor,
        indicatorColor: primaryColor.withOpacity(0.2),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}