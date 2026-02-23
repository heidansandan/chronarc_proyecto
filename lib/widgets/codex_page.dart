import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/database_service.dart';

// Modelo de datos para definir las propiedades de cada carta mística
class ArcaneCard {
  final String name;
  final String rarity;
  final IconData icon;
  final Color color;
  ArcaneCard({required this.name, required this.rarity, required this.icon, required this.color});
}

// Pantalla principal del Códice que permite visualizar la colección e invocar cartas
class CodexPage extends StatefulWidget {
  const CodexPage({super.key});
  @override
  State<CodexPage> createState() => _CodexPageState();
}

class _CodexPageState extends State<CodexPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final DatabaseService _db = DatabaseService();
  bool _isInvoking = false; // Estado para controlar la animación de invocación

  // Lista maestra de cartas disponibles en el juego
  final List<ArcaneCard> allCards = [
    ArcaneCard(name: 'Fuego Fatuo', rarity: 'Común', icon: Icons.whatshot, color: Colors.orange),
    ArcaneCard(name: 'Escudo de Maná', rarity: 'Rara', icon: Icons.shield, color: Colors.blue),
    ArcaneCard(name: 'Ojo del Caos', rarity: 'Épica', icon: Icons.remove_red_eye, color: Colors.purple),
    ArcaneCard(name: 'Fénix Renacido', rarity: 'Legendaria', icon: Icons.auto_awesome, color: Colors.amber),
    ArcaneCard(name: 'Rayo Arcano', rarity: 'Común', icon: Icons.bolt, color: Colors.cyan),
    ArcaneCard(name: 'Vacío', rarity: 'Épica', icon: Icons.brightness_3, color: Colors.indigo),
    ArcaneCard(name: 'Tormenta', rarity: 'Rara', icon: Icons.cyclone, color: Colors.blueAccent),
  ];

  @override
  void initState() {
    super.initState();
    // Inicialización del controlador de pestañas (Colección e Invocación)
    _tabController = TabController(length: 2, vsync: this);
  }

  // Método que gestiona la lógica de obtención de cartas y gasto de esencia
  void _invokeCard(int currentEssence, List<String> unlockedNames) async {
    if (currentEssence < 100 || _isInvoking) return;
    setState(() => _isInvoking = true);
    
    // Simulación de tiempo de conjuración
    await Future.delayed(const Duration(milliseconds: 2000));
    if (!mounted) return;

    final randomCard = (allCards..shuffle()).first;

    // Lógica para cartas repetidas: devuelve parte de la esencia
    if (unlockedNames.contains(randomCard.name)) {
      await _db.spendEssence(50);
      _showDialog('REPETIDA', 'Ya conocías este secreto. Recuperas 50 ✨', randomCard);
    } else {
      // Lógica para cartas nuevas: gasto total y desbloqueo en la base de datos
      await _db.spendEssence(100);
      await _db.unlockCard(randomCard.name);
      _showDialog('¡NUEVA CARTA!', 'Has descubierto: ${randomCard.name}', randomCard);
    }
    setState(() => _isInvoking = false);
  }

  @override
  Widget build(BuildContext context) {
    // Stream que obtiene en tiempo real los datos del usuario desde Firestore
    return StreamBuilder<DocumentSnapshot>(
      stream: _db.getPlayerStats(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF8B5CF6), strokeWidth: 2));
        }

        final data = snapshot.data?.data() as Map<String, dynamic>?;
        final int essence = data?['essence'] ?? 0;
        final List<String> unlockedNames = List<String>.from(data?['unlockedCards'] ?? []);

        return Column(
          children: [
            // Barra de pestañas superior
            TabBar(
              controller: _tabController,
              indicatorColor: const Color(0xFF8B5CF6),
              indicatorWeight: 1,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white24,
              labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 2),
              tabs: const [Tab(text: 'COLECCIÓN'), Tab(text: 'INVOCACIÓN')],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [_buildGrid(unlockedNames), _buildInvocation(essence, unlockedNames)],
              ),
            ),
          ],
        );
      },
    );
  }

  // Construye la cuadrícula de la pestaña "Colección"
  Widget _buildGrid(List<String> unlockedNames) {
    return GridView.builder(
      padding: const EdgeInsets.all(25),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, childAspectRatio: 0.85, crossAxisSpacing: 20, mainAxisSpacing: 20,
      ),
      itemCount: allCards.length,
      itemBuilder: (context, i) {
        final card = allCards[i];
        final isUnlocked = unlockedNames.contains(card.name);
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF14121B),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: isUnlocked ? card.color.withOpacity(0.2) : Colors.white.withOpacity(0.05)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(isUnlocked ? card.icon : Icons.lock_outline, color: isUnlocked ? card.color : Colors.white10, size: 32),
              const SizedBox(height: 12),
              Text(isUnlocked ? card.name.toUpperCase() : 'BLOQUEADO', 
                style: TextStyle(color: isUnlocked ? Colors.white : Colors.white10, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
            ],
          ),
        );
      },
    );
  }

  // Construye la interfaz de la pestaña "Invocación"
  Widget _buildInvocation(int essence, List<String> unlockedNames) {
    bool allUnlocked = unlockedNames.length == allCards.length;
    final primary = const Color(0xFF8B5CF6);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (allUnlocked) ...[
          // Estado cuando el usuario ya posee todas las cartas
          const Icon(Icons.done_all, color: Colors.white24, size: 40),
          const SizedBox(height: 16),
          const Text('CÓDICE COMPLETO', style: TextStyle(color: Colors.white38, fontSize: 10, letterSpacing: 2)),
        ] else ...[
          // Círculo central minimalista con animación de carga
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _isInvoking ? primary : Colors.white.withOpacity(0.05), width: 1),
            ),
            alignment: Alignment.center,
            child: _isInvoking 
              ? SizedBox(width: 40, height: 40, child: CircularProgressIndicator(color: primary, strokeWidth: 1))
              : Icon(Icons.auto_fix_normal_outlined, color: Colors.white.withOpacity(0.2), size: 40),
          ),
          const SizedBox(height: 60),
          // Indicador de Esencia disponible
          Text('$essence ✨', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w200, color: Colors.white)),
          const Text('ESENCIA ARCANO', style: TextStyle(fontSize: 9, color: Colors.white24, letterSpacing: 2, fontWeight: FontWeight.w900)),
          const SizedBox(height: 60),
          // Botón de interacción para iniciar la invocación
          GestureDetector(
            onTap: _isInvoking ? null : () => _invokeCard(essence, unlockedNames),
            child: Container(
              width: 200,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: essence >= 100 && !_isInvoking ? primary : Colors.white10),
                color: essence >= 100 && !_isInvoking ? primary.withOpacity(0.05) : Colors.transparent,
              ),
              alignment: Alignment.center,
              child: Text(
                _isInvoking ? 'CONJURANDO...' : 'INVOCAR (100)',
                style: TextStyle(
                  color: essence >= 100 && !_isInvoking ? primary : Colors.white10,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  // Muestra el resultado de la invocación en un cuadro de diálogo
  void _showDialog(String title, String desc, ArcaneCard card) {
    showDialog(
      context: context, 
      builder: (c) => AlertDialog(
        backgroundColor: const Color(0xFF0F0E15),
        // Uso de withValues para el borde del diálogo según el código original
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
        content: Column(
          mainAxisSize: MainAxisSize.min, 
          children: [
            const SizedBox(height: 20),
            Icon(card.icon, size: 40, color: card.color),
            const SizedBox(height: 20),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1)),
            const SizedBox(height: 8),
            Text(desc, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white38, fontSize: 12)),
            const SizedBox(height: 30),
            TextButton(
              onPressed: () => Navigator.pop(c),
              child: Text('CONTINUAR', style: TextStyle(color: card.color, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
            )
          ],
        ),
      )
    );
  }
}