import 'package:flutter/material.dart';
import 'package:health_tracker/screens/Metrics/record_metrices_section.dart';

import '../../Components/custom_bottom_nav.dart';
import '../../Components/logout.dart';

void main() {
  runApp(const MaterialApp(home: InputMetricScreen()));
}

class InputMetricScreen extends StatelessWidget {
  const InputMetricScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Metrics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to log out?'),
                  actions: [
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    TextButton(
                      child: const Text('Logout'),
                      onPressed: () {
                        Navigator.pop(context);
                        appLogout(context);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 4),
      body: const RecordMetricsScreen(), // Only input section
    );
  }
}