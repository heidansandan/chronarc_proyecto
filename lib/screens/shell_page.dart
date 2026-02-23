import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../widgets/codex_page.dart';
import '../screens/home_page.dart';
import '../screens/profile_page.dart';

// Página contenedor que gestiona la navegación principal mediante pestañas inferiores
class ShellPage extends StatefulWidget {
  const ShellPage({super.key});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  int _index = 0; // Índice de la página seleccionada actualmente

  // Lista de widgets que representan cada sección de la app
  final _pages = const [
    HomePage(),
    CodexPage(),
    ProfilePage(),
  ];

  // Genera el título dinámico para la AppBar según la sección activa
  String get _title => switch (_index) {
        0 => 'RUN DE HOY',
        1 => 'CÓDICE',
        _ => 'PERFIL',
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(), // Menú lateral común a todas las vistas
      appBar: AppBar(title: Text(_title)),
      // IndexedStack mantiene el estado de todas las páginas sin reiniciarlas al cambiar de pestaña
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined), 
            selectedIcon: Icon(Icons.auto_awesome), 
            label: 'Run'
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined), 
            selectedIcon: Icon(Icons.menu_book), 
            label: 'Códice'
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline), 
            selectedIcon: Icon(Icons.person), 
            label: 'Perfil'
          ),
        ],
      ),
    );
  }
}