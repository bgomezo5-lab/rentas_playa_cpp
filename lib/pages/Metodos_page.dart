import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:expressions/expressions.dart';
import 'package:fl_chart/fl_chart.dart'; // Importamos la librería de gráficas

class MetodosPage extends StatefulWidget {
  const MetodosPage({super.key});

  @override
  State<MetodosPage> createState() => _MetodosPageState();
}


class _MetodosPageState extends State<MetodosPage> {
  final _controladorEcuacion = TextEditingController(text: "x^2 - 5");
  final _controladorX0 = TextEditingController(text: "2.0");
  final _controladorDelta = TextEditingController(text: "0.01");
  final _controladorTol = TextEditingController(text: "0.0001");
  final _controladorMaxIter = TextEditingController(text: "20");

  List<Map<String, dynamic>> _historialIteraciones = [];
  List<FlSpot> _puntosGrafica = []; // Lista de puntos (x, y) para dibujar la curva
  double _raizEncontrada = 0.0;
  String _resultadoRaiz = "";
  bool _calculado = false;

  // Evaluador matemático
  double _evaluarFuncionDinamica(String ecuacionTexto, double valorX) {
    try {
      String formateada = ecuacionTexto.replaceAll('x^2', '(x*x)');
      formateada = formateada.replaceAll('x^3', '(x*x*x)');

      final expression = Expression.parse(formateada);
      final contexto = {'x': valorX, 'e': math.e, 'pi': math.pi};
      const evaluator = ExpressionEvaluator();
      final resultado = evaluator.eval(expression, contexto);

      return (resultado as num).toDouble();
    } catch (e) {
      return double.nan;
    }
  }

  // Generador de puntos para la gráfica alrededor de la raíz
  void _generarPuntosGrafica(String ecuacion, double centroX) {
    List<FlSpot> puntos = [];
    // Graficamos un rango cercano a la raíz (ej: centroX - 2 a centroX + 2)
    double inicio = centroX - 2.5;
    double fin = centroX + 2.5;
    double paso = 0.1;

    for (double x = inicio; x <= fin; x += paso) {
      double y = _evaluarFuncionDinamica(ecuacion, x);
      if (!y.isNaN && !y.isInfinite) {
        puntos.add(FlSpot(x, y));
      }
    }
    setState(() {
      _puntosGrafica = puntos;
    });
  }

