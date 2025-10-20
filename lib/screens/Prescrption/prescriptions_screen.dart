import 'package:flutter/material.dart';
import '../../Components/custom_bottom_nav.dart';
import '../../Components/logout.dart';
import '../../models/prescription.dart';
import '../../services/prescription_service.dart';

// 1️⃣ Prescription List Screen
class PrescriptionListScreen extends StatefulWidget {
  const PrescriptionListScreen({super.key});

  @override
  State<PrescriptionListScreen> createState() => _PrescriptionListScreenState();
}

class _PrescriptionListScreenState extends State<PrescriptionListScreen> {
  late Future<List<Prescription>> _futurePrescriptions;

  @override
  void initState() {
    super.initState();
    _futurePrescriptions = PrescriptionService.getPrescriptions();
  }

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
      body: FutureBuilder<List<Prescription>>(
        future: _futurePrescriptions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('❌ ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No prescriptions found.'));
          }

          final prescriptions = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: prescriptions.length,
            itemBuilder: (context, index) {
              final p = prescriptions[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundImage: p.doctorPhoto.isNotEmpty
                        ? NetworkImage(p.doctorPhoto)
                        : const AssetImage('assets/default_doctor.jpg')
                              as ImageProvider,
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
                        builder: (_) => PrescriptionDetailScreen(p: p),
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

// 2️⃣ Prescription Detail Screen
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