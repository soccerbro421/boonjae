import 'package:boonjae/src/models/task_model.dart';
import 'package:flutter/material.dart';

class TaskDetailsView extends StatelessWidget {
  final TaskModel task;

  const TaskDetailsView({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('task for ${task.habitName}'),
      ),
      body: const Center(
        child: Text('hi'),
      ),
    );
  }
}
