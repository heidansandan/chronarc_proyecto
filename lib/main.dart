import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app.dart';

// Punto de entrada principal de la aplicación Flutter
void main() async {
  // Asegura que los bindings de Flutter estén inicializados antes de servicios externos
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialización de Firebase con las opciones específicas de la plataforma
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Lanzamiento de la aplicación
  runApp(const ChronarcApp());
}