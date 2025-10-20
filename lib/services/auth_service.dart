import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:developer' as developer;

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _rememberMeKey = 'remember_me';
  static const String _savedUsernameKey = 'saved_username';
  static const String _savedPasswordKey = 'saved_password';

  // Token management
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Remember me functionality
  static Future<void> saveLoginCredentials(
    String username,
    String password,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberMeKey, true);
    await prefs.setString(_savedUsernameKey, username);
    await prefs.setString(_savedPasswordKey, password);
  }

  static Future<void> clearSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberMeKey, false);
    await prefs.remove(_savedUsernameKey);
    await prefs.remove(_savedPasswordKey);
  }

  static Future<SavedCredentials?> getSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool(_rememberMeKey) ?? false;

    if (rememberMe) {
      final username = prefs.getString(_savedUsernameKey);
      final password = prefs.getString(_savedPasswordKey);

      if (username != null && password != null) {
        return SavedCredentials(username: username, password: password);
      }
    }

    return null;
  }

  // Complete logout
  static Future<void> logout() async {
    await removeToken();
    // Note: We don't clear saved credentials on logout if user has "remember me" enabled
  }

  // JWT Token decoding functionality
  static Map<String, dynamic>? decodeJWT(String token) {
    try {
      // JWT tokens have 3 parts separated by dots: header.payload.signature
      final parts = token.split('.');
      if (parts.length != 3) {
        developer.log('Invalid JWT token format', name: 'AuthService');
        return null;
      }

      // Decode the payload (second part)
      final payload = parts[1];

      // Add padding if necessary for base64 decoding
      String normalizedPayload = payload;
      switch (payload.length % 4) {
        case 1:
          normalizedPayload += '===';
          break;
        case 2:
          normalizedPayload += '==';
          break;
        case 3:
          normalizedPayload += '=';
          break;
      }

      // Decode from base64 and parse JSON
      final decodedBytes = base64Url.decode(normalizedPayload);
      final decodedString = utf8.decode(decodedBytes);
      final Map<String, dynamic> decoded = json.decode(decodedString);

      return decoded;
    } catch (e) {
      developer.log('Error decoding JWT token: $e', name: 'AuthService');
      return null;
    }
  }

  // Get and decode the current user's token
  static Future<Map<String, dynamic>?> getCurrentUserData() async {
    try {
      final token = await getToken();
      if (token == null) {
        developer.log('No token found', name: 'AuthService');
        return null;
      }

      final decodedData = decodeJWT(token);
      if (decodedData != null) {
        developer.log('Decoded JWT data: $decodedData', name: 'AuthService');

        // Log specific fields if they exist
        if (decodedData.containsKey('userId')) {
          developer.log(
            'User ID: ${decodedData['userId']}',
            name: 'AuthService',
          );
        }
        if (decodedData.containsKey('email')) {
          developer.log('Email: ${decodedData['email']}', name: 'AuthService');
        }
        if (decodedData.containsKey('role')) {
          developer.log('Role: ${decodedData['role']}', name: 'AuthService');
        }
        if (decodedData.containsKey('exp')) {
          final exp = decodedData['exp'];
          final expDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
          developer.log('Token expires at: $expDate', name: 'AuthService');
        }
      }

      return decodedData;
    } catch (e) {
      developer.log('Error getting current user data: $e', name: 'AuthService');
      return null;
    }
  }

  static Future<String?> getUserId() async {
    final decoded = await AuthService.getCurrentUserData();
    // print('🔸 Decoded user data: $data');

    if (decoded != null && decoded.containsKey('id')) {
      final userId = decoded['id'];
      return userId.toString();
    }
    return null;
  }

  // Check if token is expired
  static Future<bool> isTokenExpired() async {
    try {
      final userData = await getCurrentUserData();
      if (userData == null || !userData.containsKey('exp')) {
        return true;
      }

      final exp = userData['exp'];
      final expDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      final now = DateTime.now();

      final isExpired = now.isAfter(expDate);
      developer.log('Token is expired: $isExpired', name: 'AuthService');

      return isExpired;
    } catch (e) {
      developer.log('Error checking token expiration: $e', name: 'AuthService');
      return true;
    }
  }
}

class SavedCredentials {
  final String username;
  final String password;

  SavedCredentials({required this.username, required this.password});
}