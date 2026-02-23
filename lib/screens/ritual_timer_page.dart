import 'dart:async';
import 'package:flutter/material.dart';
import '../services/database_service.dart';

// Pantalla del cronómetro que gestiona la ejecución de un ritual
class RitualTimerPage extends StatefulWidget {
  final Map<String, dynamic> ritual;
  const RitualTimerPage({super.key, required this.ritual});

  @override
  State<RitualTimerPage> createState() => _RitualTimerPageState();
}

class _RitualTimerPageState extends State<RitualTimerPage> {
  late int _secondsRemaining;
  Timer? _timer;
  bool _isPaused = false;
  final DatabaseService _db = DatabaseService();

  @override
  void initState() {
    super.initState();
    // Convierte los minutos del ritual a segundos para el contador
    _secondsRemaining = (widget.ritual['min'] as int) * 60;
    _startTimer();
  }

  // Inicia la cuenta atrás segundo a segundo
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _timer?.cancel();
        _onCompleted(); // Ejecuta la lógica de recompensa al finalizar
      }
    });
  }

  // Gestiona la entrega de premios al terminar el tiempo
  void _onCompleted() async {
    final int essenceReward = widget.ritual['essence'] ?? 0;
    final int xpReward = (widget.ritual['min'] as int) * 2; // Recompensa proporcional al tiempo

    await _db.addRitualRewards(essenceReward, xpReward);
    
    if (mounted) {
      Navigator.pop(context, true); // Regresa a la pantalla anterior
    }
  }

  // Alterna entre pausa y continuación del tiempo
  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
      if (_isPaused) _timer?.cancel(); else _startTimer();
    });
  }

  // Formatea los segundos restantes en formato MM:SS
  String _formatTime(int seconds) {
    int mins = seconds ~/ 60;
    int secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel(); // Asegura la limpieza del timer al cerrar la pantalla
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Cálculo del porcentaje de progreso para el indicador circular
    double progress = 1 - (_secondsRemaining / (widget.ritual['min'] * 60));
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B12),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.ritual['title'].toString().toUpperCase(), 
                 style: const TextStyle(color: Colors.white30, letterSpacing: 4, fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 60),
            // Representación visual del progreso mediante un círculo y el texto del tiempo
            Stack(
              alignment: Alignment.center,
              children: [
                Container(width: 260, height: 260, decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [BoxShadow(color: const Color(0xFF8B5CF6).withOpacity(0.15), blurRadius: 50)])),
                SizedBox(width: 250, height: 250, child: CircularProgressIndicator(value: progress, strokeWidth: 4, color: const Color(0xFF8B5CF6), backgroundColor: Colors.white10)),
                Text(_formatTime(_secondsRemaining), style: const TextStyle(color: Colors.white, fontSize: 54, fontWeight: FontWeight.w200)),
              ],
            ),
            const SizedBox(height: 80),
            _controlButton(icon: _isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded, onTap: _togglePause, color: Colors.white),
            const SizedBox(height: 40),
            Text('RECOMPENSA: ${widget.ritual['essence']} ✨', style: const TextStyle(color: Colors.amber, letterSpacing: 1)),
          ],
        ),
      ),
    );
  }

  // Botón circular para controlar el estado del cronómetro
  Widget _controlButton({required IconData icon, required VoidCallback onTap, required Color color}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.05)), child: Icon(icon, size: 32, color: color)),
    );
  }
}