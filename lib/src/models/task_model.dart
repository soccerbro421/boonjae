import 'package:boonjae/src/models/habit_model.dart';

class Task {
  final int taskId;
  final String dayOfWeek;
  final HabitModel habit;
  final String status;

  const Task({
    required this.taskId,
    required this.dayOfWeek,
    required this.habit,
    required this.status,
  });
}