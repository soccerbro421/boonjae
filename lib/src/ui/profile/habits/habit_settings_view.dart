import 'package:boonjae/src/models/habit_model.dart';
import 'package:boonjae/src/ui/profile/habits/edit_habit_view.dart';
import 'package:boonjae/src/ui/widgets/delete_habit_view.dart';
import 'package:boonjae/src/ui/widgets/task_heat_map_calendar.dart';
import 'package:flutter/material.dart';

class HabitSettingsView extends StatelessWidget {
  final HabitModel habit;

  const HabitSettingsView({
    super.key,
    required this.habit,
  });

  void navigateToEditHabitView(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditHabitView(habit: habit),
      ),
    );
  }

  void navigateToDeleteHabitView(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DeleteHabitView(habit: habit),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More'),
        actions: const [],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 25,
          horizontal: 20,
        ),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TaskHeatMapCalendar(
              habit: habit,
            ),
            const SizedBox(height: 32),
            const Divider(
              height: 1,
              thickness: 1,
            ),
            InkWell(
              onTap: () {
                navigateToEditHabitView(context);
              },
              child: const SizedBox(
                width: double.infinity,
                height: 70,
                child: Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(width: 10),
                    Text('Edit Habit'),
                    Spacer(),
                    Icon(Icons.chevron_right)
                  ],
                ),
              ),
            ),
            const Divider(
              height: 1,
              thickness: 1,
            ),
            InkWell(
              onTap: () {
                navigateToDeleteHabitView(context);
              },
              child: const SizedBox(
                width: double.infinity,
                height: 70,
                child: Row(
                  children: [
                    Icon(Icons.delete),
                    SizedBox(width: 10),
                    Text('Delete Habit'),
                    Spacer(),
                    Icon(Icons.chevron_right)
                  ],
                ),
              ),
            ),
            const Divider(
              height: 1,
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }
}
