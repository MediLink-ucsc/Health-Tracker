import 'package:shared_preferences/shared_preferences.dart';

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
}

class SavedCredentials {
  final String username;
  final String password;

  SavedCredentials({required this.username, required this.password});
}
