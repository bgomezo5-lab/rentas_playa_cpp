import 'package:flutter/material.dart';

import 'pages/programacion_page.dart';
import 'pages/estadistica_page.dart';
import 'pages/metodos_page.dart';
import 'pages/emprendedores_page.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        title: const Text("Menú Principal"),
        backgroundColor: Colors.blue[900],
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const Text(
                "¡Bienvenido al Sistema!",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 30),

              // Programación III
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        const ProgramacionPage(),
                      ),
                    );
                  },

                  child: const Text("Programación III"),
                ),
              ),

              const SizedBox(height: 15),

              // Estadística II
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        const EstadisticaPage(),
                      ),
                    );
                  },

                  child: const Text("Estadística II"),
                ),
              ),

              const SizedBox(height: 15),

              // Métodos Numéricos
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        const MetodosPage(),
                      ),
                    );
                  },

                  child: const Text("Métodos Numéricos"),
                ),
              ),

              const SizedBox(height: 15),

              // Emprendedores
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        const EmprendedoresPage(),
                      ),
                    );
                  },

                  child: const Text(
                    "Emprendedores de Negocios",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () => Navigator.pop(context),

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),

                child: const Text("Cerrar Sesión"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}