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
    final labSample = result['labSample'] as Map<String, dynamic>? ?? {};
    final testType = labSample['testType'] as Map<String, dynamic>? ?? {};
    final extractedData =
        result['extractedData'] as Map<String, dynamic>? ?? {};

    final Map<String, String> extractedDetails = {};
    extractedData.forEach((key, value) {
      if (value is Map<String, dynamic> && value.containsKey('value')) {
        final val = value['value'] ?? '';
        final unit = value['unit'] ?? '';
        extractedDetails[key] = '$val ${unit.toString()}'.trim();
      } else {
        extractedDetails[key] = value.toString();
      }
    });

    DateTime date =
        DateTime.tryParse(result['createdAt'] ?? '') ?? DateTime.now();
    final fileName =
        '${testType['label'] ?? 'Unknown'}_${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}.pdf';

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

  factory LabReport.fromSample(Map<String, dynamic> sample) {
    final testType = sample['testType'] as Map<String, dynamic>? ?? {};
    final Map<String, String> extractedDetails = {
      'Sample Type': sample['sampleType'] ?? 'N/A',
      'Volume': sample['volume'] ?? 'N/A',
      'Container': sample['container'] ?? 'N/A',
      'Priority': sample['priority'] ?? 'N/A',
      'Notes': sample['notes'] ?? 'N/A',
    };

    DateTime date =
        DateTime.tryParse(sample['createdAt'] ?? '') ?? DateTime.now();
    final fileName =
        '${testType['label'] ?? 'Unknown'}_${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}.pdf';

    return LabReport(
      id: sample['id'] as int?,
      date: date,
      fileName: fileName,
      extractedDetails: extractedDetails,
      reportUrl: null,
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