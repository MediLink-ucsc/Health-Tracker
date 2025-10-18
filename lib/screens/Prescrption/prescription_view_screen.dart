import 'package:flutter/material.dart';
import '../../Components/custom_bottom_nav.dart';
import '../../Components/logout.dart';

// Data Models
class Prescription {
  final String doctorName;
  final String doctorPosition;
  final String doctorPhoto;
  final DateTime date;
  final List<Medicine> medicines;

  Prescription({
    required this.doctorName,
    required this.doctorPosition,
    required this.doctorPhoto,
    required this.date,
    required this.medicines,
  });
}

class Medicine {
  final String name;
  final String dosage;
  final String duration;
  final String frequency;
  final String instructions;

  Medicine({
    required this.name,
    required this.dosage,
    required this.duration,
    required this.frequency,
    required this.instructions,
  });
}

// 1️⃣ Prescription List Screen
class PrescriptionListScreen extends StatelessWidget {
  PrescriptionListScreen({super.key});

  final List<Prescription> _prescriptions = [
    Prescription(
      doctorName: 'Dr. Fernando',
      doctorPosition: 'Consultant Physician',
      doctorPhoto: 'assets/doctor1.jpg',
      date: DateTime.now().subtract(const Duration(days: 1)),
      medicines: [
        Medicine(
          name: 'Paracetamol',
          dosage: '500mg',
          duration: '5 days',
          frequency: '3 times/day',
          instructions: 'After meals',
        ),
        Medicine(
          name: 'Amoxicillin',
          dosage: '250mg',
          duration: '7 days',
          frequency: '2 times/day',
          instructions: 'Before meals',
        ),
      ],
    ),
    Prescription(
      doctorName: 'Dr. Silva',
      doctorPosition: 'General Practitioner',
      doctorPhoto: 'assets/doctor2.jpg',
      date: DateTime.now().subtract(const Duration(days: 3)),
      medicines: [
        Medicine(
          name: 'Ibuprofen',
          dosage: '400mg',
          duration: '3 days',
          frequency: '2 times/day',
          instructions: 'After meals',
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0D9488);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Prescriptions'),
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
        itemCount: _prescriptions.length,
        itemBuilder: (context, index) {
          final p = _prescriptions[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: CircleAvatar(
                radius: 28,
                backgroundImage: AssetImage(p.doctorPhoto),
              ),
              title: Text(
                p.doctorName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${p.date.toLocal()}'.split(' ')[0]),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PrescriptionDetailScreen(prescription: p),
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

// 2️⃣ Prescription Detail Screen
class PrescriptionDetailScreen extends StatelessWidget {
  final Prescription prescription;

  const PrescriptionDetailScreen({super.key, required this.prescription});

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
                  backgroundImage: AssetImage(prescription.doctorPhoto),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      prescription.doctorName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      prescription.doctorPosition,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  '${prescription.date.toLocal()}'.split(' ')[0],
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
                itemCount: prescription.medicines.length,
                itemBuilder: (context, index) {
                  final m = prescription.medicines[index];
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