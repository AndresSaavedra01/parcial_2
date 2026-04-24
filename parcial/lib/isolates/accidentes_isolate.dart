import 'package:flutter/foundation.dart';
import '../models/accidente_model.dart';

Map<String, dynamic> procesarAccidentesEnIsolate(List<dynamic> rawData) {
  final stopwatch = Stopwatch()..start();
  int count = rawData.length;
  
  debugPrint('[Isolate] Iniciado — $count registros recibidos');

  final porClase = <String, int>{};
  final porGravedad = <String, int>{};
  final porBarrio = <String, int>{};
  final porDiaSemana = <String, int>{};

  for (var item in rawData) {
    if (item is! Map<String, dynamic>) continue;

    final accidente = AccidenteModel.fromJson(item);

    // 1. Clase de accidente
    porClase[accidente.clase] = (porClase[accidente.clase] ?? 0) + 1;

    // 2. Gravedad
    porGravedad[accidente.gravedad] = (porGravedad[accidente.gravedad] ?? 0) + 1;

    // 3. Barrio
    if (accidente.barrio.isNotEmpty && accidente.barrio != 'Sin barrio') {
      porBarrio[accidente.barrio] = (porBarrio[accidente.barrio] ?? 0) + 1;
    }

    // 4. Día de la semana
    if (accidente.dia.isNotEmpty && accidente.dia != 'Desconocido') {
      final dayName = accidente.dia.toUpperCase();
      porDiaSemana[dayName] = (porDiaSemana[dayName] ?? 0) + 1;
    }
  }

  // Obtener top 5 barrios
  final barriosList = porBarrio.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  final top5Barrios = Map.fromEntries(barriosList.take(5));

  stopwatch.stop();
  debugPrint('[Isolate] Completado en ${stopwatch.elapsedMilliseconds} ms');

  return {
    'porClase': porClase,
    'porGravedad': porGravedad,
    'topBarrios': top5Barrios,
    'porDiaSemana': porDiaSemana,
  };
}

