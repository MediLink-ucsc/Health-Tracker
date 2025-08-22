import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  // Load configuration from .env file with fallbacks
  static String get baseUrl {
    try {
      final envUrl = dotenv.env['BASE_URL'];
      print('ENV BASE_URL: $envUrl'); // Debug log
      return envUrl ?? 'http://10.21.130.26:3000/api';
    } catch (e) {
      print('Error loading BASE_URL from env: $e'); // Debug log
      return 'http://10.21.130.26:3000/api';
    }
  }

  static String get defaultPort {
    try {
      return dotenv.env['DEFAULT_PORT'] ?? '3000';
    } catch (e) {
      return '3000';
    }
  }

  static String get flutterWebPort {
    try {
      return dotenv.env['FLUTTER_WEB_PORT'] ?? '8080';
    } catch (e) {
      return '8080';
    }
  }

  // API endpoints
  static const String loginEndpoint = '/v1/auth/patient/login';
  static const String labReportEndpoint = '/v1/labReport/workflow/patients';

  // Timeout settings
  static Duration get apiTimeout {
    try {
      return Duration(
        seconds: int.tryParse(dotenv.env['API_TIMEOUT_SECONDS'] ?? '30') ?? 30,
      );
    } catch (e) {
      return Duration(seconds: 30);
    }
  }

  // Debug settings
  static bool get enableApiLogging {
    try {
      return dotenv.env['ENABLE_API_LOGGING']?.toLowerCase() == 'true';
    } catch (e) {
      return false;
    }
  }
}