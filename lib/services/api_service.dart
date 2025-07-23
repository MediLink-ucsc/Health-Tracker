import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/lab_report.dart';
import 'auth_service.dart';

class ApiService {
  static const Duration timeout = Duration(seconds: 30);

  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Future<Map<String, String>> get _authHeaders async {
    final token = await AuthService.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Login API call
  static Future<LoginResponse> login(String username, String password) async {
    try {
      final url = '${AppConfig.baseUrl}${AppConfig.loginEndpoint}';

      // Enhanced debugging
      print('=== API DEBUG INFO ===');
      print('Attempting to connect to: $url');
      print('Base URL from config: ${AppConfig.baseUrl}');
      print('Login endpoint: ${AppConfig.loginEndpoint}');
      print('Headers: $_headers');
      print('=====================');

      if (AppConfig.enableApiLogging) {
        print('API Request: POST $url');
        print('Request Body: {"username": "$username", "password": "***"}');
      }

      final response = await http
          .post(
            Uri.parse(url),
            headers: _headers,
            body: jsonEncode({'username': username, 'password': password}),
          )
          .timeout(timeout);

      if (AppConfig.enableApiLogging) {
        print('API Response: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Success response
        if (responseData.containsKey('token')) {
          return LoginResponse(
            success: true,
            token: responseData['token'],
            message: null,
          );
        } else {
          return LoginResponse(
            success: false,
            token: null,
            message: 'Invalid response format',
          );
        }
      } else {
        // Error response
        return LoginResponse(
          success: false,
          token: null,
          message: responseData['message'] ?? 'Login failed',
        );
      }
    } on http.ClientException catch (e) {
      print('=== NETWORK ERROR DEBUG ===');
      print('ClientException: $e');
      print('Error type: ${e.runtimeType}');
      print('========================');

      if (AppConfig.enableApiLogging) {
        print('Network Error: $e');
      }
      return LoginResponse(
        success: false,
        token: null,
        message: 'Network error: $e',
      );
    } on FormatException catch (e) {
      print('=== FORMAT ERROR DEBUG ===');
      print('FormatException: $e');
      print('Error type: ${e.runtimeType}');
      print('=======================');

      if (AppConfig.enableApiLogging) {
        print('Format Error: $e');
      }
      return LoginResponse(
        success: false,
        token: null,
        message: 'Invalid server response format: $e',
      );
    } catch (e) {
      print('=== GENERAL ERROR DEBUG ===');
      print('Exception: $e');
      print('Error type: ${e.runtimeType}');
      print('========================');

      if (AppConfig.enableApiLogging) {
        print('API Error: $e');
      }
      return LoginResponse(
        success: false,
        token: null,
        message: 'Unexpected error: $e',
      );
    }
  }

  // Fetch lab reports for a patient
  static Future<LabReportHistoryResponse> getLabReports(
    String patientId,
  ) async {
    try {
      final url =
          '${AppConfig.baseUrl}${AppConfig.labReportEndpoint}/$patientId/history';
      final headers = await _authHeaders;

      if (AppConfig.enableApiLogging) {
        print('API Request: GET $url');
        print('Request Headers: $headers');
      }

      final response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(timeout);

      if (AppConfig.enableApiLogging) {
        print('API Response: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return LabReportHistoryResponse.fromJson(responseData);
      } else {
        return LabReportHistoryResponse(
          success: false,
          message: responseData['message'] ?? 'Failed to fetch lab reports',
        );
      }
    } on http.ClientException catch (e) {
      if (AppConfig.enableApiLogging) {
        print('Network Error: $e');
      }
      return LabReportHistoryResponse(
        success: false,
        message: 'Network error: Please check your internet connection',
      );
    } on FormatException catch (e) {
      if (AppConfig.enableApiLogging) {
        print('Format Error: $e');
      }
      return LabReportHistoryResponse(
        success: false,
        message: 'Invalid server response format',
      );
    } catch (e) {
      if (AppConfig.enableApiLogging) {
        print('API Error: $e');
      }
      return LabReportHistoryResponse(
        success: false,
        message: 'An unexpected error occurred. Please try again.',
      );
    }
  }
}

class LoginResponse {
  final bool success;
  final String? token;
  final String? message;

  LoginResponse({required this.success, this.token, this.message});
}
