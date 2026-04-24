import 'dart:isolate';
import 'package:dio/dio.dart';
import '../config/app_config.dart';
import '../models/accidente_model.dart';
import '../isolates/accidentes_isolate.dart';
import 'dio_client.dart';

class AccidentesService {
  AccidentesService._();
  static final AccidentesService instance = AccidentesService._();

  final Dio _dio = DioClient.accidentsClient;

  Future<AccidentesStats> fetchAndProcess() async {
    final rawData = await _fetchRaw();

    final result = await Isolate.run(
      () => procesarAccidentesEnIsolate(rawData),
    );

    return AccidentesStats.fromJson(result);
  }

  Future<List<dynamic>> _fetchRaw() async {
    try {
      final response = await _dio.get(
        '', 
        queryParameters: {
          '\$limit': AppConfig.accidentsLimit,
        },
      );

      if (response.data is List) {
        return response.data as List<dynamic>;
      }
      throw Exception('Formato de respuesta inesperado');
    } on DioException catch (e) {
      throw Exception(DioClient.errorMessage(e));
    }
  }
}
