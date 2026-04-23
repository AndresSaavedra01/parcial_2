import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../models/accidente_model.dart';
import '../../services/accidentes_service.dart';
import '../../themes/app_theme.dart';
import '../../widgets/stat_pie_chart.dart';
import '../../widgets/stat_bar_chart.dart';

class AccidentesView extends StatefulWidget {
  const AccidentesView({super.key});

  @override
  State<AccidentesView> createState() => _AccidentesViewState();
}

class _AccidentesViewState extends State<AccidentesView> {
  bool _isLoading = true;
  String? _error;
  AccidentesStats? _stats;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final stats = await AccidentesService.instance.fetchAndProcess();
      if (mounted) {
        setState(() {
          _stats = stats;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Accidentes')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $_error'),
              ElevatedButton(
                onPressed: _fetchData,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    final dataToRender = _isLoading ? AccidentesStats.empty() : _stats!;
    final total = dataToRender.porClase.values.fold(0, (a, b) => a + b);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas de Accidentes'),
      ),
      body: Skeletonizer(
        enabled: _isLoading,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total registros procesados: $total', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              Text('1. Clase de accidente', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              if (_isLoading) _mockPieChart() else StatPieChart(
                data: dataToRender.porClase,
                colors: const [Colors.red, Colors.blue, Colors.green, Colors.orange, Colors.purple],
              ),
              const SizedBox(height: 24),

              Text('2. Gravedad', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              if (_isLoading) _mockPieChart() else StatPieChart(
                data: dataToRender.porGravedad,
                colors: const [Colors.amber, Colors.deepOrange, Colors.teal],
              ),
              const SizedBox(height: 24),

              Text('3. Top 5 Barrios', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              if (_isLoading) _mockBarChart() else StatBarChart(
                labels: dataToRender.topBarrios.keys.toList(),
                values: dataToRender.topBarrios.values.map((v) => v.toDouble()).toList(),
                color: AppTheme.secondary,
              ),
              const SizedBox(height: 24),

              Text('4. Por Día de la Semana', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              if (_isLoading) _mockBarChart() else StatBarChart(
                labels: dataToRender.porDiaSemana.keys.toList(),
                values: dataToRender.porDiaSemana.values.map((v) => v.toDouble()).toList(),
                color: AppTheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mockPieChart() {
    return Container(
      height: 240,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16)
      ),
    );
  }

  Widget _mockBarChart() {
    return Container(
      height: 240,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16)
      ),
    );
  }
}
