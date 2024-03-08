import 'package:boonjae/src/models/task_model.dart';
import 'package:boonjae/src/ui/todo/task_tile.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class TaskList extends StatelessWidget {
  final List<TaskModel> tasks;
  final Future Function() refreshPage;
  final void Function(TaskModel) removeTask;
  final bool noHabits;

  const TaskList({
    super.key,
    required this.tasks,
    required this.refreshPage,
    required this.removeTask,
    required this.noHabits,
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
          : noHabits
              ? ListView(
                  children: const [
                    SizedBox(
                      height: 125.0,
                      child:
                          RiveAnimation.asset('assets/rive/sleepy_lottie.riv'),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        'create a habit on your profile to see tasks !',
                        style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            // fontSize: 18.0, // You can adjust the font size as needed
                            ),
                      ),
                    ),
                  ],
                )
              : ListView(
                  children: const [
                    SizedBox(
                      height: 125.0,
                      child:
                          RiveAnimation.asset('assets/rive/sleepy_lottie.riv'),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        'no tasks for today!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize:
                              18.0, // You can adjust the font size as needed
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text('(refresh if no tasks for the week)'),
                    ),
                  ],
                ),
    );
  }
}
