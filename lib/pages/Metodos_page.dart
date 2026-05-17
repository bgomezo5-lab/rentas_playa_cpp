import 'package:flutter/material.dart';

class MetodosPage extends StatelessWidget {
  const MetodosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        title: const Text("Métodos Numéricos"),
        backgroundColor: Colors.blue[900],
      ),

      body: Center(
        child: ElevatedButton(
          onPressed: () {
            print("Secante Modificada");
          },
          child: const Text("Secante Modificada"),
        ),
      ),
    );
  }
}