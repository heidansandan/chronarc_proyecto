import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Clase encargada de gestionar todas las interacciones con Cloud Firestore
class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Crea un documento de perfil para nuevos usuarios con valores por defecto
  Future<void> setupNewUser(String email) async {
    try {
      final userDoc = _db.collection('users').doc(email);
      final doc = await userDoc.get();

      // Solo crea el documento si no existe previamente
      if (!doc.exists) {
        await userDoc.set({
          'email': email,
          'essence': 100,
          'xp': 0,
          'level': 1,
          'avatar': '🧙',
          'unlockedCards': [],
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print("Error en setupNewUser: $e");
    }
  }

  // Proporciona un flujo de datos en tiempo real con las estadísticas del usuario logueado
  Stream<DocumentSnapshot> getPlayerStats() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();
    return _db.collection('users').doc(user.email).snapshots();
  }

  // --- LÓGICA DE XP Y RECOMPENSAS ---
  // Incrementa la esencia y el XP del usuario, gestionando también la subida de nivel
  Future<void> addRitualRewards(int essenceGained, int xpGained) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final userDoc = _db.collection('users').doc(user.email);

    // Se usa una transacción para asegurar la integridad de los datos (lectura y escritura atómica)
    await _db.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(userDoc);
      if (!snapshot.exists) return;

      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      
      int currentXp = data['xp'] ?? 0;
      int newXp = currentXp + xpGained;
      
      // Lógica de progresión: se sube un nivel por cada 100 puntos de XP acumulados
      int newLevel = (newXp ~/ 100) + 1;

      transaction.update(userDoc, {
        'essence': FieldValue.increment(essenceGained),
        'xp': newXp,
        'level': newLevel,
      });
    });
  }

  // --- MÉTODOS DE APOYO PARA OTRAS PANTALLAS ---
  // Cambia el emoji del avatar del usuario
  Future<void> updateAvatar(String newEmoji) async {
    final user = _auth.currentUser;
    if (user == null) return;
    await _db.collection('users').doc(user.email).update({'avatar': newEmoji});
  }

  // Añade una carta nueva a la colección del usuario sin duplicar
  Future<void> unlockCard(String cardName) async {
    final user = _auth.currentUser;
    if (user == null) return;
    await _db.collection('users').doc(user.email).update({
      'unlockedCards': FieldValue.arrayUnion([cardName])
    });
  }

  // Resta una cantidad específica de esencia (útil para compras o desbloqueos)
  Future<void> spendEssence(int amount) async {
    final user = _auth.currentUser;
    if (user == null) return;
    await _db.collection('users').doc(user.email).update({
      'essence': FieldValue.increment(-amount)
    });
  }
}