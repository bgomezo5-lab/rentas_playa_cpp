import 'package:flutter/material.dart';
import 'package:rentas_playa_cpp/api_service.dart';

class ProgramacionPage extends StatefulWidget {
  const ProgramacionPage({super.key});

  @override
  State<ProgramacionPage> createState() => _ProgramacionPageState();
}

class _ProgramacionPageState extends State<ProgramacionPage> {
  List<dynamic> datosJson = [];

  // Controlador para capturar lo que escribes en el teclado
  final TextEditingController _controladorTexto = TextEditingController();

  // --- CARGA INICIAL DESDE EL JSON ---
  void cargarDatos() async {
    try {
      final resultado = await ApiService.extraerDatos();
      setState(() {
      //usamos metodo addAll para unir las listas
      //esto añade lo del json al final de lo que ya contiene la api
        datosJson.addAll(resultado);
      });
      print("¡Éxito! Se cargaron ${resultado.length} elementos");
    } catch (e) {
      print("Error al cargar: $e");
    }
  }

  // --- INSERCIÓN DINÁMICA (MANIPULACIÓN) ---
  void insertarNuevoDato() {
    if (_controladorTexto.text.isNotEmpty) {
      setState(() {
        // Insertamos un nuevo "Nodo" al inicio de la lista (Complejidad O(1))
        datosJson.insert(0, {
          "userId": 1,
          "id": datosJson.length + 1,
          "title": _controladorTexto.text,
          "completed": false
        });
      });
      _controladorTexto.clear(); // Limpiar el cuadro de texto
      _mostrarAlerta("INSERCIÓN", "Nuevo nodo agregado al inicio", Colors.green);
    } else {
      _mostrarAlerta("ERROR", "Escribe algo para insertar", Colors.red);
    }
  }

  // --- LÓGICA DE PILA (LIFO: Last In, First Out) ---
  void funcionPila() {
    if (datosJson.isNotEmpty) {
      final eliminado = datosJson.last;
      setState(() {
        datosJson.removeLast();
      });
      _mostrarAlerta("PILA (POP)", "Eliminado el último: ID ${eliminado['id']}", Colors.redAccent);
    }
  }

  // --- LÓGICA DE COLA (FIFO: First In, First Out) ---
  void funcionCola() {
    if (datosJson.isNotEmpty) {
      final eliminado = datosJson.first;
      setState(() {
        datosJson.removeAt(0);
      });
      _mostrarAlerta("COLA (FIFO)", "Eliminado el primero: ID ${eliminado['id']}", Colors.orangeAccent);
    }
  }

  // --- CONCEPTO DE NODOS (Inspección) ---
  void funcionNodos() {
    if (datosJson.isNotEmpty) {
      final nodoActual = datosJson[0];
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text("Inspección de Nodo", style: TextStyle(color: Colors.white)),
          content: Text(
            "Dato del Nodo: ${nodoActual['title']}\n\n"
            "Puntero al Siguiente: ID ${datosJson.length > 1 ? datosJson[1]['id'] : 'null'}",
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cerrar")),
          ],
        ),
      );
    }
  }

  void _mostrarAlerta(String titulo, String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$titulo: $msg"), backgroundColor: color, duration: const Duration(seconds: 1)),
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
            // --- NUEVA SECCIÓN: ENTRADA DE DATOS ---
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
                  onPressed: insertarNuevoDato, // Inserta lo que escribas
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Botón de Carga masiva (API)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                onPressed: cargarDatos,
                child: const Text("Cargar Datos del JSON", style: TextStyle(color: Colors.white)),
              ),
            ),

            const SizedBox(height: 15),
            const Divider(color: Colors.white24),

            // LISTA DE DATOS
            Expanded(
              child: datosJson.isEmpty
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

            // BOTONES DE OPERACIÓN
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

  Widget _botonAccion(String texto, VoidCallback accion, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white),
      onPressed: accion,
      child: Text(texto),
    );
  }
}