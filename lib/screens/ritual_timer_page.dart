import 'dart:async';
import 'package:flutter/material.dart';
import 'home_page.dart';

class RitualTimerPage extends StatefulWidget {
  final RitualItem ritual;
  const RitualTimerPage({super.key, required this.ritual});

  @override
  State<RitualTimerPage> createState() => _RitualTimerPageState();
}

class _RitualTimerPageState extends State<RitualTimerPage> {
  Timer? _timer;
  late int _total;
  late int _remaining;
  bool _running = false;

  @override
  void initState() {
    super.initState();
    _total = widget.ritual.minutes * 60;
    _remaining = _total;
    _start();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _start() {
    _timer?.cancel();
    setState(() => _running = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_remaining <= 0) {
        _timer?.cancel();
        setState(() => _running = false);
        _finish();
      } else {
        setState(() => _remaining -= 1);
      }
    });
  }

  void _pause() {
    _timer?.cancel();
    setState(() => _running = false);
  }

  void _finish() {
    Navigator.pop(context, true); // completado
  }

  void _cancel() {
    Navigator.pop(context, false); // no completado
  }

  String _fmt(int s) {
    final m = (s ~/ 60).toString().padLeft(2, '0');
    final sec = (s % 60).toString().padLeft(2, '0');
    return '$m:$sec';
  }

  @override
  Widget build(BuildContext context) {
    final progress = 1 - (_remaining / _total);
    return Scaffold(
      appBar: AppBar(title: Text(widget.ritual.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 18),
            Text(_fmt(_remaining), style: const TextStyle(fontSize: 56, fontWeight: FontWeight.w900)),
            const SizedBox(height: 18),
            SizedBox(
              height: 220,
              width: 220,
              child: CircularProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                strokeWidth: 12,
              ),
            ),
            const SizedBox(height: 14),
            Text(_running ? 'En progreso…' : 'Pausado', style: const TextStyle(color: Colors.white70)),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: _running ? _pause : _start,
                    child: Text(_running ? 'Pausar' : 'Reanudar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _cancel,
                    child: const Text('Cancelar'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}