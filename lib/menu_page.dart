import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Menú Principal"),
        backgroundColor: Colors.blue[900],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("¡Bienvenido al Sistema!", style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context), // Regresa al Login
              child: Text("Cerrar Sesión"),
            ),
          ],
        ),
      ),
    );
  }
}
