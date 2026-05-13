import 'package:flutter/material.dart';

class EstadisticaPage extends StatelessWidget {
  const EstadisticaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        title: const Text("Estadística II"),
        backgroundColor: Colors.blue[900],
      ),

      body: const Center(
        child: Text(
          "Bienvenido a Estadística II",
          style: TextStyle(
            fontSize: 22,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}