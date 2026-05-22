import 'package:flutter/material.dart';
import '../emprendedores_page.dart';
import '../Estadistica_page.dart';
import '../Metodos_page.dart';
import '../Programacion_page.dart';

class PanelBotonesCursos extends StatelessWidget {
  const PanelBotonesCursos({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _crearBoton(
          context,
          'Programación II',
          'assets/images/progra.jpeg',
          const ProgramacionPage(),
        ),
        _crearBoton(
          context,
          'Estadística II',
          'assets/images/estadistica.jpeg',
          const EstadisticaPage(),
        ),
        _crearBoton(
          context,
          'Métodos Numéricos',
          'assets/images/metodos.jpeg',
          const MetodosPage(),
        ),
        _crearBoton(
          context,
          'Emprendedores de Negocios',
          'assets/images/emprendedores.jpeg',
          const EmprendedoresPage(),
        ),
      ],
    );
  }

  Widget _crearBoton(BuildContext context, String titulo, String rutaImagen, Widget paginaDestino) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => paginaDestino),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E2C),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset(
                  rutaImagen,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.menu_book_rounded,
                      size: 45,
                      color: Colors.blueAccent,
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0, left: 8.0, right: 8.0),
              child: Text(
                titulo,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
