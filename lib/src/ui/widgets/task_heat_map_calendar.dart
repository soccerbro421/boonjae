import 'package:boonjae/src/models/habit_model.dart';
import 'package:boonjae/src/models/user_model.dart';
import 'package:boonjae/src/services/tasks_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class TaskHeatMapCalendar extends StatelessWidget {
  final HabitModel habit;
  final UserModel user;

  const TaskHeatMapCalendar({
    super.key,
    required this.habit,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<DateTime, int>>(
      // future: TasksDatabase.instance.getAllTasksByCurrentUserAndHabit(
      //   habitId: habit.habitId,
      // ),
      future: TasksService().getTasksByUserAndHabit(
        habit: habit,
        user: user,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final taskCounts = snapshot.data!;

          DateTime currentDate = DateTime.now();

// Calculate the start of the current month
          DateTime startOfMonth =
              DateTime(currentDate.year, currentDate.month, 1);

// Use a ternary operator to set the startDate
          DateTime startDate = habit.createdDate.isAfter(startOfMonth)
              ? habit.createdDate
              : startOfMonth;


          return Center(
            child: HeatMap(
              datasets: taskCounts,
              startDate:
                  DateTime(startDate.year, startDate.month, startDate.day),
              colorMode: ColorMode.opacity,
              // showText: true,
              defaultColor: const Color.fromARGB(255, 77, 77, 77),
              scrollable: true,
              textColor: Theme.of(context).scaffoldBackgroundColor,
              showColorTip: false,
              size: 30,
              colorsets: const {
                1: Color.fromARGB(70, 2, 179, 8),
                2: Color.fromARGB(80, 2, 179, 8),
                3: Color.fromARGB(90, 2, 179, 8),
                4: Color.fromARGB(100, 2, 179, 8),
              },
              onClick: (value) {
                ScaffoldMessenger.of(context).clearSnackBars();
        
                if (taskCounts[value] != null && taskCounts[value]! > 0) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Center(
                          child: Text(
                    '( ノ ^o^)ノ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ))));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Center(
                          child: Text(
                    '┬┴┬┴┤(･_ ├┬┴┬┴',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ))));
                }
              },
            ),
          );
        }
      },
    );
  }
}
