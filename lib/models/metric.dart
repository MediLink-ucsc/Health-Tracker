class Metric {
  final DateTime date;
  final double weight;
  final double sugarLevel;
  final double waterIntake;

  Metric({
    required this.date,
    required this.weight,
    required this.sugarLevel,
    required this.waterIntake,
  });

  factory Metric.fromJson(Map<String, dynamic> json) {
    return Metric(
      date: DateTime.parse(json['date']),
      weight: (json['weight'] ?? 0).toDouble(),
      sugarLevel: (json['sugarLevel'] ?? 0).toDouble(),
      waterIntake: (json['waterIntake'] ?? 0).toDouble(),
    );
  }
}