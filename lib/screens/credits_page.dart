import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart'; // Importamos tu drawer

class CreditsPage extends StatelessWidget {
  const CreditsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      // Añadimos el Drawer a la pantalla de créditos
      drawer: const AppDrawer(), 
      appBar: AppBar(
        title: const Text('Créditos'),
        centerTitle: true,
        // Forzamos el icono del Drawer en lugar de la flecha de atrás
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Cabecera con Logo y Versión
          Center(
            child: Column(
              children: [
                const Icon(Icons.auto_awesome, size: 60, color: Color(0xFF8B5CF6)),
                const SizedBox(height: 10),
                const Text(
                  'CHRONARC',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  'Gestión de productividad con magia futurista',
                  style: TextStyle(color: Colors.white.withOpacity(0.7)),
                ),
                const SizedBox(height: 5),
                const Text('Versión 1.0.0', style: TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // Sección Desarrollador
          _buildCreditCard(
            context,
            icon: Icons.code,
            title: 'Desarrollador',
            subtitle: 'Álvaro Rodríguez',
            content: 'Proyecto desarrollado como parte del curso de 2º DAM, combinando productividad con una estética única de magia futurista.',
          ),

          // Sección Tecnologías
          _buildSectionCard(
            context,
            icon: Icons.layers,
            title: 'Tecnologías utilizadas',
            subtitle: 'Stack técnico',
            items: [
              'Flutter - Framework principal',
              'Dart - Lenguaje de programación',
              'Material 3 - Sistema de diseño',
              'Image Picker - Gestión de archivos',
            ],
          ),

          // Sección Inspiración
          _buildSectionCard(
            context,
            icon: Icons.auto_stories,
            title: 'Inspiración de diseño',
            subtitle: 'Conceptos y referencias',
            items: [
              'Estética cyberpunk y magia arcana',
              'Sistemas de gamificación de productividad',
              'Interfaces holográficas',
              'Paleta de colores neón (violeta/oscuro)',
            ],
          ),

          const SizedBox(height: 20),
          const Center(
            child: Text('2026 • Chronarc Project', style: TextStyle(color: Colors.white24)),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Widget para tarjetas con texto largo (se mantiene igual)
  Widget _buildCreditCard(BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String content,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: cs.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: cs.primary),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 13)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(content, style: const TextStyle(color: Colors.white70, height: 1.5)),
          ],
        ),
      ),
    );
  }

  // Widget para tarjetas con listas (se mantiene igual)
  Widget _buildSectionCard(BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required List<String> items,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: cs.primary, size: 28),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 13)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15),
            ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(color: cs.primary, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(item, style: const TextStyle(color: Colors.white70))),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}