import 'package:flutter/material.dart';
import '../screens/user_login_screen.dart';

void appLogout(BuildContext context) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => const UserLoginScreen()),
    (route) => false,
  );
}