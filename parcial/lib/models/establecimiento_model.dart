class EstablecimientoModel {
  final int? id;
  final String nombre;
  final String nit;
  final String direccion;
  final String telefono;
  final String? logoUrl;

  EstablecimientoModel({
    this.id,
    required this.nombre,
    required this.nit,
    required this.direccion,
    required this.telefono,
    this.logoUrl,
  });

  factory EstablecimientoModel.fromJson(Map<String, dynamic> json) {
    return EstablecimientoModel(
      id: json['id'] as int?,
      nombre: json['nombre']?.toString() ?? '',
      nit: json['nit']?.toString() ?? '',
      direccion: json['direccion']?.toString() ?? '',
      telefono: json['telefono']?.toString() ?? '',
      logoUrl: json['logo']?.toString(), // La API devuelve la url en 'logo'
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nombre': nombre,
      'nit': nit,
      'direccion': direccion,
      'telefono': telefono,
      // logo is usually sent as multipart, so not in simple JSON
    };
  }

  EstablecimientoModel copyWith({
    int? id,
    String? nombre,
    String? nit,
    String? direccion,
    String? telefono,
    String? logoUrl,
  }) {
    return EstablecimientoModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      nit: nit ?? this.nit,
      direccion: direccion ?? this.direccion,
      telefono: telefono ?? this.telefono,
      logoUrl: logoUrl ?? this.logoUrl,
    );
  }
}
