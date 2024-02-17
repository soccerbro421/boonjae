const String tableTasks = 'tasks';

class TaskFields {
  static final List<String> values = [
    taskId,
    userId,
    dayOfWeek,
    habitId,
    habitName,
    date,
    status
  ];

  static const String taskId = '_id';
  static const String userId = 'userId';
  static const String dayOfWeek = 'dayOfWeek';
  static const String habitId = 'habitId';
  static const String habitName = 'habitNAme';
  static const String date = 'date';
  static const String status = 'status';
}

class TaskModel {
  final int? taskId;
  final String userId;
  final String dayOfWeek;
  final String habitId;
  final String habitName;
  final DateTime date;
  final String status;

  const TaskModel({
    this.taskId,
    required this.userId,
    required this.habitId,
    required this.dayOfWeek,
    required this.habitName,
    required this.date,
    required this.status,
  });

  static TaskModel fromJson(Map<String, Object?> json) => TaskModel(
        taskId: json[TaskFields.taskId] as int?,
        userId: json[TaskFields.userId] as String,
        habitId: json[TaskFields.habitId] as String,
        dayOfWeek: json[TaskFields.dayOfWeek] as String,
        habitName: json[TaskFields.habitName] as String,
        status: json[TaskFields.status] as String,
        date: DateTime.parse(json[TaskFields.date] as String),
      );

  Map<String, Object?> toJson() => {
        TaskFields.taskId: taskId,
        TaskFields.dayOfWeek: dayOfWeek,
        TaskFields.habitId: habitId,
        TaskFields.habitName: habitName,
        TaskFields.status: status,
        TaskFields.userId: userId,
        TaskFields.date: date.toIso8601String(),
      };

  TaskModel copy({
    int? taskId,
    String? userId,
    String? dayOfWeek,
    String? habitId,
    String? habitName,
    DateTime? date,
    String? status,
  }) =>
      TaskModel(
        taskId: taskId ?? this.taskId,
        userId: userId ?? this.userId,
        dayOfWeek: dayOfWeek ?? this.dayOfWeek,
        habitId: habitId ?? this.habitId,
        habitName: habitName ?? this.habitName,
        date: date ?? this.date,
        status: status ?? this.status,
      );
}
