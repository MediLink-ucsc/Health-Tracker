import 'package:flutter/material.dart';
import 'package:health_tracker/screens/Reports/view_report_screen.dart';
import 'dart:developer' as developer;

import 'dart:convert';

import '../../Components/custom_bottom_nav.dart';
import '../../Components/logout.dart';
// import '../../models/lab_report.dart';
import '../../models/lab_report.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';

// class LabReport {
//   final String id;
//   final String fileName;
//   final DateTime date;
//   final String? status;
//   final String? testType;
//   final String? sampleType;
//   final Map<String, String> extractedDetails;
//
//   LabReport({
//     required this.id,
//     required this.fileName,
//     required this.date,
//     this.status,
//     this.testType,
//     this.sampleType,
//     required this.extractedDetails,
//   });
//
//   factory LabReport.fromApiResponse(Map<String, dynamic> json) {
//     final values = <String, String>{};
//     if (json['values'] != null) {
//       for (var val in json['values']) {
//         values[val['name']] = '${val['value']} ${val['unit']}';
//       }
//     }
//     return LabReport(
//       id: json['id'] ?? '',
//       fileName: json['testName'] ?? 'Unknown',
//       date: DateTime.parse(json['reportedDate'] ?? DateTime.now().toString()),
//       status: json['status'],
//       testType: json['testName'],
//       sampleType: null,
//       extractedDetails: values,
//     );
//   }
//
//   factory LabReport.fromSample(Map<String, dynamic> json) {
//     return LabReport(
//       id: json['sampleId'] ?? '',
//       fileName: json['testName'] ?? 'Unknown',
//       date: DateTime.parse(json['collectedDate'] ?? DateTime.now().toString()),
//       status: json['status'],
//       testType: null,
//       sampleType: json['testName'],
//       extractedDetails: {},
//     );
//   }
// }

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

class LabReportsScreen extends StatefulWidget {
  const LabReportsScreen({super.key});

  @override
  State<LabReportsScreen> createState() => _LabReportsScreenState();
}

class _LabReportsScreenState extends State<LabReportsScreen> {
  List<LabReport> _reports = [];
  bool _isLoading = true;
  String? _errorMessage;

  // For now, using a hardcoded patient ID
  // TODO: Replace with actual patient ID from authentication/user session
  final String _patientId = 'PAT001';

  @override
  void initState() {
    super.initState();
    _decodeAndLogToken();
    _fetchLabReports();
  }

  Future<void> _decodeAndLogToken() async {
    try {
      // Get and decode the stored JWT token
      final userData = await AuthService.getCurrentUserData();

      if (userData != null) {
        developer.log(
          '=== JWT Token Decoded Successfully ===',
          name: 'LabReports',
        );
        developer.log('Full decoded data: $userData', name: 'LabReports');

        // Log specific fields with better formatting
        userData.forEach((key, value) {
          if (key == 'exp') {
            // Convert expiration timestamp to readable date
            try {
              final expDate = DateTime.fromMillisecondsSinceEpoch(value * 1000);
              developer.log(
                '$key: $value (expires: $expDate)',
                name: 'LabReports',
              );
            } catch (e) {
              developer.log('$key: $value', name: 'LabReports');
            }
          } else if (key == 'iat') {
            // Convert issued at timestamp to readable date
            try {
              final iatDate = DateTime.fromMillisecondsSinceEpoch(value * 1000);
              developer.log(
                '$key: $value (issued: $iatDate)',
                name: 'LabReports',
              );
            } catch (e) {
              developer.log('$key: $value', name: 'LabReports');
            }
          } else {
            developer.log('$key: $value', name: 'LabReports');
          }
        });

        // Check if token is expired
        final isExpired = await AuthService.isTokenExpired();
        developer.log('Token expired: $isExpired', name: 'LabReports');

        developer.log('=== End JWT Token Data ===', name: 'LabReports');
      } else {
        developer.log('No token found or failed to decode', name: 'LabReports');
      }
    } catch (e) {
      developer.log('Error decoding token: $e', name: 'LabReports');
    }
  }

