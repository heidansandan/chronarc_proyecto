import 'package:flutter/material.dart';

class CreditsPage extends StatelessWidget {
  const CreditsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Créditos')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Chronarc\n\nApp de foco/estudio basada en rituales y cartas.\n\nÁlvaro Rodríguez\n2 DAM',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}