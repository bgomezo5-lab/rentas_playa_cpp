import 'dart:convert';
import 'package:flutter/services.dart';

class ApiService {
  // Esta es la función que jose llamará desde sus botones
  static Future<List<dynamic>> extraerDatos() async {
    try {
      // Paso 1: "Consumir" el origen de datos (el archivo que dio el ing)
      final String response = await rootBundle.loadString('assets/datos.json');

      // Paso 2: "Extraer" y convertir el texto a formato de lista
      final List<dynamic> data = json.decode(response);

      return data;
    } catch (e) {
      print("Error en la extracción: $e");
      return []; // Devuelve lista vacía para no romper la UI del compañero
    }
  }
}