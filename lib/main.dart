import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Health Tracker',
      debugShowCheckedModeBanner: false,
      home: GetStartedPage(),
    );
  }
}

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 60),

          // 🔹 Top: App Icon
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/icon/appIcon.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // 🔹 Title
          const Text(
            "Make your dreams happen!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 32,
            ),
          ),

          const SizedBox(height: 24),

          // 🔹 Middle & Bottom: Background image with button on top
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                // 📷 Background Image (fills remaining space only)
                Image.asset(
                  'assets/icon/appIcon.png',
                  fit: BoxFit.cover,
                ),

                // 🔘 Button at bottom over the image
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate next
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text("Get Started"),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
