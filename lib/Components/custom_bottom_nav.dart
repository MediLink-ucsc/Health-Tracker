import 'package:flutter/material.dart';
import 'package:health_tracker/screens/Clinic/clinical_records.dart';
import 'package:health_tracker/screens/Metrics/input_metrics_screen.dart';
import '../screens/Home/home_screen.dart';
import '../screens/Profile/profile_screen.dart';
// import '../AddMetrics/add_metrics_screen.dart'; // example destination

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0D9488);

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        BottomAppBar(
          color: const Color(0xFFE0F2F1),
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.home),
                color: currentIndex == 0 ? primaryColor : Colors.grey.shade700,
                iconSize: 28,
                onPressed: () {
                  if (currentIndex != 0) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    );
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.assignment),
                color: currentIndex == 1 ? primaryColor : Colors.grey.shade700,
                iconSize: 28,
                onPressed: () {
                  // Add your navigation
                },
              ),
              const SizedBox(width: 48),
              IconButton(
                icon: const Icon(Icons.local_hospital),
                color: currentIndex == 2 ? primaryColor : Colors.grey.shade700,
                iconSize: 28,
                onPressed: () {
                  if (currentIndex != 0) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ClinicalCalendarScreen(),
                      ),
                    );
                  }
                  // Add your navigation
                },
              ),
              IconButton(
                icon: const Icon(Icons.person),
                color: currentIndex == 3 ? primaryColor : Colors.grey.shade700,
                iconSize: 28,
                onPressed: () {
                  if (currentIndex != 3) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfileScreen()),
                    );
                  }
                },
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 12,
          child: FloatingActionButton(
            onPressed: () {
              // ✅ Hardcoded navigation here
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const InputMetricsScreen(),
                  // e.g., AddMetricsScreen()
                ),
              );
            },
            backgroundColor: primaryColor,
            elevation: 4,
            child: const Icon(Icons.add, size: 28),
          ),
        ),
      ],
    );
  }
}