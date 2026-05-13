import 'package:flutter/material.dart';

class EmprendedoresPage extends StatelessWidget {
  const EmprendedoresPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        title: const Text("Emprendedores de Negocios"),
        backgroundColor: Colors.blue[900],
      ),

      body: const Center(
        child: Text(
          "Bienvenido a Emprendedores de Negocios",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}