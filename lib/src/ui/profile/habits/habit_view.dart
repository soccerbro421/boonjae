import 'package:boonjae/src/models/habit_model.dart';
import 'package:boonjae/src/ui/profile/habits/habit_cover.dart';
import 'package:boonjae/src/ui/profile/habits/habit_settings_view.dart';
import 'package:boonjae/src/ui/profile/habits/posts_grid_view.dart';
import 'package:flutter/material.dart';

class HabitView extends StatelessWidget {
  final HabitModel habit;

  const HabitView({
    super.key,
    required this.habit,
  });

  void navigateToHabitSettings(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => HabitSettingsView(habit: habit),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(habit.name),
        actions: [
          IconButton(
              onPressed: () {
                navigateToHabitSettings(context);
              },
              icon: const Icon(Icons.more_horiz_sharp),
            ),
        ],
      ),
      
      body: CustomScrollView(slivers: [
        HabitCover(
          habit: habit,
        ),
        PostsGridView(
          habit: habit,
        ),
      ]),
    );
  }
}
