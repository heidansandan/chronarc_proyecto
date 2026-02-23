import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/weather_service.dart';
import '../services/database_service.dart';
import 'ritual_timer_page.dart';

// Pantalla principal que muestra el progreso del usuario y los rituales disponibles
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WeatherService _weatherService = WeatherService();
  final DatabaseService _db = DatabaseService();
  Map<String, dynamic>? _weatherData;
  bool _isLoadingWeather = true;

  @override
  void initState() {
    super.initState();
    _fetchWeather(); // Carga inicial de los datos climáticos
  }

  // Obtiene los datos del clima actual mediante el servicio de OpenWeather
  Future<void> _fetchWeather() async {
    setState(() => _isLoadingWeather = true);
    final data = await _weatherService.getCurrentWeather();
    if (mounted) {
      setState(() {
        _weatherData = data;
        _isLoadingWeather = false;
      });
    }
  }

  // Determina qué ritual especial mostrar basado en el estado del tiempo
  Map<String, dynamic> _getClimaticRitual() {
    if (_weatherData == null) {
      return {
        'title': 'Meditación de Vacío',
        'min': 10,
        'essence': 5,
        'emoji': '🧘',
        'desc': 'Conecta con tu interior mientras el cielo se revela.'
      };
    }
    final main = _weatherData!['weather'][0]['main'].toString().toLowerCase();
    
    // Lógica para asignar rituales específicos según el clima (lluvia vs sol)
    if (main.contains('rain')) {
      return {
        'title': 'Sinfonía de Agua',
        'min': 20,
        'essence': 20,
        'xp': 40, 
        'emoji': '🌧️',
        'desc': 'Lectura y calma bajo la lluvia.'
      };
    }
    return {
      'title': 'Paseo de Helios',
      'min': 15,
      'essence': 15,
      'xp': 30, 
      'emoji': '☀️',
      'desc': 'Absorbe la luz del sol directamente.'
    };
  }

  @override
  Widget build(BuildContext context) {
    final climatic = _getClimaticRitual();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RefreshIndicator(
        color: const Color(0xFF8B5CF6),
        onRefresh: _fetchWeather, // Permite actualizar el clima deslizando hacia abajo
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const SizedBox(height: 50),
            
            // Muestra las estadísticas del jugador en tiempo real desde Firestore
            StreamBuilder<DocumentSnapshot>(
              stream: _db.getPlayerStats(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return _buildStatBar(0, 0, 1);
                }
                final data = snapshot.data!.data() as Map<String, dynamic>;
                return _buildStatBar(
                  data['essence'] ?? 0, 
                  data['xp'] ?? 0,
                  data['level'] ?? 1
                );
              },
            ),

            const SizedBox(height: 30),
            _buildWeatherHeader(), // Indicador visual del clima actual
            const SizedBox(height: 30),

            _sectionLabel("RITUALES GENERALES"),
            const SizedBox(height: 15),
            _ritualCard("Enfoque Arcano", 25, 12, 50, const Color(0xFF8B5CF6), Icons.timer_outlined),
            const SizedBox(height: 12),
            _ritualCard("Gran Ritual", 50, 25, 100, const Color(0xFF6366F1), Icons.auto_awesome),

            const SizedBox(height: 35),
            _sectionLabel("RITUAL DEL CLIMA"),
            const SizedBox(height: 15),
            _specialClimaticCard(climatic), // Tarjeta destacada con el ritual dinámico
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  // Construye la barra superior con nivel, progreso de XP y esencia acumulada
  Widget _buildStatBar(int essence, int totalXp, int level) {
    double progress = (totalXp % 100) / 100;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF14121B),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("NIVEL $level", style: const TextStyle(color: Color(0xFF8B5CF6), fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 1)),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    height: 6, width: 80,
                    decoration: BoxDecoration(color: const Color(0xFF8B5CF6).withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: progress.clamp(0.01, 1.0),
                      child: Container(decoration: BoxDecoration(color: const Color(0xFF8B5CF6), borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text("${totalXp % 100}/100 XP", style: const TextStyle(color: Colors.white24, fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          Row(
            children: [
              const Text("✨", style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text("$essence", style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
            ],
          ),
        ],
      ),
    );
  }

  // Muestra la ubicación y temperatura actual obtenida de la API
  Widget _buildWeatherHeader() {
    if (_isLoadingWeather) return const Center(child: SizedBox(width: 30, child: LinearProgressIndicator(color: Color(0xFF8B5CF6), backgroundColor: Colors.transparent)));
    final temp = _weatherData?['main']['temp']?.round() ?? '--';
    final desc = _weatherData?['weather'][0]['description'] ?? '';
    return Center(
      child: Text("MADRID  •  $temp°C  •  ${desc.toUpperCase()}", style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
    );
  }

  // Componente para los rituales estándar de la lista
  Widget _ritualCard(String title, int min, int essence, int xp, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF14121B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text("$min MIN", style: const TextStyle(color: Colors.white38, fontSize: 11)),
                    const SizedBox(width: 8),
                    Text("+$essence ✨", style: const TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    Text("+$xp XP", style: const TextStyle(color: Color(0xFF8B5CF6), fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => RitualTimerPage(ritual: {'title': title, 'min': min, 'essence': essence})));
            },
            style: ElevatedButton.styleFrom(backgroundColor: color.withOpacity(0.1), foregroundColor: color, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text("INICIAR", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
          ),
        ],
      ),
    );
  }

  // Tarjeta especial que cambia su contenido y recompensas según el clima
  Widget _specialClimaticCard(Map<String, dynamic> ritual) {
    final int xp = (ritual['min'] as int) * 2; 

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF1A1026), Color(0xFF14121B)]),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF8B5CF6).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(ritual['emoji'], style: const TextStyle(fontSize: 32)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("${ritual['min']} MIN", style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text("+${ritual['essence']} ✨", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.w900, fontSize: 12)),
                      const SizedBox(width: 10),
                      Text("+$xp XP", style: const TextStyle(color: Color(0xFF8B5CF6), fontWeight: FontWeight.w900, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(ritual['title'], style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(ritual['desc'], style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 13)),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => RitualTimerPage(ritual: ritual)));
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B5CF6), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text("INICIAR RITUAL ELEMENTAL", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
            ),
          ),
        ],
      ),
    );
  }

  // Etiqueta decorativa para las secciones de la página
  Widget _sectionLabel(String text) => Text(text, style: const TextStyle(color: Colors.white30, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2));
}