import 'package:boonjae/src/models/group_habit_model.dart';
import 'package:boonjae/src/ui/profile/settings/settings_card.dart';
import 'package:boonjae/src/ui/widgets/edit_group_habit.dart';
import 'package:boonjae/src/ui/widgets/edit_group_habit_members.dart';
import 'package:boonjae/src/ui/widgets/leave_group_habit.dart';
import 'package:flutter/material.dart';

class GroupHabitSettings extends StatefulWidget {
  final GroupHabitModel groupHabit;

  const GroupHabitSettings({
    super.key,
    required this.groupHabit,
  });

  @override
  State<GroupHabitSettings> createState() => _GroupHabitSettingsState();
}

class _GroupHabitSettingsState extends State<GroupHabitSettings> {
  void navigateToEditHabitView(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditGroupHabitView(
          groupHabit: widget.groupHabit,
        ),
      ),
    );
  }

  void navigateToEditGroupHabitMembersView(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditGroupHabitMembers(
          groupHabit: widget.groupHabit,
        ),
      ),
    );
  }

  void navigateToLeaveGroupHabitView(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LeaveGroupHabitView(
          groupHabit: widget.groupHabit,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Group Habit Settings')),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 25,
          horizontal: 20,
        ),
        child: ListView(
          children: [
            const Divider(
              height: 1,
              thickness: 1,
            ),
            SettingsCard(
              onTap: navigateToEditHabitView,
              text: 'Edit Habit Info',
              icon: const Icon(Icons.info),
            ),
            SettingsCard(
              onTap: navigateToEditGroupHabitMembersView,
              text: 'Edit Members',
              icon: const Icon(Icons.group),
            ),
            SettingsCard(
              onTap: navigateToLeaveGroupHabitView,
              text: 'Leave Group',
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
      ),
    );
  }
}
