class LabTest {
  final String id;
  final String testName;
  final String doctorName;
  final String doctorPosition;
  final String doctorPhoto;
  final DateTime date;
  final String status;
  final String notes;

  LabTest({
    required this.id,
    required this.testName,
    required this.doctorName,
    required this.doctorPosition,
    required this.doctorPhoto,
    required this.date,
    required this.status,
    required this.notes,
  });

  factory LabTest.fromJson(Map<String, dynamic> json) {
    final id = (json['labOrderId'] ?? json['id'] ?? json['orderId'] ?? '')
        .toString();

    final testName = (json['testName'] ?? json['labTestName'] ?? '').toString();

    String doctorName = '';
    String doctorPosition = '';
    String doctorPhoto = '';

    final doctorObj = json['doctor'];
    if (doctorObj is Map<String, dynamic>) {
      final user = doctorObj['user'];
      if (user is Map<String, dynamic>) {
        final fn = (user['firstName'] ?? '') as String;
        final ln = (user['lastName'] ?? '') as String;
        doctorName = ('$fn $ln').trim();
      }
      doctorPosition = (doctorObj['specialty'] ?? '').toString();
      doctorPhoto = (doctorObj['photo'] ?? '').toString();
    }

    final date = DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now();
    final status = (json['status'] ?? 'Pending').toString();
    final notes = (json['notes'] ?? json['additionalInstructions'] ?? '')
        .toString();

    return LabTest(
      id: id,
      testName: testName.isNotEmpty ? testName : 'Lab Test',
      doctorName: doctorName.isNotEmpty ? doctorName : 'Doctor',
      doctorPosition: doctorPosition,
      doctorPhoto: doctorPhoto,
      date: date,
      status: status,
      notes: notes,
    );
  }
}