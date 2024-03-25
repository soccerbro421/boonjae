import 'package:boonjae/src/models/group_habit_model.dart';
import 'package:boonjae/src/models/user_model.dart';
import 'package:boonjae/src/providers/group_habits_provider.dart';
import 'package:boonjae/src/services/friends_service.dart';
import 'package:boonjae/src/services/habits_service.dart';
import 'package:boonjae/src/ui/widgets/edit_members_group_habit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditGroupHabitMembers extends StatefulWidget {
  final GroupHabitModel groupHabit;
  const EditGroupHabitMembers({
    super.key,
    required this.groupHabit,
  });

  @override
  State<EditGroupHabitMembers> createState() => _EditGroupHabitMembersState();
}

class _EditGroupHabitMembersState extends State<EditGroupHabitMembers> {
  List<UserModel> memberUsers = [];

  @override
  void initState() {
    super.initState();
    fetchMembers();
  }

  void fetchMembers() async {
    List<UserModel> users = await FriendsService().getUsersInHabit(
      groupHabit: widget.groupHabit,
    );

    setState(() {
      memberUsers = users;
    });
  }

  void openModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        return EditMembersGroupHabitView(
          addedFriends: memberUsers,
          onAddFriends: selectFriends,
          groupHabit: widget.groupHabit,
        );
      },
    );
  }

  void selectFriends(List<UserModel> users) async {
    await HabitsService().updateMembersInGroupHabit(
      newUsers: users,
      oldHabit: widget.groupHabit,
    );
    await updateGroupHabit();
    setState(() {
      memberUsers = users;
    });
  }

  updateGroupHabit() async {
    GroupHabitsProvider groupHabitsProvider =
        Provider.of(context, listen: false);
    await groupHabitsProvider.refreshGroupHabits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Members'),
      ),
      body: Center(
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0, top: 24.0),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 8.0, // Adjust the spacing between items as needed
                runSpacing:
                    8.0, // Adjust the run spacing (spacing between lines) as needed
                children: memberUsers.map((friend) {
                  return Chip(
                    label: Text(friend.name),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 70, right: 70),
              child: ElevatedButton.icon(
                onPressed: () {
                  openModal();
                },
                icon: const Icon(Icons.group_add),
                label: const Text('Edit Members'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
