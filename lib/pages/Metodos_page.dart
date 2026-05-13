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

      body: const Center(
        child: Text(
          "Bienvenido a Métodos Numéricos",
          style: TextStyle(
            fontSize: 22,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}