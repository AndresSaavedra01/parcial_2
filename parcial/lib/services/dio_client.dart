import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config/app_config.dart';
import '../config/constants.dart';

class DioClient {
  DioClient._();

  static Dio get accidentsClient => _buildClient(AppConfig.accidentsBaseUrl);

  static Dio get establecimientosClient => _buildClient(AppConfig.establecimientosBaseUrl);

  static Dio _buildClient(String baseUrl) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: AppConstants.connectTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        headers: {
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      LogInterceptor(
        requestBody: false,
        responseBody: false,
        logPrint: (obj) => debugPrint('[DIO] $obj'),
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException e, handler) {
          final msg = _parseError(e);
          debugPrint('[DIO ERROR] $msg');
          handler.next(e);
        },
      ),
    );

    return dio;
  }

  static String _parseError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Tiempo de conexión agotado';
      case DioExceptionType.receiveTimeout:
        return 'Tiempo de descarga agotado';
      case DioExceptionType.badResponse:
        return 'Error del servidor: ${e.response?.statusCode}';
      case DioExceptionType.cancel:
        return 'Solicitud cancelada';
      default:
        return e.message ?? 'Error de red desconocido';
    }
  }

  static String errorMessage(Object e) {
    if (e is DioException) return _parseError(e);
    return e.toString();
  }
}