  // Future<void> _fetchLabReports() async {
  //   setState(() {
  //     _isLoading = true;
  //     _errorMessage = null;
  //   });
  //
  //   try {
  //     final response = await ApiService.getLabReports(_patientId);
  //
  //     if (response.success && response.data != null) {
  //       final List<LabReport> labReports = [];
  //
  //       // Add completed results (processed lab reports)
  //       for (final result in response.data!.results) {
  //         labReports.add(LabReport.fromApiResponse(result));
  //       }
  //
  //       // Add samples that don't have results yet (pending, in-progress, etc.)
  //       for (final sample in response.data!.samples) {
  //         final sampleMap = sample as Map<String, dynamic>;
  //         final labResults = sampleMap['labResults'] as List<dynamic>;
  //
  //         // Only add sample if it doesn't have any results yet
  //         if (labResults.isEmpty) {
  //           labReports.add(LabReport.fromSample(sampleMap));
  //         }
  //       }
  //
  //       setState(() {
  //         _reports = labReports;
  //         _isLoading = false;
  //       });
  //     } else {
  //       setState(() {
  //         _errorMessage = response.message ?? 'Failed to load lab reports';
  //         _isLoading = false;
  //       });
  //     }
  //   } catch (e) {
  //     setState(() {
  //       _errorMessage = 'An error occurred while loading lab reports';
  //       _isLoading = false;
  //     });
  //   }
  // }

