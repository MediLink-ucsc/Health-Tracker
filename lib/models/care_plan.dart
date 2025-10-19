class CarePlan {
  final String planType;
  final String priority;
  final DateTime startDate;
  final DateTime endDate;
  final String description;
  final String goals;
  final List<CareTask> tasks;

  CarePlan({
    required this.planType,
    required this.priority,
    required this.startDate,
    required this.endDate,
    required this.description,
    required this.goals,
    required this.tasks,
  });
}

class CareTask {
  final String description;
  final DateTime dueDate;
  final String priority;

  CareTask({
    required this.description,
    required this.dueDate,
    required this.priority,
  });
}