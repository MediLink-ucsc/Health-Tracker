import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

class ApiService {
  static const Duration timeout = Duration(seconds: 30);

  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Login API call
  static Future<LoginResponse> login(String username, String password) async {
    try {
      final url = '${AppConfig.baseUrl}${AppConfig.loginEndpoint}';

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
      if (AppConfig.enableApiLogging) {
        print('Network Error: $e');
      }
      return LoginResponse(
        success: false,
        token: null,
        message: 'Network error: Please check your internet connection',
      );
    } on FormatException catch (e) {
      if (AppConfig.enableApiLogging) {
        print('Format Error: $e');
      }
      return LoginResponse(
        success: false,
        token: null,
        message: 'Invalid server response format',
      );
    } catch (e) {
      if (AppConfig.enableApiLogging) {
        print('API Error: $e');
      }
      return LoginResponse(
        success: false,
        token: null,
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
