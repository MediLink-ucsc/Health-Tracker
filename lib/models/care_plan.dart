class CareTask {
  final String description;
  final DateTime dueDate;
  final String priority;

  CareTask({
    required this.description,
    required this.dueDate,
    required this.priority,
  });

  factory CareTask.fromJson(Map<String, dynamic> json) {
    return CareTask(
      description: (json['description'] ?? '').toString(),
      dueDate: DateTime.tryParse(json['dueDate'] ?? '') ?? DateTime.now(),
      priority: (json['priority'] ?? 'Low').toString(),
    );
  }
}

class CarePlan {
  final String id;
  final String planType;
  final String priority;
  final DateTime startDate;
  final DateTime endDate;
  final String description;
  final String goals;
  final List<CareTask> tasks;

  CarePlan({
    required this.id,
    required this.planType,
    required this.priority,
    required this.startDate,
    required this.endDate,
    required this.description,
    required this.goals,
    required this.tasks,
  });

  factory CarePlan.fromJson(Map<String, dynamic> json) {
    final tasksData = json['tasks'] as List<dynamic>? ?? [];
    final tasks = tasksData.map((t) => CareTask.fromJson(t)).toList();

    return CarePlan(
      id: (json['carePlanId'] ?? '').toString(),
      planType: (json['planType'] ?? 'Care Plan').toString(),
      priority: (json['priority'] ?? 'Low').toString(),
      startDate: DateTime.tryParse(json['startDate'] ?? '') ?? DateTime.now(),
      endDate: DateTime.tryParse(json['endDate'] ?? '') ?? DateTime.now(),
      description: (json['description'] ?? '').toString(),
      goals: (json['goals'] ?? '').toString(),
      tasks: tasks,
    );
  }
}