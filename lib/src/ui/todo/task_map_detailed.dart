import 'package:boonjae/src/db/tasks_database.dart';
import 'package:boonjae/src/models/habit_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class TaskMapDetailed extends StatelessWidget {
  final HabitModel habit;

  const TaskMapDetailed({
    super.key,
    required this.habit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress'),
      ),
      body: FutureBuilder<Map<DateTime, int>>(
        future: TasksDatabase.instance.getAllTasksByCurrentUserAndHabit(
          habitId: habit.habitId,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final taskCounts = snapshot.data!;

            DateTime currentDate = DateTime.now();

// Calculate the date one year ago from today
            DateTime oneYearAgo = currentDate.subtract(const Duration(days: 365));

// Use a ternary operator to set the startDate
            DateTime startDate = habit.createdDate.isAfter(oneYearAgo)
                ? habit.createdDate
                : oneYearAgo;

            return Center(
            //   child: 
            // HeatMapCalendar(
            //   datasets: taskCounts,
            //   size: 50,
            //   defaultColor: const Color.fromARGB(255, 77, 77, 77),
            //   colorsets: const {
            //     1: Color.fromARGB(70, 2, 179, 8),
            //     2: Color.fromARGB(80, 2, 179, 8),
            //     3: Color.fromARGB(90, 2, 179, 8),
            //     4: Color.fromARGB(100, 2, 179, 8),
            //   },
            // ),
              child: HeatMap(
                datasets: taskCounts,
                startDate: startDate,
                colorMode: ColorMode.opacity,
                showText: true,
                defaultColor: const Color.fromARGB(255, 77, 77, 77),
                scrollable: true,
                showColorTip: false,
                size: 50,
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
      ),
    );
  }
}
