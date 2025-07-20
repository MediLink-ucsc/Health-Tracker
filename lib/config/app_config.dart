import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  // Load configuration from .env file
  static String get baseUrl =>
      dotenv.env['BASE_URL'] ?? 'http://localhost:3000/api';
  static String get defaultPort => dotenv.env['DEFAULT_PORT'] ?? '3000';
  static String get flutterWebPort => dotenv.env['FLUTTER_WEB_PORT'] ?? '8080';

  // API endpoints
  static const String loginEndpoint = '/v1/auth/patient/login';
  static const String labReportEndpoint = '/v1/labReport/workflow/patients';

  // Timeout settings
  static Duration get apiTimeout => Duration(
    seconds: int.tryParse(dotenv.env['API_TIMEOUT_SECONDS'] ?? '30') ?? 30,
  );

  // Debug settings
  static bool get enableApiLogging =>
      dotenv.env['ENABLE_API_LOGGING']?.toLowerCase() == 'true';
}
