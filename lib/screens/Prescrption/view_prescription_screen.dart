import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/prescription.dart';

class PrescriptionDetailScreen extends StatelessWidget {
  final Prescription p;

  const PrescriptionDetailScreen({super.key, required this.p});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0D9488);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Prescription Details'),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor Info
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: p.doctorPhoto.isNotEmpty
                      ? NetworkImage(p.doctorPhoto)
                      : const AssetImage('assets/default_doctor.jpg')
                            as ImageProvider,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.doctorName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      p.doctorPosition,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  '${p.date.toLocal()}'.split(' ')[0],
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Medicines',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: p.medicines.length,
                itemBuilder: (context, index) {
                  final m = p.medicines[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          m.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Dosage: ${m.dosage}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          'Frequency: ${m.frequency}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          'Duration: ${m.duration}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          'Instructions: ${m.instructions}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}