import 'package:flutter/material.dart';

class ClinicVisitDetailsScreen extends StatelessWidget {
  const ClinicVisitDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0D9488);
    const accentColor = Color(0xFFF1BE26);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clinic Visit Details'),
        backgroundColor: primaryColor,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                'Upcoming Visit',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: const Color(0xFFE0F2F1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.local_hospital, color: accentColor, size: 30),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'General Checkup Clinic',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text('Date: 2025-10-22'),
                            Text('Time: 9:00 AM'),
                            Text('Location: Colombo General Hospital'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Previous Visits',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // Previous visits list
              _ClinicVisitCard(
                clinicName: 'Cardiology Clinic',
                date: '2025-09-15',
                doctor: 'Dr. Perera',
                notes: 'Routine ECG and blood pressure check.',
              ),
              const SizedBox(height: 12),
              _ClinicVisitCard(
                clinicName: 'Dental Clinic',
                date: '2025-08-05',
                doctor: 'Dr. Silva',
                notes: 'Tooth filling and cleaning.',
              ),
              const SizedBox(height: 12),
              _ClinicVisitCard(
                clinicName: 'Eye Clinic',
                date: '2025-06-20',
                doctor: 'Dr. Fernando',
                notes: 'Eye test and new spectacles prescription.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ClinicVisitCard extends StatelessWidget {
  final String clinicName;
  final String date;
  final String doctor;
  final String notes;

  const _ClinicVisitCard({
    required this.clinicName,
    required this.date,
    required this.doctor,
    required this.notes,
  });

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFFF1BE26);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today, color: accentColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  clinicName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Date: $date', style: const TextStyle(fontSize: 14)),
            Text('Doctor: $doctor', style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 4),
            Text(
              'Notes: $notes',
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}