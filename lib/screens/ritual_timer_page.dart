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
  late int _remaining;
  bool _running = false;

  @override
  void initState() {
    super.initState();
    _remaining = widget.ritual.minutes * 60;
    _start();
  }

  void _start() {
    setState(() => _running = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remaining > 0) {
        setState(() => _remaining--);
      } else {
        _timer?.cancel();
        Navigator.pop(context, true);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _fmt(int s) => '${(s ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    
    return Scaffold(
      appBar: AppBar(title: const Text('RITUAL')),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [cs.primary.withOpacity(0.1), Colors.transparent],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.ritual.title.toUpperCase(), style: const TextStyle(letterSpacing: 3, color: Colors.white54)),
            const SizedBox(height: 50),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 250, width: 250,
                  child: CircularProgressIndicator(
                    value: 1 - (_remaining / (widget.ritual.minutes * 60)),
                    strokeWidth: 8,
                    strokeCap: StrokeCap.round,
                    backgroundColor: Colors.white10,
                  ),
                ),
                Text(_fmt(_remaining), style: const TextStyle(fontSize: 60, fontWeight: FontWeight.w200)),
              ],
            ),
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.filledTonal(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  padding: const EdgeInsets.all(15),
                ),
                const SizedBox(width: 20),
                IconButton.filled(
                  onPressed: () => setState(() => _running ? _timer?.cancel() : _start()),
                  icon: Icon(_running ? Icons.pause : Icons.play_arrow),
                  padding: const EdgeInsets.all(20),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}