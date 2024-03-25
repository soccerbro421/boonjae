import 'package:boonjae/src/ui/profile/habits/add_group_habit_view.dart';
import 'package:boonjae/src/ui/profile/habits/add_habit_view.dart';
import 'package:flutter/material.dart';

class AddHabit extends StatefulWidget {
  const AddHabit({super.key});

  @override
  State<AddHabit> createState() => _AddHabitState();
}

class _AddHabitState extends State<AddHabit> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Habit'),
          bottom: const TabBar(tabs: [
            Tab(text: "Personal Habit"),
            Tab(text: "Group Habit"),
          ])
        ),
        body: const TabBarView(
          children: [
            AddHabitView(),
            AddGroupHabitView(),
          ],
        ),
      ),
    );
  }
}