  Future<void> _fetchLabReports() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final Map<String, dynamic> response = {
        // paste your full JSON here
        "success": true,
        "data": {
          "patient": "2",
          "totalSamples": 2,
          "completedTests": 1,
          "pendingTests": 1,
          "inProgressTests": 0,
          "failedTests": 0,
          "samples": [
            {
              "id": 1,
              "labId": "1",
              "barcode": "REN-79426",
              "testTypeId": 5,
              "testType": {
                "id": 5,
                "value": "CBC",
                "label": "Complete Blood Count",
                "category": "Hematology",
                "parserClass": "FBCReportParser",
                "parserModule": "parser_fbc_report",
                "reportFieldsJson":
                    "[{\"name\":\"RBC\",\"type\":\"decimal\",\"required\":true,\"unit\":\"x 10^12/L\",\"normalRange\":\"4.5-5.5\"},{\"name\":\"Hemoglobin\",\"type\":\"decimal\",\"required\":true,\"unit\":\"g/dL\",\"normalRange\":\"13.5-17.5\"},{\"name\":\"Hematocrit\",\"type\":\"decimal\",\"required\":true,\"unit\":\"%\",\"normalRange\":\"41-53\"},{\"name\":\"WBC\",\"type\":\"decimal\",\"required\":true,\"unit\":\"x 10^9/L\",\"normalRange\":\"4.0-11.0\"},{\"name\":\"Platelets\",\"type\":\"decimal\",\"required\":true,\"unit\":\"x 10^9/L\",\"normalRange\":\"150-450\"}]",
                "referenceRangesJson":
                    "{\"RBC\":{\"min\":4.5,\"max\":5.5,\"unit\":\"x 10^12/L\",\"normalRange\":\"4.5-5.5\"},\"Hemoglobin\":{\"min\":13.5,\"max\":17.5,\"unit\":\"g/dL\",\"normalRange\":\"13.5-17.5\"},\"Hematocrit\":{\"min\":41,\"max\":53,\"unit\":\"%\",\"normalRange\":\"41-53\"},\"WBC\":{\"min\":4,\"max\":11,\"unit\":\"x 10^9/L\",\"normalRange\":\"4.0-11.0\"},\"Platelets\":{\"min\":150,\"max\":450,\"unit\":\"x 10^9/L\",\"normalRange\":\"150-450\"}}",
                "basicFieldsJson": null,
                "createdAt": "2025-10-17T02:30:13.904Z",
                "updatedAt": "2025-10-17T02:30:13.904Z",
              },
              "sampleType": "Whole Blood",
              "volume": "10ml",
              "container": "EDTA Tube",
              "patientId": "2",
              "labResults": [
                {
                  "id": 1,
                  "labSampleId": 1,
                  "reportUrl":
                      "C:\\Users\\hansajak\\Desktop\\code\\microservices\\MediLink\\services\\lab-report-service\\uploads\\1760688007243.pdf",
                  "encryptedExtractedData":
                      "d8bb4d86a60181a021501cbf25420f6c:7deea7876ce12e8f653310e20f81dc0f:90a08d8235c5c34cb0d6a281b81aa96f51213f87e66b4886e453e4cdd4c1f5ba9f37c55d43a3717c1e396e8facf41c8a4b460c568d5ebc7b64aba8ab48592d32a35d09e656c84e1ce4d1676939148384df398ce0ca5d6bc1fe1d009bfd1dd4dd19f5e7449488486b33180020be325eaa767f2bd652694dd99efc887bdda112e7bc8fea1876a27e3405485cf813360864d778e411a67fa9895d21214abdf556c3d2871d28c49181c9f38e8a20674a64830560d8fe66412e573c1cee9be0aa926be21664fa71fa69fe13cb906a5a4e948e2c86551b53e5d7b5bd4ff0d14c47a503bda5a45252955ba33ed35943281e9e3f39f2a0632640a33e9753c56f509d9fd839ea4503bf29bedd05e461e791d0ff2b843b9abce22f17e04df90c8823bb2396da9b3ab2ce1138601cf69f91f08dc73280e2cf6960350d69fe4278b418fd5a42dad71749c4563efda12abcd34280c6c0e923883fa64a131c6ede633dcf8e16a2600cfd50f04694f3692cd2deeb1f160e72bf08c93fac7e8eca6d88f108b4c2346ed6f55ad071c67306115359f3431efdc020cebaca826c30ca41c01bf1e7a9ae812e3e98c77e5bee7429ceca2c7357f32ccb45601354051fddf13ca0561101d9bc4b3c0614656961426491d56a9218fe57b125c35baa626df8d140ea2216d8edecdfc9da33f4bd9e4f49d3818dff02cf217e61fca6bd2c14bd4d8fe5f1f3ef40fe081bf19b4b872e",
                  "extractedData": {
                    "Laboratory": {
                      "value": "Central Medical Laboratory",
                      "unit": "Laboratory",
                      "status": "normal",
                    },
                    "RBC": {"value": 4.5, "unit": "/L", "status": "normal"},
                    "Hemoglobin": {
                      "value": 13.2,
                      "unit": "g/dL",
                      "status": "normal",
                    },
                    "Hematocrit": {
                      "value": 39.5,
                      "unit": "",
                      "status": "normal",
                    },
                    "WBC": {"value": 7.2, "unit": "/L", "status": "normal"},
                    "MCV": {"value": 88, "unit": "fL", "status": "normal"},
                    "_editMetadata": {
                      "editedAt": "2025-10-17T08:01:00.876Z",
                      "editedBy": "current_user",
                      "notes": "Manual correction by lab operator",
                      "originalEditTimestamp": 1760688060876,
                    },
                  },
                  "createdAt": "2025-10-17T02:30:14.059Z",
                  "status": "manually_edited",
                },
              ],
              "createdAt": "2025-10-17T02:29:39.483Z",
              "expectedTime": "2025-10-17T13:35:00.000Z",
              "updatedAt": "2025-10-17T02:30:14.087Z",
              "status": "completed",
              "priority": "ROUTINE",
              "notes": "",
            },
            {
              "id": 3,
              "labId": "1",
              "barcode": "REN-24958",
              "testTypeId": 4,
              "testType": {
                "id": 4,
                "value": "thyroid_function",
                "label": "Thyroid Function Test",
                "category": "endocrinology",
                "parserClass": "LabReportParser",
                "parserModule": "parser_lab_report",
                "reportFieldsJson":
                    "[{\"name\":\"TSH\",\"type\":\"decimal\",\"required\":true,\"unit\":\"mIU/L\",\"normalRange\":\"0.4-4.0\"},{\"name\":\"Free T4\",\"type\":\"decimal\",\"required\":true,\"unit\":\"ng/dL\",\"normalRange\":\"0.8-1.8\"},{\"name\":\"Free T3\",\"type\":\"decimal\",\"required\":false,\"unit\":\"pg/mL\",\"normalRange\":\"2.3-4.2\"}]",
                "referenceRangesJson":
                    "{\"TSH\":{\"min\":0.4,\"max\":4,\"unit\":\"mIU/L\",\"normalRange\":\"0.4-4.0\"},\"Free T4\":{\"min\":0.8,\"max\":1.8,\"unit\":\"ng/dL\",\"normalRange\":\"0.8-1.8\"},\"Free T3\":{\"min\":2.3,\"max\":4.2,\"unit\":\"pg/mL\",\"normalRange\":\"2.3-4.2\"}}",
                "basicFieldsJson": null,
                "createdAt": "2025-10-17T02:24:09.955Z",
                "updatedAt": "2025-10-17T02:24:09.955Z",
              },
              "sampleType": "Whole Blood",
              "volume": "10ml",
              "container": "EDTA Tube",
              "patientId": "2",
              "labResults": [],
              "createdAt": "2025-10-18T04:22:05.104Z",
              "expectedTime": "2025-10-18T21:22:00.000Z",
              "updatedAt": "2025-10-18T04:22:05.104Z",
              "status": "pending",
              "priority": "URGENT",
              "notes": "",
            },
          ],
          "results": [
            {
              "id": 1,
              "labSampleId": 1,
              "labSample": {
                "id": 1,
                "labId": "1",
                "barcode": "REN-79426",
                "testTypeId": 5,
                "testType": {
                  "id": 5,
                  "value": "CBC",
                  "label": "Complete Blood Count",
                  "category": "Hematology",
                  "parserClass": "FBCReportParser",
                  "parserModule": "parser_fbc_report",
                  "reportFieldsJson":
                      "[{\"name\":\"RBC\",\"type\":\"decimal\",\"required\":true,\"unit\":\"x 10^12/L\",\"normalRange\":\"4.5-5.5\"},{\"name\":\"Hemoglobin\",\"type\":\"decimal\",\"required\":true,\"unit\":\"g/dL\",\"normalRange\":\"13.5-17.5\"},{\"name\":\"Hematocrit\",\"type\":\"decimal\",\"required\":true,\"unit\":\"%\",\"normalRange\":\"41-53\"},{\"name\":\"WBC\",\"type\":\"decimal\",\"required\":true,\"unit\":\"x 10^9/L\",\"normalRange\":\"4.0-11.0\"},{\"name\":\"Platelets\",\"type\":\"decimal\",\"required\":true,\"unit\":\"x 10^9/L\",\"normalRange\":\"150-450\"}]",
                  "referenceRangesJson":
                      "{\"RBC\":{\"min\":4.5,\"max\":5.5,\"unit\":\"x 10^12/L\",\"normalRange\":\"4.5-5.5\"},\"Hemoglobin\":{\"min\":13.5,\"max\":17.5,\"unit\":\"g/dL\",\"normalRange\":\"13.5-17.5\"},\"Hematocrit\":{\"min\":41,\"max\":53,\"unit\":\"%\",\"normalRange\":\"41-53\"},\"WBC\":{\"min\":4,\"max\":11,\"unit\":\"x 10^9/L\",\"normalRange\":\"4.0-11.0\"},\"Platelets\":{\"min\":150,\"max\":450,\"unit\":\"x 10^9/L\",\"normalRange\":\"150-450\"}}",
                  "basicFieldsJson": null,
                  "createdAt": "2025-10-17T02:30:13.904Z",
                  "updatedAt": "2025-10-17T02:30:13.904Z",
                },
                "sampleType": "Whole Blood",
                "volume": "10ml",
                "container": "EDTA Tube",
                "patientId": "2",
                "createdAt": "2025-10-17T02:29:39.483Z",
                "expectedTime": "2025-10-17T13:35:00.000Z",
                "updatedAt": "2025-10-17T02:30:14.087Z",
                "status": "completed",
                "priority": "ROUTINE",
                "notes": "",
              },
              "reportUrl":
                  "C:\\Users\\hansajak\\Desktop\\code\\microservices\\MediLink\\services\\lab-report-service\\uploads\\1760688007243.pdf",
              "encryptedExtractedData":
                  "d8bb4d86a60181a021501cbf25420f6c:7deea7876ce12e8f653310e20f81dc0f:90a08d8235c5c34cb0d6a281b81aa96f51213f87e66b4886e453e4cdd4c1f5ba9f37c55d43a3717c1e396e8facf41c8a4b460c568d5ebc7b64aba8ab48592d32a35d09e656c84e1ce4d1676939148384df398ce0ca5d6bc1fe1d009bfd1dd4dd19f5e7449488486b33180020be325eaa767f2bd652694dd99efc887bdda112e7bc8fea1876a27e3405485cf813360864d778e411a67fa9895d21214abdf556c3d2871d28c49181c9f38e8a20674a64830560d8fe66412e573c1cee9be0aa926be21664fa71fa69fe13cb906a5a4e948e2c86551b53e5d7b5bd4ff0d14c47a503bda5a45252955ba33ed35943281e9e3f39f2a0632640a33e9753c56f509d9fd839ea4503bf29bedd05e461e791d0ff2b843b9abce22f17e04df90c8823bb2396da9b3ab2ce1138601cf69f91f08dc73280e2cf6960350d69fe4278b418fd5a42dad71749c4563efda12abcd34280c6c0e923883fa64a131c6ede633dcf8e16a2600cfd50f04694f3692cd2deeb1f160e72bf08c93fac7e8eca6d88f108b4c2346ed6f55ad071c67306115359f3431efdc020cebaca826c30ca41c01bf1e7a9ae812e3e98c77e5bee7429ceca2c7357f32ccb45601354051fddf13ca0561101d9bc4b3c0614656961426491d56a9218fe57b125c35baa626df8d140ea2216d8edecdfc9da33f4bd9e4f49d3818dff02cf217e61fca6bd2c14bd4d8fe5f1f3ef40fe081bf19b4b872e",
              "extractedData": {
                "Laboratory": {
                  "value": "Central Medical Laboratory",
                  "unit": "Laboratory",
                  "status": "normal",
                },
                "RBC": {"value": 4.5, "unit": "/L", "status": "normal"},
                "Hemoglobin": {
                  "value": 13.2,
                  "unit": "g/dL",
                  "status": "normal",
                },
                "Hematocrit": {"value": 39.5, "unit": "", "status": "normal"},
                "WBC": {"value": 7.2, "unit": "/L", "status": "normal"},
                "MCV": {"value": 88, "unit": "fL", "status": "normal"},
                "_editMetadata": {
                  "editedAt": "2025-10-17T08:01:00.876Z",
                  "editedBy": "current_user",
                  "notes": "Manual correction by lab operator",
                  "originalEditTimestamp": 1760688060876,
                },
              },
              "createdAt": "2025-10-17T02:30:14.059Z",
              "status": "manually_edited",
            },
          ],
        },
        "message": "Patient lab history retrieved successfully",
      };

