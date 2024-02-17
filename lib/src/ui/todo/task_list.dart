import 'package:boonjae/src/models/task_model.dart';
import 'package:boonjae/src/ui/todo/task_tile.dart';
import 'package:flutter/material.dart';

class TaskList extends StatelessWidget {
  final List<TaskModel> tasks;
  final Future Function() refreshPage;
  final void Function(TaskModel) removeTask;

  const TaskList({
    super.key,
    required this.tasks,
    required this.refreshPage,
    required this.removeTask,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshPage,
      child: tasks.isNotEmpty
          ? ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) => Dismissible(
                key: ValueKey(tasks[index]),
                background: Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                  color: Colors.red,
                  child: const Row(
                    children: [Spacer(), Icon(Icons.delete)],
                  ),
                ),
                onDismissed: (direction) {
                  removeTask(tasks[index]);
                },
                child: TaskTile(task: tasks[index]),
              ),
            )
          : ListView(
              children: const [
                SizedBox(
                  height: 50,
                ),
                Center(
                  child: Text(
                      'no tasks for today! \n(plz pull down to refresh if no tasks for the week)'),
                ),
              ],
            ),
    );
  }
}
