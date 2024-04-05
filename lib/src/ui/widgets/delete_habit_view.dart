import 'package:boonjae/src/models/habit_model.dart';
import 'package:boonjae/src/services/habits_service.dart';
import 'package:boonjae/src/ui/mobile_view.dart';
import 'package:flutter/material.dart';

class DeleteHabitView extends StatelessWidget {
  final HabitModel habit;
  const DeleteHabitView({
    super.key,
    required this.habit,
  });

  void deleteHabit(BuildContext context) {
    HabitsService().deleteHabit(habit: habit);

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
        title: const Text('Delete Habit'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Are you sure you want to delete this habit ?'),
          const SizedBox(height: 30),
          Center(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              child: const Text('Delete Habit'),
              onPressed: () {
                deleteHabit(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
