import 'package:flutter/material.dart';
import '../screens/user_login_screen.dart';
import '../services/auth_service.dart';

void appLogout(BuildContext context) async {
  // Clear authentication data
  await AuthService.logout();

  // Navigate to login screen and clear stack
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => const UserLoginScreen()),
    (route) => false,
  );
}
