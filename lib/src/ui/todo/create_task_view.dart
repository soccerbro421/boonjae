import 'package:boonjae/src/db/tasks_database.dart';
import 'package:boonjae/src/models/habit_model.dart';
import 'package:boonjae/src/models/task_model.dart';
import 'package:boonjae/src/models/user_model.dart';
import 'package:boonjae/src/providers/habits_provider.dart';
import 'package:boonjae/src/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekday_selector/weekday_selector.dart';

class CreateTaskView extends StatefulWidget {
  const CreateTaskView({super.key});

  @override
  State<CreateTaskView> createState() => _CreateTaskViewState();
}

class _CreateTaskViewState extends State<CreateTaskView> {
  final bool _isLoading = false;
  int _index = 0;
  List<bool> values = [false, false, false, false, false, false, false];
  List<HabitModel>? habits;
  HabitModel? selectedHabit;

  final List<String> daysOfWeek = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
  ];
  showSnackBar(String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
      ),
    );
  }

  void createTask() async {
    UserModel user = Provider.of<UserProvider>(context, listen: false).getUser;

    int indexOfTrue = values.indexOf(true);

    if (indexOfTrue == -1 || selectedHabit == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      showSnackBar('please fill out whole form');
      return;
    }

    DateTime currentDate = DateTime.now();
    DateTime startOfWeek =
        currentDate.subtract(Duration(days: currentDate.weekday));
    DateTime startOfSunday =
        DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);

    startOfWeek = currentDate.weekday == 7
        ? DateTime(currentDate.year, currentDate.month, currentDate.day)
        : startOfSunday;
    DateTime dateToAdd = startOfWeek.add(Duration(days: indexOfTrue));

    TaskModel task = TaskModel(
        userId: user.uid,
        habitId: selectedHabit!.habitId,
        dayOfWeek: daysOfWeek[indexOfTrue],
        habitName: selectedHabit!.name,
        date: dateToAdd,
        status: "NOTCOMPLETED");

    await TasksDatabase.instance.create(task);

    goBack();
  }

  void goBack() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    habits = Provider.of<HabitsProvider>(context).getHabits;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Create task'),
        actions: const [],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            children: [
              Stepper(
                currentStep: _index,
                onStepCancel: _index == 0
                    ? null
                    : () {
                        if (_index > 0) {
                          setState(() {
                            _index -= 1;
                          });
                        }
                      },
                onStepContinue: () {
                  if (_index < 2) {
                    setState(() {
                      _index += 1;
                    });
                  } else if (_index == 2) {
                    createTask();
                  }
                },
                onStepTapped: (idx) {
                  setState(() {
                    _index = idx;
                  });
                },
                controlsBuilder: (context, details) {
                  return Container(
                    margin: const EdgeInsets.only(top: 50),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: details.onStepContinue,
                            child: _isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Text(_index == 2 ? 'ADD TASK' : 'NEXT'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        if (_index != 0)
                          Expanded(
                            child: ElevatedButton(
                              onPressed: details.onStepCancel,
                              child: const Text('BACK'),
                            ),
                          ),
                      ],
                    ),
                  );
                },
                steps: [
                  Step(
                    title: const Text('Habit info'),
                    content: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          DropdownMenu(
                            width: 250,
                            label: const Text('select habit'),
                            onSelected: (selectedValue) {
                              if (selectedValue != null) {
                                setState(() {
                                  selectedHabit = selectedValue;
                                });
                              }
                            },
                            dropdownMenuEntries: habits!.map<DropdownMenuEntry>(
                              (HabitModel habit) {
                                return DropdownMenuEntry(
                                    value: habit, label: habit.name);
                              },
                            ).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Step(
                    title: const Text('Day of week'),
                    content: Column(
                      children: [
                        WeekdaySelector(
                          fillColor: Colors.black26,
                          onChanged: (int day) {
                            setState(() {
                              values = [
                                false,
                                false,
                                false,
                                false,
                                false,
                                false,
                                false
                              ]; // Set all values to false
                              values[day % 7] =
                                  true; // Set the selected index to true
                            });
                          },
                          values: values,
                          firstDayOfWeek: 0,
                        )
                      ],
                    ),
                  ),
                  const Step(
                    title: Text('Submit'),
                    content: Text(
                        'note: please refresh your profile page after creation'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
