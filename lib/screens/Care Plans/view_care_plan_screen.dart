import 'package:flutter/material.dart';
import '/models/care_plan.dart';

class CarePlanDetailScreen extends StatelessWidget {
  final CarePlan plan;

  const CarePlanDetailScreen({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0D9488);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Care Plan Details'),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              plan.planType,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  'Priority: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  plan.priority,
                  style: TextStyle(
                    color: plan.priority == 'High'
                        ? Colors.red
                        : (plan.priority == 'Medium'
                              ? Colors.orange
                              : Colors.green),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Start Date: ${plan.startDate.toLocal()}'.split(' ')[0],
              style: const TextStyle(color: Colors.grey),
            ),
            Text(
              'End Date: ${plan.endDate.toLocal()}'.split(' ')[0],
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            const Text(
              'Description',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(plan.description),
            const SizedBox(height: 16),
            const Text(
              'Goals',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(plan.goals),
            const SizedBox(height: 20),
            const Text(
              'Care Tasks',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 12),
            ...plan.tasks.map((task) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.shade100,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.description,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Due: ${task.dueDate.toLocal()}'.split(' ')[0],
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Text(
                        'Priority: ${task.priority}',
                        style: TextStyle(
                          color: task.priority == 'High'
                              ? Colors.red
                              : (task.priority == 'Medium'
                                    ? Colors.orange
                                    : Colors.green),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}