import 'dart:convert';
import 'package:http/http.dart' as http;

// Servicio encargado de conectar con la API de OpenWeather para obtener datos climáticos
class WeatherService {
  // Clave de API para el acceso al servicio
  final String apiKey = '98f9c26c78b9976c482d5ebbab9e707c';
  // Ciudad por defecto para las consultas climáticas
  final String city = 'Madrid'; 

  // Realiza una petición GET para obtener el clima actual en formato JSON
  Future<Map<String, dynamic>?> getCurrentWeather() async {
    try {
      // Construcción de la URL con parámetros de ciudad, clave, unidades métricas e idioma
      final url = 'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric&lang=es';
      
      final response = await http.get(Uri.parse(url));
      // Verifica si la respuesta del servidor es exitosa (código 200)
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      return null; // En caso de error de red o de parseo, retorna null
    }
  }
}