import 'package:flutter/material.dart';
import '../screens/login_page.dart';
import '../screens/credits_page.dart';
import '../screens/shell_page.dart';
import '../screens/splash_page.dart';

// Clase que centraliza las etiquetas de las rutas para evitar errores de escritura
class AppRoutes {
  static const splash = '/splash';
  static const login = '/login';
  static const shell = '/shell';
  static const credits = '/credits';
}

// Clase encargada de mapear los nombres de las rutas con sus respectivos Widgets
class AppRouter {
  static final Map<String, WidgetBuilder> routes = {
    // Ruta de carga inicial (Splash Screen)
    AppRoutes.splash: (_) => const SplashPage(),
    
    // Ruta hacia la pantalla de autenticación (Login/Registro)
    AppRoutes.login: (_) => const LoginPage(), 
    
    // Ruta hacia la estructura principal de la app (Navegación por pestañas)
    AppRoutes.shell: (_) => const ShellPage(),
    
    // Ruta hacia la pantalla informativa de créditos
    AppRoutes.credits: (_) => const CreditsPage(),
  };
}