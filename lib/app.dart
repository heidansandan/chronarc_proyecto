import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/login_page.dart';
import 'screens/shell_page.dart';
import 'screens/splash_page.dart';
import 'screens/credits_page.dart';
import 'routes/app_router.dart';    
import 'theme/app_theme.dart';

// Widget raíz de la aplicación que configura el MaterialApp y el flujo de autenticación
class ChronarcApp extends StatefulWidget {
  const ChronarcApp({super.key});

  @override
  State<ChronarcApp> createState() => _ChronarcAppState();
}

class _ChronarcAppState extends State<ChronarcApp> {
  
  @override
  void initState() {
    super.initState();
    // Forzamos el cierre de sesión al iniciar para pruebas de flujo
    FirebaseAuth.instance.signOut();
  }

  // Stream que introduce un pequeño retraso para permitir ver la Splash Page
  Stream<User?> _getDelayedAuthStatus() async* {
    await Future.delayed(const Duration(seconds: 2));
    yield* FirebaseAuth.instance.authStateChanges();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chronarc',
      theme: AppTheme.dark(), // Aplicación del tema oscuro definido
      // Lógica de decisión de pantalla inicial basada en el estado de Firebase Auth
      home: StreamBuilder<User?>(
        stream: _getDelayedAuthStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashPage(); 
          }
          if (snapshot.hasData && snapshot.data != null) {
            return const ShellPage(); // Usuario autenticado
          }
          return const LoginPage(); // Usuario no identificado
        },
      ),
      // Registro de rutas nombradas para la navegación por la app
      routes: AppRouter.routes,
    );
  }
}