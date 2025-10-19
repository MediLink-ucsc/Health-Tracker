import 'package:flutter/material.dart';
import '../../Components/custom_bottom_nav.dart';
import '../../Components/logout.dart';
import 'view_care_plan_screen.dart';
import '/models/care_plan.dart';

class CarePlanListScreen extends StatelessWidget {
  CarePlanListScreen({super.key});

  final List<CarePlan> _carePlans = [
    CarePlan(
      planType: 'Diabetes Management',
      priority: 'High',
      startDate: DateTime.now().subtract(const Duration(days: 10)),
      endDate: DateTime.now().add(const Duration(days: 20)),
      description: 'Monitor blood sugar and maintain healthy diet.',
      goals: 'Keep blood sugar in range and avoid complications.',
      tasks: [
        CareTask(
          description: 'Check blood sugar every morning',
          dueDate: DateTime.now().add(const Duration(days: 1)),
          priority: 'High',
        ),
        CareTask(
          description: 'Take medication on time',
          dueDate: DateTime.now().add(const Duration(days: 2)),
          priority: 'Medium',
        ),
      ],
    ),
    CarePlan(
      planType: 'Post Surgery Recovery',
      priority: 'Medium',
      startDate: DateTime.now().subtract(const Duration(days: 5)),
      endDate: DateTime.now().add(const Duration(days: 25)),
      description: 'Focus on wound healing and follow-up checkups.',
      goals: 'Full recovery within expected time.',
      tasks: [
        CareTask(
          description: 'Daily wound dressing',
          dueDate: DateTime.now().add(const Duration(days: 1)),
          priority: 'High',
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0D9488);

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
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _carePlans.length,
        itemBuilder: (context, index) {
          final plan = _carePlans[index];
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
      ),
    );
  }
}