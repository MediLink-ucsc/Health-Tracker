class LabReport {
  final DateTime date;
  final String fileName;
  final Map<String, String> extractedDetails;
  final int? id;
  final String? reportUrl;
  final String? testType;
  final String? sampleType;
  final String? status;

  LabReport({
    required this.date,
    required this.fileName,
    required this.extractedDetails,
    this.id,
    this.reportUrl,
    this.testType,
    this.sampleType,
    this.status,
  });

  // Factory constructor to create LabReport from API response
  factory LabReport.fromApiResponse(Map<String, dynamic> result) {
    final labSample = result['labSample'] as Map<String, dynamic>;
    final testType = labSample['testType'] as Map<String, dynamic>;
    final extractedData =
        result['extractedData'] as Map<String, dynamic>? ?? {};

    // Convert extractedData to Map<String, String>
    final Map<String, String> extractedDetails = {};
    extractedData.forEach((key, value) {
      extractedDetails[key] = value.toString();
    });

    // Parse date from createdAt
    DateTime date = DateTime.now();
    try {
      date = DateTime.parse(result['createdAt'] as String);
    } catch (e) {
      // Use current date if parsing fails
      date = DateTime.now();
    }

    // Generate file name from test type and date
    final fileName =
        '${testType['label']}_${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}.pdf';

    return LabReport(
      id: result['id'] as int?,
      date: date,
      fileName: fileName,
      extractedDetails: extractedDetails,
      reportUrl: result['reportUrl'] as String?,
      testType: testType['label'] as String?,
      sampleType: labSample['sampleType'] as String?,
      status: result['status'] as String?,
    );
  }

  // Factory constructor to create LabReport from sample data (for pending/in-progress tests)
  factory LabReport.fromSample(Map<String, dynamic> sample) {
    final testType = sample['testType'] as Map<String, dynamic>;

    // For samples without results, create basic extracted details
    final Map<String, String> extractedDetails = {
      'Sample Type': sample['sampleType'] as String? ?? 'N/A',
      'Volume': sample['volume'] as String? ?? 'N/A',
      'Container': sample['container'] as String? ?? 'N/A',
      'Priority': sample['priority'] as String? ?? 'N/A',
      'Notes': sample['notes'] as String? ?? 'N/A',
    };

    // Parse date from createdAt
    DateTime date = DateTime.now();
    try {
      date = DateTime.parse(sample['createdAt'] as String);
    } catch (e) {
      // Use current date if parsing fails
      date = DateTime.now();
    }

    // Generate file name from test type and date
    final fileName =
        '${testType['label']}_${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}.pdf';

    return LabReport(
      id: sample['id'] as int?,
      date: date,
      fileName: fileName,
      extractedDetails: extractedDetails,
      reportUrl: null, // No report URL for pending samples
      testType: testType['label'] as String?,
      sampleType: sample['sampleType'] as String?,
      status: sample['status'] as String?,
    );
  }
}

// Model for the API response
class LabReportHistoryResponse {
  final bool success;
  final LabReportData? data;
  final String? message;

  LabReportHistoryResponse({required this.success, this.data, this.message});

  factory LabReportHistoryResponse.fromJson(Map<String, dynamic> json) {
    return LabReportHistoryResponse(
      success: json['success'] as bool,
      data: json['data'] != null ? LabReportData.fromJson(json['data']) : null,
      message: json['message'] as String?,
    );
  }
}

class LabReportData {
  final String patient;
  final int totalSamples;
  final int completedTests;
  final List<dynamic> samples;
  final List<Map<String, dynamic>> results;

  LabReportData({
    required this.patient,
    required this.totalSamples,
    required this.completedTests,
    required this.samples,
    required this.results,
  });

  factory LabReportData.fromJson(Map<String, dynamic> json) {
    return LabReportData(
      patient: json['patient'] as String,
      totalSamples: json['totalSamples'] as int,
      completedTests: json['completedTests'] as int,
      samples: json['samples'] as List<dynamic>,
      results: (json['results'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
    );
  }
}
