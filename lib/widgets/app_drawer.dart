import 'package:flutter/material.dart';
import '../../routes/app_router.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          children: [
            const ListTile(
              title: Text(
                'CHRONARC',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: Text('Foco y rituales'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                // 1. Cerramos el drawer
                Navigator.pop(context);
                // 2. Navegamos a la Shell (que contiene la HomePage)
                // Usamos pushNamedAndRemoveUntil para limpiar la pila si venimos de Créditos
                Navigator.pushNamedAndRemoveUntil(
                  context, 
                  AppRoutes.shell, 
                  (route) => false
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.auto_awesome),
              title: const Text('Créditos'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.credits);
              },
            ),
            const Divider(),
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