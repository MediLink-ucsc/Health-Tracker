import 'package:flutter/material.dart';
import 'package:health_tracker/screens/Reports/view_report_screen.dart';
import 'dart:developer' as developer;

import '../../Components/custom_bottom_nav.dart';
import '../../Components/logout.dart';
import '../../models/lab_report.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';

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
        developer.log('=== JWT Token Decoded Successfully ===', name: 'LabReports');
        developer.log('Full decoded data: $userData', name: 'LabReports');
        
        // Log specific fields with better formatting
        userData.forEach((key, value) {
          if (key == 'exp') {
            // Convert expiration timestamp to readable date
            try {
              final expDate = DateTime.fromMillisecondsSinceEpoch(value * 1000);
              developer.log('$key: $value (expires: $expDate)', name: 'LabReports');
            } catch (e) {
              developer.log('$key: $value', name: 'LabReports');
            }
          } else if (key == 'iat') {
            // Convert issued at timestamp to readable date
            try {
              final iatDate = DateTime.fromMillisecondsSinceEpoch(value * 1000);
              developer.log('$key: $value (issued: $iatDate)', name: 'LabReports');
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

  Future<void> _fetchLabReports() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await ApiService.getLabReports(_patientId);

      if (response.success && response.data != null) {
        final List<LabReport> labReports = [];

        // Add completed results (processed lab reports)
        for (final result in response.data!.results) {
          labReports.add(LabReport.fromApiResponse(result));
        }

        // Add samples that don't have results yet (pending, in-progress, etc.)
        for (final sample in response.data!.samples) {
          final sampleMap = sample as Map<String, dynamic>;
          final labResults = sampleMap['labResults'] as List<dynamic>;

          // Only add sample if it doesn't have any results yet
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
          _errorMessage = response.message ?? 'Failed to load lab reports';
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
