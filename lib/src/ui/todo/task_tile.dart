import 'package:boonjae/src/db/tasks_database.dart';
import 'package:boonjae/src/models/habit_model.dart';
import 'package:boonjae/src/models/task_model.dart';
import 'package:boonjae/src/providers/habits_provider.dart';
import 'package:boonjae/src/ui/todo/task_map_detailed.dart';
// import 'package:boonjae/src/ui/widgets/task_heat_map_calendar.dart';
// import 'package:boonjae/src/ui/todo/task_details_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    ScaffoldMessenger.of(context).clearSnackBars();

    TaskModel taskCopy = widget.task;
    if (boool == true) {
      taskCopy.status = "COMPLETED";
      setState(() {
        isChecked = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Center(
        child: Text(
          '( ノ ^o^)ノ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      )));
    } else {
      taskCopy.status = "NOTCOMPLETED";
      setState(() {
        isChecked = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Center(
              child: Text(
        '┬┴┬┴┤(･_ ├┬┴┬┴',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ))));
    }

    await TasksDatabase.instance.update(taskCopy);
  }

  void navigateToTaskDetailsView(BuildContext context, TaskModel task) {
    HabitsProvider habitsProvider = Provider.of(context, listen: false);
    List<HabitModel> habits = habitsProvider.getHabits;
    HabitModel habit = habits.firstWhere(
      (habit) => habit.habitId == task.habitId,
      orElse: () => throw Exception('Habit with id ${task.habitId} not found'),
    );

    // showDialog(context: context, builder: (context) => AlertDialog(
    //   actions: [
    //     TextButton(onPressed: () {
    //       Navigator.of(context).pop();
    //     }, child: const Text('close'))
    //   ],
    //   content: Container(
    //   width: MediaQuery.of(context).size.width ,
    //   height: MediaQuery.of(context).size.height / 2, // Set width to 80% of screen width
    //   child: TaskHeatMapCalendar(habit: habit),
    // ),
    // ));
    // return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TaskMapDetailed(
          habit: habit,
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
          // navigateToTaskDetailsView(context, widget.task);
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
              color: isChecked
                  ? const Color.fromARGB(120, 0, 255, 0)
                  : const Color.fromARGB(0, 0, 0, 0),
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
