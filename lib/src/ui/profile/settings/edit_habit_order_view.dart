import 'package:boonjae/src/models/habit_model.dart';
import 'package:boonjae/src/services/habits_service.dart';
import 'package:flutter/material.dart';

class EditHabitOrderView extends StatefulWidget {
  final List<HabitModel> habits;

  const EditHabitOrderView({
    Key? key,
    required this.habits,
  }) : super(key: key);

  @override
  State<EditHabitOrderView> createState() => _EditHabitOrderViewState();
}

class _EditHabitOrderViewState extends State<EditHabitOrderView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Habit Order'),
        actions: [
          ElevatedButton(
            onPressed: () {
              // Handle save button click
              saveHabitOrder();
            },
            child: const Text("Save"),
          ),
        ],
      ),
      body: ReorderableListView(
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final HabitModel movedHabit = widget.habits.removeAt(oldIndex);
            widget.habits.insert(newIndex, movedHabit);
          });
        },
        children: widget.habits
            .map(
              (habit) => Padding(
                key: Key(habit.habitId), // Ensure each Padding has a unique key
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Container(
                    color: const Color.fromARGB(
                        255, 66, 66, 66), // Adjust the tile color as needed
                    child: ListTile(
                      title: Text(
                        habit.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      leading: const Icon(Icons.drag_handle),
                      // Add any other habit information you want to display
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  void saveHabitOrder() async {
    String res = await HabitsService().saveHabitOrder(habits: widget.habits);
    showSnackBar(res);
  }

  showSnackBar(String res) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(res)),
    );
  }
}
