import 'package:flutter/material.dart';
import '../../models/lab_test.dart';

class LabTestDetailScreen extends StatelessWidget {
  final LabTest test;
  const LabTestDetailScreen({super.key, required this.test});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0D9488);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab Test Details'),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: test.doctorPhoto.isNotEmpty
                      ? NetworkImage(test.doctorPhoto)
                      : const AssetImage('assets/default_doctor.jpg')
                            as ImageProvider,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      test.doctorName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      test.doctorPosition.isNotEmpty
                          ? test.doctorPosition
                          : 'Doctor',
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  '${test.date.toLocal()}'.split(' ')[0],
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Lab Test:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(test.testName, style: const TextStyle(fontSize: 16)),
            if (test.notes.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text(
                'Notes:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(test.notes),
            ],
            const SizedBox(height: 12),
            Text(
              'Status: ${test.status}',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}