class AccidenteModel {
  final String clase;
  final String gravedad;
  final String barrio;
  final String fecha; // YYYY-MM-DD...
  final String dia;

  AccidenteModel({
    required this.clase,
    required this.gravedad,
    required this.barrio,
    required this.fecha,
    required this.dia,
  });

  factory AccidenteModel.fromJson(Map<String, dynamic> json) {
    return AccidenteModel(
      clase: json['clase_de_accidente']?.toString() ?? 'Desconocido',
      gravedad: json['gravedad_del_accidente']?.toString() ?? 'Desconocida',
      barrio: json['barrio_hecho']?.toString() ?? 'Sin barrio',
      fecha: json['fecha']?.toString() ?? '',
      dia: json['dia']?.toString() ?? 'Desconocido',
    );
  }
}

class AccidentesStats {
  final Map<String, int> porClase;
  final Map<String, int> porGravedad;
  final Map<String, int> topBarrios;
  final Map<String, int> porDiaSemana;

  AccidentesStats({
    required this.porClase,
    required this.porGravedad,
    required this.topBarrios,
    required this.porDiaSemana,
  });

  factory AccidentesStats.empty() {
    return AccidentesStats(
      porClase: {},
      porGravedad: {},
      topBarrios: {},
      porDiaSemana: {},
    );
  }

  factory AccidentesStats.fromJson(Map<String, dynamic> json) {
    return AccidentesStats(
      porClase: Map<String, int>.from(json['porClase'] ?? {}),
      porGravedad: Map<String, int>.from(json['porGravedad'] ?? {}),
      topBarrios: Map<String, int>.from(json['topBarrios'] ?? {}),
      porDiaSemana: Map<String, int>.from(json['porDiaSemana'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'porClase': porClase,
      'porGravedad': porGravedad,
      'topBarrios': topBarrios,
      'porDiaSemana': porDiaSemana,
    };
  }
}
