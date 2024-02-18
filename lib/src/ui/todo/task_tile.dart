import 'package:boonjae/src/db/tasks_database.dart';
import 'package:boonjae/src/models/task_model.dart';
import 'package:boonjae/src/ui/todo/task_details_view.dart';
import 'package:flutter/material.dart';

class TaskTile extends StatefulWidget {
  final TaskModel task;

  const TaskTile({
    super.key,
    required this.task,
  });

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  bool isChecked = false;

  @override
  void initState() {
    isChecked = widget.task.status == "COMPLETED";
    super.initState();
  }

  void check(boool) async {
    TaskModel taskCopy = widget.task;
    if (boool == true) {
      taskCopy.status = "COMPLETED";
      setState(() {
        isChecked = true;
      });
      
    } else {
      taskCopy.status = "NOTCOMPLETED";
      setState(() {
        isChecked = false;
      });
    }

    await TasksDatabase.instance.update(taskCopy);
  }

  void navigateToTaskDetailsView(BuildContext context, TaskModel task) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TaskDetailsView(
          task: task,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          navigateToTaskDetailsView(context, widget.task);
        },
        child: SizedBox(
          height: 100,
          child: Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              color: isChecked ? const Color.fromARGB(120, 0, 255, 0) : const Color.fromARGB(0, 0, 0, 0),
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.task.habitName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Checkbox(
                    checkColor: const Color.fromARGB(255, 217, 217, 217),
                    activeColor: const Color.fromARGB(255, 152, 195, 149),
                    value: isChecked,
                    onChanged: (boool) {
                      check(boool);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
