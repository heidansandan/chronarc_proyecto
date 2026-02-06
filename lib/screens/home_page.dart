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
  int level = 1;
  int xpToday = 0;
  int xpGoal = 300;
  int ritualsDone = 0;
  int streak = 0;
  int essence = 0;

  final rituals = <RitualItem>[
    RitualItem('Sesión de Enfoque', 25, 30, 12),
    RitualItem('Lectura Arcana', 20, 22, 10),
    RitualItem('Práctica de Hechizos', 15, 18, 8),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final progress = (xpToday / xpGoal).clamp(0.0, 1.0);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _infoCard(
          context,
          title: 'Nivel $level',
          subtitle: '$ritualsDone rituales completados · Racha: $streak',
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('$xpToday / $xpGoal XP', style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              SizedBox(
                width: 140,
                child: LinearProgressIndicator(value: progress, minHeight: 8),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _infoCard(
          context,
          title: 'Esencia Arcana',
          subtitle: 'Moneda para desbloquear cartas',
          trailing: Text('$essence ✨', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: cs.primary)),
        ),
        const SizedBox(height: 18),
        const Text('Run de hoy', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        const Text('Completa rituales para ganar XP y desbloquear cartas.'),
        const SizedBox(height: 12),
        ...rituals.map((r) => _ritualCard(context, r)),
      ],
    );
  }

  Widget _infoCard(BuildContext context,
      {required String title, required String subtitle, required Widget trailing}) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Icon(Icons.auto_awesome, color: cs.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            trailing,
          ],
        ),
      ),
    );
  }

  Widget _ritualCard(BuildContext context, RitualItem r) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(r.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                ),
                Text('${r.minutes} min', style: const TextStyle(color: Colors.white70)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('⭐ ${r.xp} XP', style: const TextStyle(color: Colors.white70)),
                const SizedBox(width: 12),
                Text('✨ ${r.essence}', style: const TextStyle(color: Colors.white70)),
                const Spacer(),
                FilledButton(
                  onPressed: () async {
                    final completed = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(builder: (_) => RitualTimerPage(ritual: r)),
                    );
                    if (completed == true) {
                      setState(() {
                        ritualsDone += 1;
                        xpToday += r.xp;
                        essence += r.essence;
                      });
                    }
                  },
                  child: const Text('Iniciar'),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text('Estado: Pendiente', style: TextStyle(color: Colors.white54)),
          ],
        ),
      ),
    );
  }
}