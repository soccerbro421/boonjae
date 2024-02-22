import 'package:boonjae/src/models/habit_model.dart';
import 'package:boonjae/src/models/user_model.dart';
import 'package:boonjae/src/services/user_service.dart';
import 'package:boonjae/src/ui/profile/habits/habit_cover.dart';
import 'package:boonjae/src/ui/profile/habits/habit_settings_view.dart';
import 'package:boonjae/src/ui/profile/habits/posts_grid_view.dart';
import 'package:flutter/material.dart';

class HabitView extends StatelessWidget {
  final HabitModel habit;
  final UserModel user;

  const HabitView({
    super.key,
    required this.habit,
    required this.user,
  });

  void navigateToHabitSettings(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => HabitSettingsView(habit: habit),
      ),
    );
  }

  bool isCurrentUser() {
    return UserService().isCurrentUser(user: user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(habit.name),
        actions: [
          isCurrentUser() ?
          IconButton(
              onPressed: () {
                navigateToHabitSettings(context);
              },
              icon: const Icon(Icons.more_horiz_sharp),
            ) : const Text(''),
        ],
      ),
      
      body: CustomScrollView(slivers: [
        HabitCover(
          habit: habit,
        ),
        PostsGridView(
          habit: habit,
          user: user,
          isCurrentUser: isCurrentUser(),
        ),
      ]),
    );
  }
}
