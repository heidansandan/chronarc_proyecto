import 'package:flutter/material.dart';

class CodexPage extends StatelessWidget {
  const CodexPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = List.generate(9, (i) => i < 3 ? 'Carta ${i + 1}' : '???');

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.7,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final locked = items[i] == '???';
        return Card(
          child: Center(
            child: Text(
              items[i],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: locked ? Colors.white38 : Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}