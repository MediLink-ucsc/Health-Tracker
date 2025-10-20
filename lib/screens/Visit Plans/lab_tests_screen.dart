import 'package:flutter/material.dart';
import 'package:health_tracker/screens/Visit%20Plans/view_lab_test_screen.dart';
import '../../Components/custom_bottom_nav.dart';
import '../../Components/logout.dart';
import '../../models/lab_test.dart';
import '../../services/lab_test_service.dart';
import 'view_lab_test_screen.dart';

class LabTestListScreen extends StatelessWidget {
  const LabTestListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0D9488);
    const patientId = "12345"; // Replace dynamically if needed

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab Tests'),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Logout'),
                content: const Text('Are you sure you want to log out?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      appLogout(context);
                    },
                    child: const Text('Logout'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 3),
      body: FutureBuilder<List<LabTest>>(
        future: LabTestService.getLabTests(patientId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('❌ ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No lab tests found.'));
          }

          final tests = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: tests.length,
            itemBuilder: (context, index) {
              final t = tests[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundImage: t.doctorPhoto.isNotEmpty
                        ? NetworkImage(t.doctorPhoto)
                        : const AssetImage('assets/default_doctor.jpg')
                              as ImageProvider,
                  ),
                  title: Text(
                    t.testName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${t.date.toLocal()}'.split(' ')[0],
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LabTestDetailScreen(test: t),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}