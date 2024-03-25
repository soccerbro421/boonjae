import 'package:boonjae/src/models/group_habit_model.dart';
import 'package:boonjae/src/services/habits_service.dart';
import 'package:boonjae/src/ui/mobile_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LeaveGroupHabitView extends StatefulWidget {
  final GroupHabitModel groupHabit;

  const LeaveGroupHabitView({
    super.key,
    required this.groupHabit,
  });

  @override
  State<LeaveGroupHabitView> createState() => _LeaveGroupHabitViewState();
}

class _LeaveGroupHabitViewState extends State<LeaveGroupHabitView> {



  leaveGroup() {

    HabitsService().leaveGroupHabit(habit: widget.groupHabit);

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const MobileView(),
      ),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave group'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Are you sure you want to leave ?'),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: leaveGroup,
              icon: const Icon(Icons.logout),
              label: const Text('Leave'),
            ),
          ],
        ),
      ),
    );
  }
}
