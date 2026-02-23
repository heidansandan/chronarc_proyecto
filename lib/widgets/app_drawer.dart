import 'package:flutter/material.dart';
import '../../routes/app_router.dart';

// Widget que representa el menú lateral de navegación
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          children: [
            // Cabecera del menú con el nombre de la app
            const ListTile(
              title: Text(
                'CHRONARC',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: Text('Foco y rituales'),
            ),
            const Divider(),
            // Opción para volver a la pantalla principal
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                Navigator.pop(context); // Cierra el drawer
                // Navega a la Shell limpiando el historial para evitar bucles
                Navigator.pushNamedAndRemoveUntil(
                  context, 
                  AppRoutes.shell, 
                  (route) => false
                );
              },
            ),
            // Opción para ver los créditos del proyecto
            ListTile(
              leading: const Icon(Icons.auto_awesome),
              title: const Text('Créditos'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.credits);
              },
            ),
            const Divider(),
            // Opción para desconectar la cuenta actual
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar sesión'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (_) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}