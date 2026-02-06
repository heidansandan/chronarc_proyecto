import 'package:flutter/material.dart';
import '../../routes/app_router.dart'; 

class LoginPage extends StatefulWidget {
  final VoidCallback? onLogin;
  final String? successRouteName;

  const LoginPage({super.key, this.onLogin, this.successRouteName});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const _card = Color(0xFF14121B);
  static const _input = Color(0xFF0F0E15);
  static const _primary = Color(0xFF8B5CF6);

  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  String? _error;
  bool _showPassword = false;

  @override
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _login() {
    final u = _userCtrl.text.trim();
    final p = _passCtrl.text.trim();

    if (u == 'usuario' && p == 'usuario') {
      setState(() => _error = null);

      if (widget.onLogin != null) {
        widget.onLogin!();
        return;
      }

      final route = widget.successRouteName ?? AppRoutes.shell;
      Navigator.pushNamedAndRemoveUntil(context, route, (_) => false);
      return;
    }

    setState(() => _error = 'Usuario o contraseña incorrectos');
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: color),
      );

  @override
  Widget build(BuildContext context) {
    final errorColor = Theme.of(context).colorScheme.error;

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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.brightness_3, color: _primary, size: 56),
                  const SizedBox(height: 20),
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
                  Text(
                    'Gestiona tu productividad con magia',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.65),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: _card.withOpacity(0.90),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.08)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Usuario',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.65),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _userCtrl,
                          onChanged: (_) => setState(() => _error = null),
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Ingresa tu usuario',
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.45),
                            ),
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: Colors.white.withOpacity(0.55),
                            ),
                            filled: true,
                            fillColor: _input.withOpacity(0.65),
                            enabledBorder: _border(Colors.white.withOpacity(0.10)),
                            focusedBorder: _border(_primary.withOpacity(0.55)),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Contraseña',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.65),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _passCtrl,
                          obscureText: !_showPassword,
                          onChanged: (_) => setState(() => _error = null),
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Ingresa tu contraseña',
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.45),
                            ),
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: Colors.white.withOpacity(0.55),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () => setState(
                                () => _showPassword = !_showPassword,
                              ),
                              icon: Icon(
                                _showPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.white.withOpacity(0.55),
                              ),
                            ),
                            filled: true,
                            fillColor: _input.withOpacity(0.65),
                            enabledBorder: _border(Colors.white.withOpacity(0.10)),
                            focusedBorder: _border(_primary.withOpacity(0.55)),
                          ),
                        ),
                        const SizedBox(height: 14),
                        if (_error != null) ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: errorColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: errorColor.withOpacity(0.25),
                              ),
                            ),
                            child: Text(
                              _error!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: errorColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                        SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text(
                              'Entrar',
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 48,
                          child: OutlinedButton(
                            onPressed: null,
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: _primary.withOpacity(0.6)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text(
                              'Registrarse',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: _primary,
                              ),
                            ),
                          ),
                        ),
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
}