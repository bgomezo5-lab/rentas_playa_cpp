import 'package:flutter/material.dart';

class ProgramacionPage extends StatelessWidget {
  const ProgramacionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        title: const Text("Programación III"),
        backgroundColor: Colors.blue[900],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // Consumir API
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Consumir API"),
                    ),
                  );
                },

                child: const Text("Consumir API"),
              ),
            ),

            const SizedBox(height: 15),

            // Mostrar datos
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Mostrar datos"),
                    ),
                  );
                },

                child: const Text("Mostrar datos"),
              ),
            ),

            const SizedBox(height: 15),

            // Pilas
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Pilas"),
                    ),
                  );
                },

                child: const Text("Pilas"),
              ),
            ),

            const SizedBox(height: 15),

            // Colas
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Colas"),
                    ),
                  );
                },

                child: const Text("Colas"),
              ),
            ),

            const SizedBox(height: 15),

            // Árbol Binario
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Árbol Binario"),
                    ),
                  );
                },

                child: const Text("Árbol Binario"),
              ),
            ),

            const SizedBox(height: 15),

            // Nodos
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Nodos"),
                    ),
                  );
                },

                child: const Text("Nodos"),
              ),
            ),

            const SizedBox(height: 15),

            // CRUD
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("CRUD"),
                    ),
                  );
                },

                child: const Text("CRUD"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}