import 'package:flutter/material.dart';
import 'package:health_tracker/screens/Home/home_screen.dart';
import 'package:health_tracker/screens/user_signing_screen.dart';
import 'package:health_tracker/services/api_service.dart';
import 'package:health_tracker/services/auth_service.dart';

class UserLoginScreen extends StatefulWidget {
  const UserLoginScreen({super.key});

  @override
  _UserLoginScreenState createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSavedLogin();
  }

  Future<void> _loadSavedLogin() async {
    final savedCredentials = await AuthService.getSavedCredentials();
    if (savedCredentials != null) {
      setState(() {
        _rememberMe = true;
        _phoneController.text = savedCredentials.username;
        _passwordController.text = savedCredentials.password;
      });
    }
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final username = _phoneController.text.trim();
      final password = _passwordController.text;

      try {
        final loginResponse = await ApiService.login(username, password);

        if (loginResponse.success && loginResponse.token != null) {
          // Save token
          await AuthService.saveToken(loginResponse.token!);

          // Save credentials if remember me is checked
          if (_rememberMe) {
            await AuthService.saveLoginCredentials(username, password);
          } else {
            await AuthService.clearSavedCredentials();
          }

          // Navigate to home screen
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          }
        } else {
          // Show error message
          if (mounted) {
            _showMessage(loginResponse.message ?? "Login failed");
          }
        }
      } catch (e) {
        if (mounted) {
          _showMessage("An unexpected error occurred. Please try again.");
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0D9488);
    const accentColor = Color(0xFFF1BE26);

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF9), // Light background
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // App Icon
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: primaryColor.withOpacity(0.1),
                      child: Icon(
                        Icons.lock_outline,
                        size: 40,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Text(
                      "Sign In",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Phone input
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone, color: primaryColor),
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (phone) {
                        if (phone == null || phone.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password input
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock, color: primaryColor),
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      obscureText: true,
                      validator: (password) {
                        if (password == null || password.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Remember me checkbox
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                          },
                          // activeColor: Colors.white,
                        ),
                        const Text('Remember Me'),
                      ],
                    ),
                    const SizedBox(height: 24), // Sign In button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _login,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Icon(Icons.login),
                        label: Text(_isLoading ? 'Signing In...' : 'Sign In'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          textStyle: const TextStyle(fontSize: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Navigate to Sign Up
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserSigningScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Don't have an account? Sign Up",
                        style: TextStyle(
                          color: accentColor,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
