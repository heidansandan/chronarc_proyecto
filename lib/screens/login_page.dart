import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/database_service.dart';
import 'shell_page.dart'; 

// Pantalla encargada de la autenticación de usuarios (Login y Registro)
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Definición de colores constantes para el tema oscuro de la interfaz
  static const _card = Color(0xFF14121B);
  static const _input = Color(0xFF0F0E15);
  static const _primary = Color(0xFF8B5CF6);

  final _userCtrl = TextEditingController();
  final _userPass = TextEditingController();
  final DatabaseService _db = DatabaseService();

  String? _error;
  bool _showPassword = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _userCtrl.dispose();
    _userPass.dispose();
    super.dispose();
  }

  // Gestiona el proceso de autenticación con Firebase
  Future<void> _handleAuth(bool isLogin) async {
    final email = _userCtrl.text.trim();
    final pass = _userPass.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      setState(() => _error = 'Campos vacíos, mago.');
      return;
    }

    setState(() { _isLoading = true; _error = null; });

    try {
      if (isLogin) {
        // Intento de inicio de sesión
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: pass);
      } else {
        // Creación de nueva cuenta
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: pass);
      }

      // Inicializa o verifica el perfil del usuario en Firestore
      await _db.setupNewUser(email);

      if (mounted) {
        // Redirige al contenedor principal de la aplicación tras el éxito
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ShellPage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _error = e.message); // Muestra errores de Firebase (ej: contraseña incorrecta)
    } catch (e) {
      setState(() => _error = "Error inesperado al conectar con el grimorio.");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [Color(0xFF0B0B12), Color(0xFF1A1026)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                children: [
                  const Icon(Icons.brightness_3, color: _primary, size: 56),
                  const SizedBox(height: 20),
                  // Logotipo con gradiente cromático
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFF9B6CFF), Color(0xFFFFC46B)],
                    ).createShader(bounds),
                    child: const Text('CHRONARC', 
                      style: TextStyle(fontSize: 50, fontWeight: FontWeight.w900, color: Colors.white)),
                  ),
                  const SizedBox(height: 30),
                  // Formulario de autenticación
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: _card.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.08)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _field(_userCtrl, 'Email', Icons.person_outline, false),
                        const SizedBox(height: 14),
                        _field(_userPass, 'Contraseña', Icons.lock_outline, true),
                        if (_error != null) ...[
                          const SizedBox(height: 14),
                          Text(_error!, style: const TextStyle(color: Colors.redAccent, fontSize: 12), textAlign: TextAlign.center),
                        ],
                        const SizedBox(height: 24),
                        if (_isLoading)
                          const Center(child: CircularProgressIndicator(color: _primary))
                        else ...[
                          ElevatedButton(
                            onPressed: () => _handleAuth(true),
                            style: ElevatedButton.styleFrom(backgroundColor: _primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), minimumSize: const Size(0, 48)),
                            child: const Text('Entrar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton(
                            onPressed: () => _handleAuth(false),
                            style: OutlinedButton.styleFrom(side: const BorderSide(color: _primary), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), minimumSize: const Size(0, 48)),
                            child: const Text('Registrarse', style: TextStyle(color: _primary)),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget auxiliar para crear campos de texto personalizados (email/password)
  Widget _field(TextEditingController ctrl, String hint, IconData icon, bool isPass) => TextField(
    controller: ctrl,
    obscureText: isPass && !_showPassword,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.white54),
      filled: true, fillColor: _input,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
      suffixIcon: isPass ? IconButton(icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _showPassword = !_showPassword)) : null,
    ),
  );
}