      final data = response['data'] as Map<String, dynamic>?;

      if ((response['success'] as bool? ?? false) && data != null) {
        final labReports = <LabReport>[];

        // Completed results
        final results = data['results'] as List<dynamic>? ?? [];
        for (final result in results) {
          labReports.add(
            LabReport.fromApiResponse(result as Map<String, dynamic>),
          );
        }

        // Pending samples
        final samples = data['samples'] as List<dynamic>? ?? [];
        for (final sample in samples) {
          final sampleMap = sample as Map<String, dynamic>;
          final labResults = sampleMap['labResults'] as List<dynamic>? ?? [];
          if (labResults.isEmpty) {
            labReports.add(LabReport.fromSample(sampleMap));
          }
        }

        setState(() {
          _reports = labReports;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage =
              response['message'] as String? ?? 'Failed to load lab reports';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred while loading lab reports';
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshReports() async {
    await _fetchLabReports();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0D9488);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab Reports'),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: _refreshReports,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
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
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 64),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _refreshReports,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_reports.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.description_outlined, color: Colors.grey, size: 64),
            SizedBox(height: 16),
            Text(
              'No lab reports found',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshReports,
      child: ListView.builder(
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
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          report.fileName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      if (report.status != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(report.status!),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            report.status!.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Date: ${report.date.year}-${report.date.month.toString().padLeft(2, '0')}-${report.date.day.toString().padLeft(2, '0')}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  if (report.testType != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Test Type: ${report.testType}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                  if (report.sampleType != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Sample Type: ${report.sampleType}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                  const SizedBox(height: 8),
                  // Show a few key extracted details
                  ...report.extractedDetails.entries.take(3).map((entry) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text('${entry.key}: ${entry.value}'),
                    );
                  }),
                  if (report.extractedDetails.length > 3) ...[
                    Text(
                      '... and ${report.extractedDetails.length - 3} more details',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'processed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      case 'in-progress':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}