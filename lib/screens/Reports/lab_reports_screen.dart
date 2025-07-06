import 'package:flutter/material.dart';
import 'package:health_tracker/screens/Reports/view_report_screen.dart';

import '../../Components/custom_bottom_nav.dart';
import '../../models/lab_report.dart';

// class LabReport {
//   final DateTime date;
//   final String fileName;
//   final Map<String, String> extractedDetails;
//
//   LabReport({
//     required this.date,
//     required this.fileName,
//     required this.extractedDetails,
//   });
// }

class LabReportsScreen extends StatelessWidget {
  LabReportsScreen({super.key});

  // Sample data
  final List<LabReport> _reports = [
    LabReport(
      date: DateTime(2025, 7, 6),
      fileName: 'BloodTest_Report.pdf',
      extractedDetails: {
        'Hemoglobin': '13.5 g/dL',
        'WBC': '7000 /mm3',
        'Platelets': '250000 /mm3',
      },
    ),
    LabReport(
      date: DateTime(2025, 7, 3),
      fileName: 'XRay_Chest.jpg',
      extractedDetails: {
        'Observation': 'Mild inflammation in upper lobe',
        'Recommendation': 'Follow-up after 2 weeks',
      },
    ),
    LabReport(
      date: DateTime(2025, 7, 3),
      fileName: 'XRay_Chest.jpg',
      extractedDetails: {
        'Observation': 'Mild inflammation in upper lobe',
        'Recommendation': 'Follow-up after 2 weeks',
      },
    ),
    LabReport(
      date: DateTime(2025, 7, 3),
      fileName: 'XRay_Chest.jpg',
      extractedDetails: {
        'Observation': 'Mild inflammation in upper lobe',
        'Recommendation': 'Follow-up after 2 weeks',
      },
    ),
    LabReport(
      date: DateTime(2025, 7, 3),
      fileName: 'XRay_Chest.jpg',
      extractedDetails: {
        'Observation': 'Mild inflammation in upper lobe',
        'Recommendation': 'Follow-up after 2 weeks',
      },
    ),
    LabReport(
      date: DateTime(2025, 7, 3),
      fileName: 'XRay_Chest.jpg',
      extractedDetails: {
        'Observation': 'Mild inflammation in upper lobe',
        'Recommendation': 'Follow-up after 2 weeks',
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0D9488);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab Reports'),
        backgroundColor: primaryColor,
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 1),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _reports.length,
        itemBuilder: (context, index) {
          final report = _reports[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    report.fileName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Date: ${report.date.year}-${report.date.month.toString().padLeft(2, '0')}-${report.date.day.toString().padLeft(2, '0')}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  ...report.extractedDetails.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text('${entry.key}: ${entry.value}'),
                    );
                  }),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ViewReportScreen(report: report),
                          ),
                        );
                      },
                      icon: const Icon(Icons.visibility),
                      label: const Text('View Report'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}