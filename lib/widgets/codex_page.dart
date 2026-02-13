import 'package:flutter/material.dart';

// Modelo para las cartas del Códice
class ArcaneCard {
  final String name;
  final String rarity; // Común, Rara, Épica, Legendaria
  final IconData icon;
  final Color color;
  bool isUnlocked;

  ArcaneCard({
    required this.name,
    required this.rarity,
    required this.icon,
    required this.color,
    this.isUnlocked = false,
  });
}

class CodexPage extends StatefulWidget {
  const CodexPage({super.key});

  @override
  State<CodexPage> createState() => _CodexPageState();
}

class _CodexPageState extends State<CodexPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int essence = 450; // Esto debería venir de un estado global en el futuro

  // Lista de cartas de ejemplo
  final List<ArcaneCard> _myCards = [
    ArcaneCard(name: 'Fuego Fatuo', rarity: 'Común', icon: Icons.whatshot, color: Colors.orange, isUnlocked: true),
    ArcaneCard(name: 'Escudo de Maná', rarity: 'Rara', icon: Icons.shield, color: Colors.blue, isUnlocked: true),
    ArcaneCard(name: 'Ojo del Caos', rarity: 'Épica', icon: Icons.remove_red_eye, color: Colors.purple, isUnlocked: false),
    ArcaneCard(name: 'Fénix Renacido', rarity: 'Legendaria', icon: Icons.auto_awesome, color: Colors.amber, isUnlocked: false),
    ArcaneCard(name: 'Rayo Arcano', rarity: 'Común', icon: Icons.bolt, color: Colors.cyan, isUnlocked: true),
    ArcaneCard(name: 'Vacío', rarity: 'Épica', icon: Icons.brightness_3, color: Colors.indigo, isUnlocked: false),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      children: [
        // Selector de pestañas con estilo ChronArc
        TabBar(
          controller: _tabController,
          indicatorColor: cs.primary,
          labelColor: cs.primary,
          unselectedLabelColor: Colors.white38,
          dividerColor: Colors.transparent,
          tabs: const [
            Tab(text: 'COLECCIÓN'),
            Tab(text: 'INVOCACIÓN'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildCollectionGrid(),
              _buildInvocationView(cs),
            ],
          ),
        ),
      ],
    );
  }

  // --- VISTA DE COLECCIÓN ---
  Widget _buildCollectionGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemCount: _myCards.length,
      itemBuilder: (context, i) => _buildCardTile(_myCards[i]),
    );
  }

Widget _buildCardTile(ArcaneCard card) {
  return Container(
    decoration: BoxDecoration(
      color: const Color(0xFF14121B),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: card.isUnlocked ? card.color.withOpacity(0.4) : Colors.white10,
        width: 2,
      ),
    ),
    child: Stack(
      children: [
        // Contenido principal
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Centrado vertical absoluto
            children: [
              // 1. Icono con tamaño fijo para que no mueva el resto
              SizedBox(
                height: 60, 
                child: Center(
                  child: Icon(
                    card.isUnlocked ? card.icon : Icons.lock_outline,
                    size: card.isUnlocked ? 48 : 35,
                    color: card.isUnlocked ? card.color : Colors.white10,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              
              // 2. Nombre de la carta
              Text(
                card.isUnlocked ? card.name.toUpperCase() : 'BLOQUEADO',
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  color: card.isUnlocked ? Colors.white : Colors.white10,
                ),
              ),
              const SizedBox(height: 4),

              // 3. Rareza (Invisible si está bloqueada, pero OCUPA espacio para mantener el centro)
              Opacity(
                opacity: card.isUnlocked ? 1.0 : 0.0,
                child: Text(
                  card.rarity.toUpperCase(),
                  style: TextStyle(
                    fontSize: 9, 
                    color: card.color, 
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w900
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

  // --- VISTA DE INVOCACIÓN (ABRIR SOBRES) ---
  Widget _buildInvocationView(ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Visual del Sobre/Gema
          Container(
            height: 200,
            width: 150,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [cs.primary, Colors.deepPurple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(color: cs.primary.withOpacity(0.3), blurRadius: 30, spreadRadius: 5)
              ],
            ),
            child: const Icon(Icons.auto_fix_high, size: 60, color: Colors.white),
          ),
          const SizedBox(height: 40),
          Text(
            'SOBRE ARCANO',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: cs.primary, letterSpacing: 2),
          ),
          const SizedBox(height: 10),
          const Text(
            'Contiene una carta aleatoria para tu grimorio',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54),
          ),
          const SizedBox(height: 40),
          
          // Botón de compra
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: essence >= 100 ? _invokeCard : null,
              child: Text(essence >= 100 ? 'INVOCAR (100 ✨)' : 'ESENCIA INSUFICIENTE'),
            ),
          ),
          const SizedBox(height: 20),
          Text('Tu Esencia: $essence ✨', style: const TextStyle(color: Colors.amber)),
        ],
      ),
    );
  }

  void _invokeCard() {
    setState(() {
      essence -= 100;
    });
    
    // Aquí podrías añadir una animación de apertura
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF14121B),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('¡INVOCACIÓN COMPLETADA!', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const Icon(Icons.auto_awesome, size: 80, color: Colors.amber),
            const SizedBox(height: 20),
            const Text('Has desbloqueado una nueva página del códice'),
            const SizedBox(height: 20),
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('ACEPTAR')),
          ],
        ),
      ),
    );
  }
}