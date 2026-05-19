// REEMPLAZO COMPLETO PARA api_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  // Función estática para que cualquier página pueda traer datos de internet
  static Future<List<dynamic>> extraerDatosDesdeWeb() async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/todos');

    try {
      final respuesta = await http.get(url);

      if (respuesta.statusCode == 200) {
        // Si todo sale bien, devolvemos la lista decodificada
        return jsonDecode(respuesta.body) as List<dynamic>;
      } else {
        throw Exception("Error en el servidor: ${respuesta.statusCode}");
      }
    } catch (e) {
      throw Exception("Error de red: $e");
    }
  }
}