  void _calcularSecanteModificada() {
    String ecuacionTxt = _controladorEcuacion.text.trim().toLowerCase();
    double xi = double.tryParse(_controladorX0.text) ?? 1.0;
    double delta = double.tryParse(_controladorDelta.text) ?? 0.01;
    double tolerancia = double.tryParse(_controladorTol.text) ?? 0.0001;
    int maxIteraciones = int.tryParse(_controladorMaxIter.text) ?? 20;

    if (_evaluarFuncionDinamica(ecuacionTxt, xi).isNaN) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error en la sintaxis de la ecuación"), backgroundColor: Colors.redAccent),
      );
      return;
    }

    List<Map<String, dynamic>> temporalIteraciones = [];
    double errorAproximado = 100.0;
    int iteracion = 0;
    double xSiguiente = 0.0;
    bool convergenciaExitosa = false;

    while (iteracion < maxIteraciones) {
      double fx = _evaluarFuncionDinamica(ecuacionTxt, xi);
      double f_xi_delta = _evaluarFuncionDinamica(ecuacionTxt, xi + (delta * xi));

      if ((f_xi_delta - fx).abs() < 1e-12) break;

      xSiguiente = xi - (delta * xi * fx) / (f_xi_delta - fx);

      if (iteracion > 0) {
        errorAproximado = ((xSiguiente - xi) / xSiguiente).abs() * 100;
      }

      temporalIteraciones.add({
        "iter": iteracion + 1,
        "xi": xi,
        "f_xi": fx,
        "error": iteracion == 0 ? "---" : "${errorAproximado.toStringAsFixed(5)}%"
      });

      if (iteracion > 0 && errorAproximado < tolerancia) {
        convergenciaExitosa = true;
        xi = xSiguiente;
        break;
      }

      xi = xSiguiente;
      iteracion++;
    }

    setState(() {
      _historialIteraciones = temporalIteraciones;
      _raizEncontrada = xi;
      _calculado = true;
      _resultadoRaiz = xi.toStringAsFixed(6);
    });

    // Generar la curva matemática con base a la raíz obtenida
    _generarPuntosGrafica(ecuacionTxt, xi);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Secante Modificada + Gráfica"),
        backgroundColor: Colors.teal[900],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Panel de entradas
            TextField(
              controller: _controladorEcuacion,
              style: const TextStyle(color: Colors.tealAccent, fontFamily: 'monospace'),
              decoration: const InputDecoration(
                labelText: "Función f(x):",
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.tealAccent)),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _crearCampoEntrada(_controladorX0, "x0")),
                const SizedBox(width: 10),
                Expanded(child: _crearCampoEntrada(_controladorDelta, "δ")),
                const SizedBox(width: 10),
                Expanded(child: _crearCampoEntrada(_controladorTol, "Tolerancia")),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal[700]),
                onPressed: _calcularSecanteModificada,
                child: const Text("Calcular y Graficar", style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 10),

            // Contenedor dinámico con pestañas: una para la Tabla y otra para la Gráfica
            if (_calculado)
              Expanded(
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      const TabBar(
                        tabs: [
                          Tab(icon: Icon(Icons.show_chart), text: "Gráfica de Verificación"),
                          Tab(icon: Icon(Icons.list_alt), text: "Tabla de Errores"),
                        ],
                        labelColor: Colors.tealAccent,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Colors.tealAccent,
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: TabBarView(
                          children: [
                            // PESTAÑA 1: LA GRÁFICA MATEMÁTICA
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: LineChart(
                                LineChartData(
                                  gridData: FlGridData(show: true, drawVerticalLine: true),
                                  titlesData: FlTitlesData(show: true),
                                  borderData: FlBorderData(show: true, border: Border.all(color: Colors.white30)),
                                  lineBarsData: [
                                    // Curva de la función
                                    LineChartBarData(
                                      spots: _puntosGrafica,
                                      isCurved: true,
                                      color: Colors.tealAccent,
                                      barWidth: 3,
                                      isStrokeCapRound: true,
                                      dotData: FlDotData(show: false),
                                    ),
                                    // Punto de la raíz encontrada
                                    LineChartBarData(
                                      spots: [FlSpot(_raizEncontrada, 0)],
                                      show: true,
                                      color: Colors.red,
                                      barWidth: 0,
                                      dotData: FlDotData(
                                        show: true,
                                        getDotPainter: (spot, percent, barData, index) =>
                                            FlDotCirclePainter(radius: 6, color: Colors.red, strokeWidth: 2, strokeColor: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // PESTAÑA 2: LA TABLA DE CONVERGENCIA
                            SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  headingRowColor: WidgetStateProperty.all(Colors.grey[900]),
                                  columns: const [
                                    DataColumn(label: Text("Iteración", style: TextStyle(color: Colors.white))),
                                    DataColumn(label: Text("xi", style: TextStyle(color: Colors.white))),
                                    DataColumn(label: Text("f(xi)", style: TextStyle(color: Colors.white))),
                                    DataColumn(label: Text("Error", style: TextStyle(color: Colors.white))),
                                  ],
                                  rows: _historialIteraciones.map((fila) {
                                    return DataRow(cells: [
                                      DataCell(Text(fila['iter'].toString(), style: const TextStyle(color: Colors.white))),
                                      DataCell(Text(fila['xi'].toStringAsFixed(5), style: const TextStyle(color: Colors.white70))),
                                      DataCell(Text(fila['f_xi'].toStringAsFixed(5), style: const TextStyle(color: Colors.white70))),
                                      DataCell(Text(fila['error'], style: const TextStyle(color: Colors.amber))),
                                    ]);
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              const Expanded(
                child: Center(child: Text("Presiona Calcular para renderizar la curva y la tabla.", style: TextStyle(color: Colors.grey))),
              )
          ],
        ),
      ),
    );
  }

  Widget _crearCampoEntrada(TextEditingController controlador, String etiqueta) {
    return TextField(
      controller: controlador,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: const TextStyle(color: Colors.white, fontSize: 13),
      decoration: InputDecoration(
        labelText: etiqueta,
        labelStyle: const TextStyle(color: Colors.tealAccent, fontSize: 11),
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
      ),
    );
  }
}