import 'package:flutter/material.dart';
import 'package:health_tracker/screens/Care%20Plans/view_care_plan_screen.dart';
import '../../Components/custom_bottom_nav.dart';
import '../../Components/logout.dart';
import '../../models/care_plan.dart';
import '../../services/care_plan_service.dart';
import 'view_care_plan_screen.dart';

class CarePlanListScreen extends StatelessWidget {
  const CarePlanListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0D9488);
    const patientId = "12345"; // Replace dynamically

    return Scaffold(
      appBar: AppBar(
        title: const Text('Care Plans'),
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
      body: FutureBuilder<List<CarePlan>>(
        future: CarePlanService.getCarePlans(patientId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('❌ ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No care plans found.'));
          }

          final plans = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: plans.length,
            itemBuilder: (context, index) {
              final plan = plans[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  title: Text(
                    plan.planType,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${plan.startDate.toLocal()}'.split(' ')[0] +
                        ' - ' +
                        '${plan.endDate.toLocal()}'.split(' ')[0],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        plan.priority,
                        style: TextStyle(
                          color: plan.priority == 'High'
                              ? Colors.red
                              : (plan.priority == 'Medium'
                                    ? Colors.orange
                                    : Colors.green),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CarePlanDetailScreen(plan: plan),
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