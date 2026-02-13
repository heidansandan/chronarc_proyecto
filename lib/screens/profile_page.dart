import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../routes/app_router.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nameCtrl = TextEditingController(text: 'Mago Errante');
  String _selectedEmoji = '🧙';
  File? _imageFile;
  
  final List<String> _magicEmojis = ['🧙', '🔮', '✨', '📜', '🌑', '🕯️', '🧪', '🐉', '🦉'];

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.transparent, // Para que se vea el fondo de la app
      body: CustomScrollView(
        slivers: [
          // Cabecera con efecto de profundidad
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.only(top: 40, bottom: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [cs.primary.withOpacity(0.15), Colors.transparent],
                ),
              ),
              child: Column(
                children: [
                  _buildAvatar(cs),
                  const SizedBox(height: 16),
                  Text(
                    _nameCtrl.text,
                    style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.2),
                  ),
                  Text(
                    "Rango: Archimaldito Nivel 1",
                    style: textTheme.bodyMedium?.copyWith(color: cs.primary.withOpacity(0.8)),
                  ),
                ],
              ),
            ),
          ),

          // Cuerpo con las tarjetas de opciones
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _sectionTitle("Identidad Arcana"),
                _buildModernTextField(context),
                
                const SizedBox(height: 30),
                _sectionTitle("Progreso en el Nexo"),
                _buildStatsGrid(context, cs),
                
                const SizedBox(height: 40),
                _buildLogoutButton(context),
                const SizedBox(height: 50),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGETS DE APOYO ---

  Widget _buildAvatar(ColorScheme cs) {
    return Center(
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: cs.primary.withOpacity(0.5), width: 2),
              boxShadow: [
                BoxShadow(color: cs.primary.withOpacity(0.2), blurRadius: 20, spreadRadius: 5),
              ],
            ),
            child: CircleAvatar(
              radius: 65,
              backgroundColor: Theme.of(context).cardColor,
              backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
              child: _imageFile == null 
                  ? Text(_selectedEmoji, style: const TextStyle(fontSize: 65)) 
                  : null,
            ),
          ),
          Positioned(
            bottom: 5,
            right: 5,
            child: GestureDetector(
              onTap: _showAvatarOptions,
              child: CircleAvatar(
                backgroundColor: cs.primary,
                radius: 18,
                child: const Icon(Icons.edit, size: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem('Nivel', '1', Icons.auto_fix_normal, cs.primary),
          _verticalDivider(),
          _statItem('Rituales', '12', Icons.cyclone, Colors.blueAccent),
          _verticalDivider(),
          _statItem('Esencia', '450', Icons.auto_awesome, Colors.amber),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, size: 24, color: color),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.white38)),
      ],
    );
  }

  Widget _verticalDivider() => Container(height: 40, width: 1, color: Colors.white10);

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white54, letterSpacing: 1.1)),
    );
  }

  Widget _buildModernTextField(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: TextField(
        controller: _nameCtrl,
        onChanged: (v) => setState(() {}),
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.edit_note, color: Colors.white38),
          hintText: "Nombre del avatar",
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildActionTile(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white60, size: 20),
        title: Text(title, style: const TextStyle(fontSize: 15)),
        trailing: const Icon(Icons.chevron_right, color: Colors.white24),
        onTap: onTap,
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return TextButton.icon(
      onPressed: () => Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (_) => false),
      style: TextButton.styleFrom(
        foregroundColor: Colors.redAccent.withOpacity(0.8),
        padding: const EdgeInsets.all(16),
      ),
      icon: const Icon(Icons.logout, size: 20),
      label: const Text('Disolver vínculo (Cerrar Sesión)'),
    );
  }

  // --- LOGICA DE SELECTORES (Igual que antes pero con estilo coherente) ---

  void _showAvatarOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.purpleAccent),
                title: const Text('Visión de Galería'),
                onTap: () { Navigator.pop(context); _pickImage(); },
              ),
              ListTile(
                leading: const Icon(Icons.auto_fix_high, color: Colors.amber),
                title: const Text('Invocar un Emoji'),
                onTap: () { Navigator.pop(context); _showEmojiPicker(); },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEmojiPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Elige tu símbolo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              children: _magicEmojis.map((e) => GestureDetector(
                onTap: () {
                  setState(() { _selectedEmoji = e; _imageFile = null; });
                  Navigator.pop(context);
                },
                child: Text(e, style: const TextStyle(fontSize: 40)),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }
}