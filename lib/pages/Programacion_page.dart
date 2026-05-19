import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProgramacionPage extends StatefulWidget {
  const ProgramacionPage({super.key});

  @override
  State<ProgramacionPage> createState() => _ProgramacionPageState();
}

class _ProgramacionPageState extends State<ProgramacionPage> {
  // Lista dinámica que funcionará como nuestra estructura de datos (Pila/Cola)
  List<dynamic> datosJson = [];

  // Controlador para capturar lo que escribes en el cuadro de texto
  final TextEditingController _controladorTexto = TextEditingController();

  // Variable boalana para controlar el estado de carga visual (UX)
  bool cargando = true;

  // --- CARGA INICIAL (Se ejecuta automáticamente al abrir la pantalla) ---
  @override
  void initState() {
    super.initState();
    cargarDatosDesdeWeb();
  }

  // --- FUNCIÓN ASÍNCRONA PARA CONECTAR CON LA API WEB ---
  Future<void> cargarDatosDesdeWeb() async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/todos');

    try {
      // Hacemos la petición HTTP GET a internet
      final respuesta = await http.get(url);

      // El código HTTP 200 significa que el servidor web respondió con éxito
      if (respuesta.statusCode == 200) {
        // Decodificamos el JSON puro de la web y lo transformamos en una Lista de Dart
        final List<dynamic> datosWeb = jsonDecode(respuesta.body);

        setState(() {
          datosJson.clear();          // Limpiamos cualquier dato previo
          datosJson.addAll(datosWeb); // Guardamos los 200 registros de la API web
          cargando = false;           // Apagamos la animación de carga
        });
        print("¡Éxito! Se cargaron ${datosWeb.length} elementos desde la API web");
      } else {
        setState(() => cargando = false);
        print("Error en el servidor: ${respuesta.statusCode}");
      }
    } catch (e) {
      setState(() => cargando = false);
      print("Error de red (revisa tu conexión a internet): $e");
    }
  }

  // --- INSERCIÓN DINÁMICA (Estructuras de Datos: Insertar en la Cabeza) ---
  void insertarNuevoDato() {
    if (_controladorTexto.text.isNotEmpty) {
      setState(() {
        // Insertamos un nuevo "Nodo" al inicio de la lista (Complejidad O(1))
        datosJson.insert(0, {
          "userId": 1,
          "id": datosJson.isEmpty ? 1 : datosJson.map((e) => e['id'] as int).reduce((a, b) => a > b ? a : b) + 1,
          "title": _controladorTexto.text,
          "completed": false
        });
      });
      _controladorTexto.clear(); // Limpiar el cuadro de texto
      _mostrarAlerta("INSERCIÓN", "Nuevo nodo agregado al inicio (Cabeza)", Colors.green);
    } else {
      _mostrarAlerta("ERROR", "Escribe algo para poder insertar", Colors.red);
    }
  }

  // --- LÓGICA DE PILA (LIFO: Last In, First Out) ---
  void funcionPila() {
    if (datosJson.isNotEmpty) {
      final eliminado = datosJson.last;
      setState(() {
        datosJson.removeLast(); // Elimina el último elemento que entró
      });
      _mostrarAlerta("PILA (POP)", "Eliminado el último elemento de la pila: ID ${eliminado['id']}", Colors.redAccent);
    } else {
      _mostrarAlerta("AVISO", "La estructura (Pila) está vacía", Colors.orange);
    }
  }

  // --- LÓGICA DE COLA (FIFO: First In, First Out) ---
  void funcionCola() {
    if (datosJson.isNotEmpty) {
      final eliminado = datosJson.first;
      setState(() {
        datosJson.removeAt(0); // Elimina el primer elemento de la lista (el más antiguo)
      });
      _mostrarAlerta("COLA (DEQUEUE)", "Eliminado el primer elemento de la cola: ID ${eliminado['id']}", Colors.orangeAccent);
    } else {
      _mostrarAlerta("AVISO", "La estructura (Cola) está vacía", Colors.orange);
    }
  }

  // --- CONCEPTO DE NODOS (Inspección de Punteros) ---
  void funcionNodos() {
    if (datosJson.isNotEmpty) {
      final nodoActual = datosJson[0];
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text("Inspección de Nodo (CABEZA)", style: TextStyle(color: Colors.white)),
          content: Text(
            "Dato del Nodo Actual: ${nodoActual['title']}\n\n"
                "Puntero al Siguiente Nodo: ID ${datosJson.length > 1 ? datosJson[1]['id'] : 'null'}",
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cerrar", style: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
      );
    } else {
      _mostrarAlerta("AVISO", "No hay nodos en memoria para inspeccionar", Colors.orange);
    }
  }

  // Utilidad para mostrar notificaciones rápidas en pantalla
  void _mostrarAlerta(String titulo, String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$titulo: $msg"),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Estructuras de Datos Dinámicas"),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // --- ENTRADA DE DATOS (TEXTFIELD) ---
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controladorTexto,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Ingresar nuevo título...",
                      hintStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue[900]!)),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.green, size: 40),
                  onPressed: insertarNuevoDato,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Botón para refrescar datos manualmente desde la API Web
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                onPressed: () {
                  setState(() => cargando = true);
                  cargarDatosDesdeWeb();
                },
                icon: const Icon(Icons.refresh, color: Colors.white),
                label: const Text("Refrescar desde API Web", style: TextStyle(color: Colors.white)),
              ),
            ),

            const SizedBox(height: 15),
            const Divider(color: Colors.white24),

            // --- RENDERIZADO DE LA ESTRUCTURA EN TIEMPO REAL ---
            Expanded(
              child: cargando
                  ? const Center(child: CircularProgressIndicator(color: Colors.blue))
                  : datosJson.isEmpty
                  ? const Center(child: Text("Memoria vacía", style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                itemCount: datosJson.length,
                itemBuilder: (context, index) {
                  final item = datosJson[index];
                  return Card(
                    color: Colors.grey[900],
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue[900],
                        child: Text("${index + 1}", style: const TextStyle(color: Colors.white, fontSize: 10)),
                      ),
                      title: Text("${item['title']}",
                          style: const TextStyle(color: Colors.white, fontSize: 13)),
                      subtitle: Text("ID: ${item['id']}",
                          style: const TextStyle(color: Colors.white60, fontSize: 11)),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 15),

            // --- BOTONES DE CONTROL DE OPERACIONES ---
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _botonAccion("Pilas", funcionPila, Colors.red[700]!),
                  const SizedBox(width: 10),
                  _botonAccion("Colas", funcionCola, Colors.orange[800]!),
                  const SizedBox(width: 10),
                  _botonAccion("Nodos", funcionNodos, Colors.teal[700]!),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // Constructor de botones de operación personalizado
  Widget _botonAccion(String texto, VoidCallback accion, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white),
      onPressed: accion,
      child: Text(texto),
    );
  }
}