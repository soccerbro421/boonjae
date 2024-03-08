import 'package:boonjae/src/db/tasks_database.dart';
import 'package:boonjae/src/models/habit_model.dart';
import 'package:boonjae/src/models/task_model.dart';
import 'package:boonjae/src/models/user_model.dart';
import 'package:boonjae/src/providers/habits_provider.dart';
import 'package:boonjae/src/providers/user_provider.dart';
import 'package:boonjae/src/ui/todo/create_task_view.dart';
import 'package:boonjae/src/ui/todo/task_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TodoView extends StatefulWidget {
  const TodoView({super.key});

  @override
  State<TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  final List<String> daysOfWeek = ["S", "M", "T", "W", "T", "F", "S"];
  final List<String> daysOfWeekString = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
  ];
  int currentDayIndex =
      DateTime.now().weekday == 7 ? 0 : DateTime.now().weekday;
  // Subtract 1 to match 0-based index

  late List<List<TaskModel>> tasks = [[], [], [], [], [], [], []];
  bool isLoading = false;
  bool noHabits = true;

  @override
  void initState() {
    super.initState();

    refreshTasks();
  }

  void removeTask(TaskModel task) async {
    await TasksDatabase.instance.delete(task.taskId!);

    setState(() {
      refreshTasks();
    });
  }

  Future refreshTasks() async {
    UserModel user = Provider.of<UserProvider>(context, listen: false).getUser;
    List<HabitModel> habits =
        Provider.of<HabitsProvider>(context, listen: false).getHabits;
    bool anyHab = habits.isEmpty;

    setState(() {
      noHabits = anyHab;
    });

    setState(() {
      isLoading = true;
    });

    tasks = await TasksDatabase.instance.readCurrentWeekTasksByUser(
      user: user,
    );
    int size = 0;
    for (int i = 0; i < tasks.length; i++) {
      size += tasks[i].length;
    }

    if (size == 0) {
      createTasksFromHabits();
    }

    setState(() {
      isLoading = false;
    });
  }

  void createTasksFromHabits() async {
    UserModel user = Provider.of<UserProvider>(context, listen: false).getUser;
    List<HabitModel> habits =
        Provider.of<HabitsProvider>(context, listen: false).getHabits;

    for (int i = 0; i < habits.length; i++) {
      HabitModel habit = habits[i];

      for (int j = 0; j < habit.daysOfWeek.length; j++) {
        if (habit.daysOfWeek[j] == true) {
          TaskModel task = TaskModel(
              userId: user.uid,
              habitId: habit.habitId,
              dayOfWeek: daysOfWeekString[j],
              habitName: habit.name,
              date: DateTime.now(),
              status: "NOTCOMPLETED");

          await TasksDatabase.instance.create(task);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: currentDayIndex,
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('weekly tasks'),
          bottom: const TabBar(tabs: [
            Tab(text: "S"),
            Tab(text: "M"),
            Tab(text: "T"),
            Tab(text: "W"),
            Tab(text: "T"),
            Tab(text: "F"),
            Tab(text: "S"),
          ]),
        ),
        body: TabBarView(
          children: [
            TaskList(
              tasks: tasks[0],
              refreshPage: refreshTasks,
              removeTask: removeTask,
              noHabits: noHabits,
            ),
            TaskList(
              tasks: tasks[1],
              refreshPage: refreshTasks,
              removeTask: removeTask,
              noHabits: noHabits,
            ),
            TaskList(
              tasks: tasks[2],
              refreshPage: refreshTasks,
              removeTask: removeTask,
              noHabits: noHabits,
            ),
            TaskList(
              tasks: tasks[3],
              refreshPage: refreshTasks,
              removeTask: removeTask,
              noHabits: noHabits,
            ),
            TaskList(
              tasks: tasks[4],
              refreshPage: refreshTasks,
              removeTask: removeTask,
              noHabits: noHabits,
            ),
            TaskList(
              tasks: tasks[5],
              refreshPage: refreshTasks,
              removeTask: removeTask,
              noHabits: noHabits,
            ),
            TaskList(
              tasks: tasks[6],
              refreshPage: refreshTasks,
              removeTask: removeTask,
              noHabits: noHabits,
            ),
          ],
        ),
        floatingActionButton: Visibility(
          visible: !noHabits,
          child: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CreateTaskView(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
