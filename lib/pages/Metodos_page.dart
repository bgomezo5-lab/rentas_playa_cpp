import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;

class MetodosPage extends StatefulWidget {
  const MetodosPage({super.key});

  @override
  State<MetodosPage> createState() => _MetodosPageState();
}

class _MetodosPageState extends State<MetodosPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

// =========================================================================
  // MOTOR ULTRA-ROBUSTO DE EVALUACIÓN MATEMÁTICA (SOPORTA CUALQUIER FUNCIÓN)
  // =========================================================================
  double _evaluarEcuacion(String ecuacion, double x) {
    try {
      // Limpieza y estandarización del texto ingresado por el docente
      String formateada = ecuacion.trim().toLowerCase().replaceAll(' ', '');

      // TRADUCCIÓN CLAVE PARA LOGARITMO NATURAL
      formateada = formateada.replaceAll('ln(', 'log(');

      // Traducción de notación matemática común a funciones de Dart
      formateada = formateada.replaceAll('e^-x', 'exp(-x)');
      formateada = formateada.replaceAll('e^x', 'exp(x)');
      formateada = formateada.replaceAll('x^2', '(x*x)');
      formateada = formateada.replaceAll('x^3', '(x*x*x)');
      formateada = formateada.replaceAll('sen', 'sin');

      final expression = Expression.parse(formateada);
      final evaluator = const ExpressionEvaluator();

      final contexto = {
        'x': x,
        'pi': math.pi,
        'e': math.e,
        'sin': (num v) => math.sin(v),
        'cos': (num v) => math.cos(v),
        'tan': (num v) => math.tan(v),
        'sqrt': (num v) => math.sqrt(v),
        'exp': (num v) => math.exp(v),
        'log': (num v) => math.log(v), // En Dart, log() es logaritmo natural
      };

      final resultado = evaluator.eval(expression, contexto);
      return (resultado as num).toDouble();
    } catch (e) {
      return double.nan;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Suite de Métodos Numéricos"),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.amber,
          labelColor: Colors.amber,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.functions), text: "1. Raíces"),
            Tab(icon: Icon(Icons.grid_on), text: "2. Sistemas Lineales"),
            Tab(icon: Icon(Icons.html_sharp), text: "3. Integrales"),
            Tab(icon: Icon(Icons.timeline), text: "4. Ecuaciones Diff"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _moduloRaices(),
          _moduloSistemasLineales(),
          _moduloIntegrales(),
          _moduloEcuacionesDiferenciales(),
        ],
      ),
    );
  }

  // =========================================================================
  // BLOQUE 1: CÁLCULO DE RAÍCES + GRÁFICA DINÁMICA
  // =========================================================================
  final _ecuacionController = TextEditingController(text: "cos(x) - x");
  final _x0Controller = TextEditingController(text: "0.5");
  final _deltaController = TextEditingController(text: "0.01");
  final _tolController = TextEditingController(text: "0.0001");
  final List<Map<String, dynamic>> _historialRaices = [];
  List<FlSpot> _puntosGrafica = [];
  double _raizEncontrada = 0.0;

  void _calcularSecanteModificada() {
    _historialRaices.clear();
    _puntosGrafica.clear();

    String ecuacion = _ecuacionController.text;
    double xi = double.tryParse(_x0Controller.text) ?? 0.0;
    double delta = double.tryParse(_deltaController.text) ?? 0.01;
    double tol = double.tryParse(_tolController.text) ?? 0.001;

    double ea = 100.0;
    int iter = 0;
    int maxIter = 20;

    while (ea > tol && iter < maxIter) {
      double fx = _evaluarEcuacion(ecuacion, xi);
      double fxDelta = _evaluarEcuacion(ecuacion, xi + (delta * xi));

      if (fx.isNaN || fxDelta.isNaN || (fxDelta - fx).abs() < 1e-11) break;

      double xiSiguiente = xi - (delta * xi * fx) / (fxDelta - fx);

      if (iter > 0) {
        ea = ((xiSiguiente - xi) / xiSiguiente).abs() * 100;
      }

      _historialRaices.add({
        'iter': iter + 1,
        'xi': xi.toStringAsFixed(5),
        'fxi': fx.toStringAsFixed(5),
        'ea': iter == 0 ? "---" : "${ea.toStringAsFixed(4)}%"
      });

      xi = xiSiguiente;
      iter++;
    }

    _raizEncontrada = xi;

    // --- GENERACIÓN DE PUNTOS PARA LA GRÁFICA ALREDEDOR DE LA RAÍZ ---
    if (!_raizEncontrada.isNaN) {
      double rangoInicio = _raizEncontrada - 2.0;
      double rangoFin = _raizEncontrada + 2.0;
      double paso = 0.1;

      for (double x = rangoInicio; x <= rangoFin; x += paso) {
        double y = _evaluarEcuacion(ecuacion, x);
        if (!y.isNaN && !y.isInfinite) {
          _puntosGrafica.add(FlSpot(x, y));
        }
      }
    }

    setState(() {});
  }

  Widget _moduloRaices() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          _tarjetaEntrada("Secante Modificada", [
            _campoTexto(_ecuacionController, "Ecuación f(x) (Ej: cos(x)-x, exp(-x)-x)"),
            _campoTexto(_x0Controller, "Valor Inicial (x0)"),
            _campoTexto(_deltaController, "Delta (δ)"),
            _campoTexto(_tolController, "Tolerancia"),
          ], _calcularSecanteModificada),

          const SizedBox(height: 15),

          // --- PANEL DE LA GRÁFICA INTERACTIVA ---
          if (_puntosGrafica.isNotEmpty) ...[
            const Text("Visualización de Convergencia (Cruce por Cero)", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              height: 200,
              padding: const EdgeInsets.only(right: 20, top: 10),
              decoration: BoxDecoration(color: Colors.grey[950], borderRadius: BorderRadius.circular(10)),
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true, drawVerticalLine: true),
                  titlesData: const FlTitlesData(
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: true, border: Border.all(color: Colors.white24)),
                  lineBarsData: [
                    // Curva de la función
                    LineChartBarData(
                      spots: _puntosGrafica,
                      isCurved: true,
                      color: Colors.blueAccent,
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                    ),
                    // Indicador de la Raíz hallada (Punto Rojo sobre el eje)
                    LineChartBarData(
                      spots: [FlSpot(_raizEncontrada, 0)],
                      show: true,
                      color: Colors.red,
                      dotData: const FlDotData(show: true),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
          ],

          _tablaResultados(["Iter", "Xi", "f(Xi)", "Error (Ea)"], _historialRaices.map((e) => [
            e['iter'].toString(), e['xi'], e['fxi'], e['ea']
          ]).toList()),
        ],
      ),
    );
  }

  // =========================================================================
  // BLOQUE 2: SISTEMAS DE ECUACIONES LINEALES (MÉTODO DE JACOBI 3x3)
  // =========================================================================
  final List<List<TextEditingController>> _mC = List.generate(3, (_) => List.generate(3, (_) => TextEditingController()));
  final List<TextEditingController> _vB = List.generate(3, (_) => TextEditingController());
  final List<Map<String, dynamic>> _historialSistemas = [];

  void _calcularJacobi() {
    _historialSistemas.clear();
    double a11 = double.tryParse(_mC[0][0].text) ?? 5;
    double a12 = double.tryParse(_mC[0][1].text) ?? -1;
    double a13 = double.tryParse(_mC[0][2].text) ?? 1;
    double a21 = double.tryParse(_mC[1][0].text) ?? 2;
    double a22 = double.tryParse(_mC[1][1].text) ?? 8;
    double a23 = double.tryParse(_mC[1][2].text) ?? -1;
    double a31 = double.tryParse(_mC[2][0].text) ?? -1;
    double a32 = double.tryParse(_mC[2][1].text) ?? 1;
    double a33 = double.tryParse(_mC[2][2].text) ?? 4;

    double b1 = double.tryParse(_vB[0].text) ?? 10;
    double b2 = double.tryParse(_vB[1].text) ?? 11;
    double b3 = double.tryParse(_vB[2].text) ?? 3;

    double x1 = 0, x2 = 0, x3 = 0;
    int maxIter = 5;

    for (int k = 1; k <= maxIter; k++) {
      double nx1 = (b1 - (a12 * x2) - (a13 * x3)) / a11;
      double nx2 = (b2 - (a21 * x1) - (a23 * x3)) / a22;
      double nx3 = (b3 - (a31 * x1) - (a32 * x2)) / a33;

      double ea = k == 1 ? 100.0 : ((nx1 - x1) / nx1).abs() * 100;

      _historialSistemas.add({
        'iter': k,
        'x1': nx1.toStringAsFixed(4),
        'x2': nx2.toStringAsFixed(4),
        'x3': nx3.toStringAsFixed(4),
        'ea': "${ea.toStringAsFixed(2)}%"
      });

      x1 = nx1; x2 = nx2; x3 = nx3;
    }
    setState(() {});
  }

  Widget _moduloSistemasLineales() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          const Text("Sistema de Ecuaciones 3x3 [A][X] = [B]", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: List.generate(3, (r) => Row(
                  children: List.generate(3, (c) => Container(
                    width: 55, height: 40, margin: const EdgeInsets.all(2),
                    child: TextField(controller: _mC[r][c], style: const TextStyle(color: Colors.white, fontSize: 12), decoration: InputDecoration(hintText: "A${r+1}${c+1}", hintStyle: const TextStyle(color: Colors.grey), border: const OutlineInputBorder())),
                  )),
                )),
              ),
              const Text("  =  ", style: TextStyle(color: Colors.white, fontSize: 20)),
              Column(
                children: List.generate(3, (r) => Container(
                  width: 55, height: 40, margin: const EdgeInsets.all(2),
                  child: TextField(controller: _vB[r], style: const TextStyle(color: Colors.white, fontSize: 12), decoration: InputDecoration(hintText: "B${r+1}", hintStyle: const TextStyle(color: Colors.grey), border: const OutlineInputBorder())),
                )),
              )
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[800]), onPressed: _calcularJacobi, child: const Text("Resolver por Jacobi (Error Ea)", style: TextStyle(color: Colors.white))),
          const SizedBox(height: 15),
          _tablaResultados(["Iter", "X1", "X2", "X3", "Ea (X1)"], _historialSistemas.map((e) => [
            e['iter'].toString(), e['x1'], e['x2'], e['x3'], e['ea']
          ]).toList()),
        ],
      ),
    );
  }

  // =========================================================================
  // BLOQUE 3: APROXIMACIÓN DE INTEGRALES (REGLA DEL TRAPECIO COMPUESTA)
  // =========================================================================
  final _intEcuacionController = TextEditingController(text: "x^2");
  final _limAController = TextEditingController(text: "0");
  final _limBController = TextEditingController(text: "2");
  final _intervalosController = TextEditingController(text: "4");
  String _resultadoIntegral = "---";
  String _errorIntegralEst = "---";

  void _calcularIntegralTrapecio() {
    String ecuacion = _intEcuacionController.text;
    double a = double.tryParse(_limAController.text) ?? 0.0;
    double b = double.tryParse(_limBController.text) ?? 1.0;
    int n = int.tryParse(_intervalosController.text) ?? 4;

    if (n <= 0) return;

    double h = (b - a) / n;
    double suma = _evaluarEcuacion(ecuacion, a) + _evaluarEcuacion(ecuacion, b);

    for (int i = 1; i < n; i++) {
      suma += 2 * _evaluarEcuacion(ecuacion, a + (i * h));
    }
    double resultado = (h / 2) * suma;

    double h2 = (b - a) / (n * 2);
    double suma2 = _evaluarEcuacion(ecuacion, a) + _evaluarEcuacion(ecuacion, b);
    for (int i = 1; i < (n * 2); i++) {
      suma2 += 2 * _evaluarEcuacion(ecuacion, a + (i * h2));
    }
    double resultadoMasPreciso = (h2 / 2) * suma2;
    double errorEstimado = ((resultadoMasPreciso - resultado) / resultadoMasPreciso).abs() * 100;

    setState(() {
      _resultadoIntegral = resultado.toStringAsFixed(5);
      _errorIntegralEst = "${errorEstimado.toStringAsFixed(4)}%";
    });
  }

  Widget _moduloIntegrales() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          _tarjetaEntrada("Regla del Trapecio Compuesta", [
            _campoTexto(_intEcuacionController, "Función f(x)"),
            _campoTexto(_limAController, "Límite Inferior (a)"),
            _campoTexto(_limBController, "Límite Superior (b)"),
            _campoTexto(_intervalosController, "Número de Intervalos (n)"),
          ], _calcularIntegralTrapecio),
          const SizedBox(height: 20),
          Card(
            color: Colors.grey[900],
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Text("Área Aproximada: $_resultadoIntegral", style: const TextStyle(color: Colors.greenAccent, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text("Análisis de Error Estimado: $_errorIntegralEst", style: const TextStyle(color: Colors.orangeAccent, fontSize: 13)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // =========================================================================
  // BLOQUE 4: ECUACIONES DIFERENCIALES (MÉTODO DE EULER)
  // =========================================================================
  final _x0DiffController = TextEditingController(text: "0");
  final _y0DiffController = TextEditingController(text: "1");
  final _hDiffController = TextEditingController(text: "0.1");
  final _pasosDiffController = TextEditingController(text: "5");
  final List<List<String>> _historialDiff = [];

  void _calcularEuler() {
    _historialDiff.clear();
    double x = double.tryParse(_x0DiffController.text) ?? 0.0;
    double y = double.tryParse(_y0DiffController.text) ?? 1.0;
    double h = double.tryParse(_hDiffController.text) ?? 0.1;
    int pasos = int.tryParse(_pasosDiffController.text) ?? 5;

    for (int i = 0; i <= pasos; i++) {
      double pendiente = x + y;
      double valorVerdadero = 2 * math.exp(x) - x - 1;
      double errorVerdadero = (valorVerdadero - y).abs();

      _historialDiff.add([
        i.toString(),
        x.toStringAsFixed(2),
        y.toStringAsFixed(4),
        errorVerdadero.toStringAsFixed(4)
      ]);

      y = y + (h * pendiente);
      x = x + h;
    }
    setState(() {});
  }

  Widget _moduloEcuacionesDiferenciales() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          _tarjetaEntrada("Método de Euler (dy/dx = x + y)", [
            _campoTexto(_x0DiffController, "Condición Inicial x0"),
            _campoTexto(_y0DiffController, "Condición Inicial y0"),
            _campoTexto(_hDiffController, "Tamaño de Paso (h)"),
            _campoTexto(_pasosDiffController, "Número de pasos"),
          ], _calcularEuler),
          const SizedBox(height: 15),
          _tablaResultados(["Paso", "X", "Y (Aprox)", "Error Absoluto"], _historialDiff),
        ],
      ),
    );
  }

  // =========================================================================
  // COMPONENTES REUTILIZABLES DE INTERFAZ DE USUARIO (UI)
  // =========================================================================
  Widget _tarjetaEntrada(String titulo, List<Widget> campos, VoidCallback botonAccion) {
    return Card(
      color: Colors.grey[950],
      shape: RoundedRectangleBorder(side: const BorderSide(color: Colors.blue, width: 0.5), borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Text(titulo, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 10),
            ...campos,
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[900]),
                onPressed: botonAccion,
                child: const Text("Procesar Cálculo Numérico", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _campoTexto(TextEditingController controller, String etiqueta) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      height: 45,
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white, fontSize: 13),
        decoration: InputDecoration(
          labelText: etiqueta,
          labelStyle: const TextStyle(color: Colors.grey, fontSize: 12),
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
        ),
      ),
    );
  }

  Widget _tablaResultados(List<String> columnas, List<List<dynamic>> filas) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(border: Border.all(color: Colors.white12), borderRadius: BorderRadius.circular(5)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(Colors.blue[950]),
          dataRowColor: WidgetStateProperty.all(Colors.grey[900]),
          columnSpacing: 18,
          columns: columnas.map((c) => DataColumn(label: Text(c, style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12)))).toList(),
          rows: filas.map((f) => DataRow(cells: f.map((celda) => DataCell(Text(celda.toString(), style: const TextStyle(color: Colors.white, fontSize: 11)))).toList())).toList(),
        ),
      ),
    );
  }
}