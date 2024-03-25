import 'package:boonjae/src/models/group_habit_model.dart';
import 'package:boonjae/src/models/user_model.dart';
import 'package:boonjae/src/services/user_service.dart';
import 'package:boonjae/src/ui/widgets/group_habit_settings.dart';
import 'package:boonjae/src/ui/widgets/group_habit_cover.dart';
import 'package:boonjae/src/ui/widgets/group_habit_post_grid.dart';
import 'package:flutter/material.dart';

class GroupHabitView extends StatelessWidget {
  final GroupHabitModel habit;
  final UserModel user;

  const GroupHabitView({
    super.key,
    required this.habit,
    required this.user,
  });

  void navigateToHabitSettings(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GroupHabitSettings(
          groupHabit: habit,
        ),
        // HabitSettingsView(habit: habit),
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
          isCurrentUser()
              ? IconButton(
                  onPressed: () {
                    navigateToHabitSettings(context);
                  },
                  icon: const Icon(Icons.more_horiz_sharp),
                )
              : const Text(''),
        ],
      ),
      body: CustomScrollView(slivers: [
        GroupHabitCover(
          habit: habit,
        ),
        GroupHabitPostsGridView(
          habit: habit,
          user: user,
          isCurrentUser: isCurrentUser(),
        ),
      ]),
    );
  }
}
