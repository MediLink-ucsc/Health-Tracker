// import 'package:flutter/material.dart';
//
// import '../../Components/custom_bottom_nav.dart';
// import '../../Components/logout.dart';
// import '../../models/lab_report.dart';
//
// // class LabReport {
// //   final DateTime date;
// //   final String fileName;
// //   final Map<String, String> extractedDetails;
// //
// //   LabReport({
// //     required this.date,
// //     required this.fileName,
// //     required this.extractedDetails,
// //   });
// // }
//
// class ViewReportScreen extends StatelessWidget {
//   final LabReport report;
//
//   const ViewReportScreen({super.key, required this.report});
//
//   @override
//   Widget build(BuildContext context) {
//     const primaryColor = Color(0xFF0D9488);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('View Report'),
//         backgroundColor: primaryColor,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             tooltip: 'Logout',
//             onPressed: () {
//               showDialog(
//                 context: context,
//                 builder: (context) => AlertDialog(
//                   title: const Text('Logout'),
//                   content: const Text('Are you sure you want to log out?'),
//                   actions: [
//                     TextButton(
//                       child: const Text('Cancel'),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                     TextButton(
//                       child: const Text('Logout'),
//                       onPressed: () {
//                         Navigator.pop(context);
//                         appLogout(context);
//                       },
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       bottomNavigationBar: CustomBottomNavBar(currentIndex: 1),
//       body: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               report.fileName,
//               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Date: ${report.date.year}-${report.date.month.toString().padLeft(2, '0')}-${report.date.day.toString().padLeft(2, '0')}',
//               style: const TextStyle(color: Colors.grey),
//             ),
//             const SizedBox(height: 16),
//             const Divider(),
//             const SizedBox(height: 16),
//             const Text(
//               'Extracted Details:',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//             ),
//             const SizedBox(height: 8),
//             ...report.extractedDetails.entries.map(
//               (entry) => Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 4),
//                 child: Text('${entry.key}: ${entry.value}'),
//               ),
//             ),
//             const Spacer(),
//             Center(
//               child: ElevatedButton.icon(
//                 onPressed: () {
//                   // In future, open PDF/image viewer
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Viewing the report file not implemented'),
//                     ),
//                   );
//                 },
//                 icon: const Icon(Icons.picture_as_pdf),
//                 label: const Text('Open Report File'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: primaryColor,
//                   padding: const EdgeInsets.symmetric(
//                     vertical: 12,
//                     horizontal: 20,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../Components/custom_bottom_nav.dart';
import '../../Components/logout.dart';
import '../../models/lab_report.dart';

class ViewReportScreen extends StatelessWidget {
  final LabReport report;

  const ViewReportScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0D9488);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab Report'),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to log out?'),
                  actions: [
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    TextButton(
                      child: const Text('Logout'),
                      onPressed: () {
                        Navigator.pop(context);
                        appLogout(context);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              report.fileName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Date: ${DateFormat('yyyy-MM-dd').format(report.date)}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Divider
            const Divider(thickness: 1.2),
            const SizedBox(height: 16),

            // Extracted details as table
            const Text(
              'Test Results:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(1),
                  },
                  border: TableBorder.all(color: Colors.grey, width: 0.5),
                  children: [
                    const TableRow(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Parameter',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Value',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ...report.extractedDetails.entries.map(
                      (entry) => TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(entry.key),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(entry.value),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Viewing the report file not implemented'),
                    ),
                  );
                },
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('Open Report File'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}