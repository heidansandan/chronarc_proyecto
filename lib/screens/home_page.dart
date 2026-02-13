import 'package:flutter/material.dart';
import 'ritual_timer_page.dart';

class RitualItem {
  final String title;
  final int minutes;
  final int xp;
  final int essence;

  RitualItem(this.title, this.minutes, this.xp, this.essence);
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // --- TUS VARIABLES RECUPERADAS ---
  int level = 1;
  int xpToday = 0;
  int xpGoal = 300;
  int ritualsDone = 0;
  int essenceTotal = 450; // La esencia que tenías en el perfil

  final rituals = <RitualItem>[
    RitualItem('Sesión de Enfoque', 25, 30, 12),
    RitualItem('Lectura Arcana', 20, 22, 10),
    RitualItem('Práctica de Hechizos', 1, 18, 8),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final progress = (xpToday / xpGoal).clamp(0.0, 1.0);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // --- CUADRO DE ESENCIA Y PROGRESO (ESTILO LOGIN) ---
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF14121B), // El color exacto de tu login
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: cs.primary.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: cs.primary.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _statusBadge('NIVEL $level', cs.primary),
                  _statusBadge('✨ $essenceTotal ESENCIA', Colors.amber),
                ],
              ),
              const SizedBox(height: 25),
              const Text(
                'ESENCIA RECOLECTADA HOY',
                style: TextStyle(fontSize: 12, letterSpacing: 1.5, color: Colors.white54),
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  backgroundColor: Colors.white.withOpacity(0.05),
                  valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('$xpToday / $xpGoal XP', style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('$ritualsDone RITUALES', style: const TextStyle(color: Colors.white38, fontSize: 13)),
                ],
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 35),
        const Text(
          'GRIMORIO DE RITUALES', 
          style: TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 2)
        ),
        const SizedBox(height: 15),

        // Lista de rituales
        ...rituals.map((r) => _ritualCard(r)),
      ],
    );
  }

  Widget _statusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1),
      ),
    );
  }

  Widget _ritualCard(RitualItem r) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF14121B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(r.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.timer_outlined, size: 14, color: Colors.white38),
                    const SizedBox(width: 4),
                    Text('${r.minutes} min', style: const TextStyle(color: Colors.white38, fontSize: 13)),
                    const SizedBox(width: 12),
                    const Icon(Icons.auto_awesome, size: 14, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text('${r.essence}', style: const TextStyle(color: Colors.white38, fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
          FilledButton(
            onPressed: () async {
              final completed = await Navigator.push<bool>(
                context, 
                MaterialPageRoute(builder: (_) => RitualTimerPage(ritual: r))
              );
              
              if (completed == true) {
                setState(() {
                  ritualsDone += 1;
                  xpToday += r.xp;
                  essenceTotal += r.essence;
                });
              }
            },
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
            ),
            child: const Text('Iniciar'),
          ),
        ],
      ),
    );
  }
}