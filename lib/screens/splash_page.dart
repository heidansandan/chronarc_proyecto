import 'package:flutter/material.dart';
import '../screens/login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late final Future<void> _waitFuture;

  @override
  void initState() {
    super.initState();
    _waitFuture = Future.delayed(const Duration(seconds: 3));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _waitFuture,
      builder: (context, snapshot) {
        // Mientras no termine, mostramos la pantalla de carga
        if (snapshot.connectionState != ConnectionState.done) {
          return const _SplashView();
        }
        // Cuando termine, mostramos Login directamente (sin navegación)
        return const LoginPage();
      },
    );
  }
}

class _SplashView extends StatelessWidget {
  const _SplashView();

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0B0B12),
              Color(0xFF1A1026),
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 42, 30, 68).withOpacity(0.12),
                        blurRadius: 80,
                        spreadRadius: 6,
                      ),
                      BoxShadow(
                        color: const Color(0xFF9B6CFF).withOpacity(0.12),
                        blurRadius: 60,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 110,
                      height: 110,
                      child: Image.asset(
                        'assets/icons/arcane.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

                // TEXTO CON GRADIENTE HORIZONTAL
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFF9B6CFF),
                      Color(0xFFFFC46B),
                    ],
                  ).createShader(bounds),
                  child: const Text(
                    'CHRONARC',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 6),
                const Text(
                  'Preparando tu run…',
                  style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 0.702),
                  ),
                ),
                const SizedBox(height: 50),

                // BARRA DE CARGA
                SizedBox(
                  width: 220,
                  height: 10,
                  child: Transform.scale(
                    scaleY: 0.6,
                    child: LinearProgressIndicator(
                      backgroundColor: const Color.fromRGBO(60, 14, 81, 0.12),
                      color: const Color(0xFF7B3FE4),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}