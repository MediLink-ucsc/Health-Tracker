class Prescription {
  final String id;
  final String patientId;
  final String doctorName;
  final String doctorPosition;
  final String doctorPhoto;
  final DateTime date;
  final String instructions;
  final List<Medicine> medicines;

  Prescription({
    required this.id,
    required this.patientId,
    required this.doctorName,
    required this.doctorPosition,
    required this.doctorPhoto,
    required this.date,
    required this.instructions,
    required this.medicines,
  });

  factory Prescription.fromJson(Map<String, dynamic> json) {
    final doctorUser = json['doctor']['user'];
    final doctor = json['doctor'];
    return Prescription(
      id: json['prescriptionId'],
      patientId: json['patientId'],
      doctorName: '${doctorUser['firstName']} ${doctorUser['lastName']}',
      doctorPosition: doctor['specialty'] ?? 'Doctor',
      doctorPhoto: '', // or use some URL if available
      date: DateTime.parse(json['createdAt']),
      instructions: json['additionalInstructions'] ?? '',
      medicines: (json['medications'] as List<dynamic>)
          .map((m) => Medicine.fromJson(m))
          .toList(),
    );
  }
}

class Medicine {
  final String name;
  final String dosage;
  final String frequency;
  final String duration;
  final String instructions;

  Medicine({
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.duration,
    this.instructions = '',
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      name: json['medicineName'],
      dosage: json['dosage'],
      frequency: json['frequency'],
      duration: json['duration'],
    );
  }
}