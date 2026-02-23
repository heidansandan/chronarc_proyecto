import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart'; // Importación del menú lateral personalizado

class CreditsPage extends StatelessWidget {
  const CreditsPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // Se integra el Drawer para permitir la navegación desde esta pantalla
      drawer: const AppDrawer(), 
      appBar: AppBar(
        title: const Text('Créditos'),
        centerTitle: true,
        // Se usa un Builder para obtener el context adecuado y poder abrir el Drawer
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
          // Sección de Cabecera: Icono místico, nombre de la app y eslogan
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

          // Tarjeta de información del Desarrollador
          _buildCreditCard(
            context,
            icon: Icons.code,
            title: 'Desarrollador',
            subtitle: 'Álvaro Rodríguez',
            content: 'Proyecto desarrollado como parte del curso de 2º DAM, combinando productividad con una estética única de magia futurista.',
          ),

          // Tarjeta que detalla las tecnologías del Stack Técnico
          _buildSectionCard(
            context,
            icon: Icons.layers,
            title: 'Tecnologías utilizadas',
            subtitle: 'Stack técnico',
            items: [
              'Flutter - Framework principal',
              'Dart - Lenguaje de programación',
            ],
          ),

          // Tarjeta con los conceptos creativos de diseño
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

          // Pie de página con copyright simbólico
          const SizedBox(height: 20),
          const Center(
            child: Text('2026 • Chronarc Project', style: TextStyle(color: Colors.white24)),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Widget auxiliar para crear tarjetas con bloques de texto descriptivo
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
                // Contenedor decorativo para el icono de la sección
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

  // Widget auxiliar para crear tarjetas que contienen listas de elementos (bullets)
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
            // Mapeo de la lista de strings a widgets individuales con un punto (bullet) de color
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