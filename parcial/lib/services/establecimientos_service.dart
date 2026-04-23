import 'package:dio/dio.dart';
import '../models/establecimiento_model.dart';
import 'dio_client.dart';

class EstablecimientosService {
  EstablecimientosService._();
  static final EstablecimientosService instance = EstablecimientosService._();

  final Dio _dio = DioClient.establecimientosClient;

  Future<List<EstablecimientoModel>> getAll() async {
    try {
      final response = await _dio.get('/establecimientos');
      final data = response.data;

      List<dynamic> lista;
      if (data is List) {
        lista = data;
      } else if (data is Map && data.containsKey('data')) {
        lista = data['data'] as List<dynamic>;
      } else {
        lista = [];
      }

      return lista
          .map((e) => EstablecimientoModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(DioClient.errorMessage(e));
    }
  }

  Future<EstablecimientoModel> getById(int id) async {
    try {
      final response = await _dio.get('/establecimientos/$id');
      final data = response.data;
      final json = data is Map && data.containsKey('data')
          ? data['data'] as Map<String, dynamic>
          : data as Map<String, dynamic>;
      return EstablecimientoModel.fromJson(json);
    } on DioException catch (e) {
      throw Exception(DioClient.errorMessage(e));
    }
  }

  Future<EstablecimientoModel> create(
    EstablecimientoModel model, {
    String? logoPath,
  }) async {
    try {
      final formData = await _buildFormData(model, logoPath: logoPath);
      final response = await _dio.post(
        '/establecimientos',
        data: formData,
      );
      final json = _extractJson(response.data);
      return EstablecimientoModel.fromJson(json);
    } on DioException catch (e) {
      throw Exception(DioClient.errorMessage(e));
    }
  }

  Future<EstablecimientoModel> update(
    EstablecimientoModel model, {
    String? logoPath,
  }) async {
    assert(model.id != null, 'El modelo debe tener ID para actualizarse');
    try {
      final formData = await _buildFormData(
        model,
        logoPath: logoPath,
      );
      final response = await _dio.post(
        '/establecimiento-update/${model.id}',
        data: formData,
      );
      final json = _extractJson(response.data);
      return EstablecimientoModel.fromJson(json);
    } on DioException catch (e) {
      throw Exception(DioClient.errorMessage(e));
    }
  }

  Future<void> delete(int id) async {
    try {
      await _dio.delete('/establecimientos/$id');
    } on DioException catch (e) {
      throw Exception(DioClient.errorMessage(e));
    }
  }

  Future<FormData> _buildFormData(
    EstablecimientoModel model, {
    String? logoPath,
  }) async {
    final fields = <String, dynamic>{
      'nombre': model.nombre,
      'nit': model.nit,
      'direccion': model.direccion,
      'telefono': model.telefono,
    };

    final formData = FormData.fromMap(fields);

    if (logoPath != null && logoPath.isNotEmpty) {
      formData.files.add(
        MapEntry(
          'logo',
          await MultipartFile.fromFile(
            logoPath,
            filename: logoPath.split('/').last,
          ),
        ),
      );
    }

    return formData;
  }

  Map<String, dynamic> _extractJson(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data.containsKey('data')
          ? data['data'] as Map<String, dynamic>
          : data;
    }
    throw Exception('Formato de respuesta inesperado');
  }
}
