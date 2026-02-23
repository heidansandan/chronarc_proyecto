import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/database_service.dart';

// Pantalla que muestra el perfil detallado del usuario y permite personalización básica
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // Despliega un panel inferior para seleccionar un nuevo avatar (emoji)
  void _showEmojiPicker(BuildContext context, DatabaseService db) {
    final emojis = ['🧙', '🧛', '🧝', '🌑', '🔮', '🔥', '🐉', '💀', '🧿', '✨'];
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF14121B),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5, mainAxisSpacing: 10, crossAxisSpacing: 10),
          itemCount: emojis.length,
          itemBuilder: (context, i) => InkWell(
            onTap: () {
              db.updateAvatar(emojis[i]); // Actualiza en la base de datos
              Navigator.pop(context);
            },
            child: Center(
                child: Text(emojis[i], style: const TextStyle(fontSize: 35))),
          ),
        ),
      ),
    );
  }

  // Muestra un diálogo emergente para renombrar al usuario en Firestore
  void _editUsername(BuildContext context, String currentName) {
    final TextEditingController controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF14121B),
        title: const Text("CAMBIAR NOMBRE", style: TextStyle(color: Colors.white, fontSize: 14, letterSpacing: 2)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white.withOpacity(0.1))),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCELAR")),
          TextButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser?.email)
                    .update({'username': controller.text});
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text("GUARDAR", style: TextStyle(color: Color(0xFF8B5CF6))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseService db = DatabaseService();
    final user = FirebaseAuth.instance.currentUser;

    // Escucha cambios en los datos del jugador para actualizar la UI automáticamente
    return StreamBuilder<DocumentSnapshot>(
      stream: db.getPlayerStats(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF8B5CF6)));
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final String username = data['username'] ?? user?.email?.split('@')[0].toUpperCase() ?? "MAGO";
        final String email = user?.email ?? "";
        final String avatar = data['avatar'] ?? '🧙';
        final int xp = data['xp'] ?? 0;

        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 20),
            // Sección del Avatar e Identidad del Mago
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => _showEmojiPicker(context, db),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.03),
                        border: Border.all(color: Colors.white.withOpacity(0.05))
                      ),
                      child: Text(avatar, style: const TextStyle(fontSize: 50)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => _editUsername(context, username),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(username, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1)),
                        const SizedBox(width: 8),
                        const Icon(Icons.edit, size: 14, color: Colors.white24),
                      ],
                    ),
                  ),
                  Text(email.toLowerCase(), style: const TextStyle(color: Colors.white38, fontSize: 12)),
                ],
              ),
            ),
            
            const SizedBox(height: 40),

            // Visualización del progreso de XP (Progreso Arcano)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("PROGRESO ARCANO", style: TextStyle(color: Colors.white38, fontSize: 10, letterSpacing: 1)),
                    Text("${xp % 100}/100 XP", style: const TextStyle(color: Color(0xFF8B5CF6), fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 8, 
                    width: double.infinity,
                    color: Colors.white.withOpacity(0.05),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: (xp % 100) / 100,
                      child: Container(color: const Color(0xFF8B5CF6)),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Cuadrícula de estadísticas secundarias (Nivel, Esencia, Colección)
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1,
              children: [
                _statCard("NIVEL", "${data['level'] ?? 1}", const Color(0xFF8B5CF6)),
                _statCard("ESENCIA", "${data['essence'] ?? 0}", Colors.amber),
                _statCard("CARTAS", "${(data['unlockedCards'] as List).length}", Colors.cyan),
              ],
            ),

            const SizedBox(height: 50),

            // Botón para finalizar la sesión actual
            SizedBox(
              height: 55,
              child: OutlinedButton.icon(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                  }
                },
                icon: const Icon(Icons.logout, color: Colors.redAccent),
                label: const Text('CERRAR SESIÓN', style: TextStyle(color: Colors.redAccent, letterSpacing: 2)),
                style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.redAccent, width: 0.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
              ),
            ),
          ],
        );
      },
    );
  }

  // Genera una tarjeta visual para mostrar una estadística individual
  Widget _statCard(String label, String value, Color color) {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xFF14121B),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.05))
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(label, style: const TextStyle(fontSize: 9, color: Colors.white38, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
      ]),
    );
  }
}