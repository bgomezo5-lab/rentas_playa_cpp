import 'package:flutter/material.dart';
import 'menu_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_person, size: 100, color: Colors.blue[800]),
              const SizedBox(height: 20),

              const Text(
                "Iniciar Sesión",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 30),

              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: "Usuario",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    String username = _usernameController.text;
                    String password = _passwordController.text;

                    if (username == "admin" && password == "admin123") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MenuPage(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Usuario o contraseña incorrectos"),
                        ),
                      );
                    }
                  },
                  child: const Text("Iniciar Sesión"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}