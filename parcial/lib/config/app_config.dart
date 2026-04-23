import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get accidentsBaseUrl => dotenv.env['ACCIDENTES_BASE_URL'] ?? '';
  static String get establecimientosBaseUrl => dotenv.env['ESTABLECIMIENTOS_BASE_URL'] ?? '';
  static int get accidentsLimit => int.tryParse(dotenv.env['ACCIDENTES_LIMIT'] ?? '100000') ?? 100000;
}
