import 'dart:typed_data';

import 'package:boonjae/src/models/habit_model.dart';
import 'package:boonjae/src/providers/habits_provider.dart';
import 'package:boonjae/src/services/habits_service.dart';
import 'package:boonjae/src/services/image_service.dart';
import 'package:boonjae/src/ui/auth/auth_text_field_input.dart';
import 'package:boonjae/src/ui/mobile_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:weekday_selector/weekday_selector.dart';

class AddHabitView extends StatefulWidget {
  const AddHabitView({
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _AddHabitView();
  }
}

class _AddHabitView extends State<AddHabitView> {
  // final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  Uint8List? _image;
  bool _isLoading = false;
  int _index = 0;
  final values = <bool>[false, false, false, false, false, false, false];

  @override
  void dispose() {
    // _emailController.dispose();
    // _passwordController.dispose();
    _descriptionController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  showSnackBar(String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
      ),
    );
  }

  void createHabit() async {
    List<HabitModel> habits =
        Provider.of<HabitsProvider>(context, listen: false).getHabits;
    int order = habits.length;

    setState(() {
      _isLoading = true;
    });

    String res = await HabitsService().addHabit(
      name: _nameController.text,
      description: _descriptionController.text,
      file: _image,
      daysOfWeek: values,
      order: order,
    );

    setState(() {
      _isLoading = false;
    });

    if (res != 'success') {
      clearSnack();

      showSnackBar(res);
    } else {
      goHome();
    }
  }

  clearSnack() {
    ScaffoldMessenger.of(context).clearSnackBars();
  }

  goHome() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const MobileView(),
      ),
      (Route<dynamic> route) => false,
    );
  }

  showDialogMessage() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Access issue D:"),
          content: const Text('Please allow access to photos in settings'),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                openAppSettings();
              },
              child: const Text("Go to settings"),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void selectImage() async {
    final im = await ImageService().pickMedia();

    if (im is String) {
      showDialogMessage();
      return;
    }

    if (im != null) {
      setState(() {
        _image = im;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
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
                  if (_index < 3) {
                    setState(() {
                      _index += 1;
                    });
                  } else if (_index == 3) {
                    createHabit();
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
                                : Text(_index == 3 ? 'ADD' : 'NEXT'),
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
                    content: Column(
                      children: [
                        TextFieldInput(
                          textEditingController: _nameController,
                          hintText: 'Enter habit name',
                          textInputType: TextInputType.text,
                        ),
                        const SizedBox(height: 16),
                        TextFieldInput(
                          textEditingController: _descriptionController,
                          hintText: 'Enter habit description',
                          textInputType: TextInputType.text,
                        ),
                      ],
                    ),
                  ),
                  Step(
                    title: const Text('Days of week'),
                    content: Column(
                      children: [
                        WeekdaySelector(
                          fillColor: Colors.black26,
                          onChanged: (int day) {
                            setState(() {
                              values[day % 7] = !values[day % 7];
                            });
                          },
                          values: values,
                          firstDayOfWeek: 0,
                        )
                      ],
                    ),
                  ),
                  Step(
                    title: const Text('Cover Photo'),
                    content: Stack(
                      children: [
                        InkWell(
                          onTap: selectImage,
                          child: SizedBox(
                            height: 150,
                            width: 150,
                            // child: Image.network(habit.photoUrl, fit: BoxFit.cover),
        
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: _image != null
                                  ? Image.memory(_image!)
                                  : Image.asset('assets/images/icon.png'),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -10,
                          left: 110,
                          child: IconButton(
                            onPressed: selectImage,
                            icon: const Icon(Icons.add_a_photo),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Step(
                    title: const Text('Submit'),
                    content: Container(),
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
