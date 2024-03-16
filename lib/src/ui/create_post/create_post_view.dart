import 'dart:typed_data';

import 'package:boonjae/src/models/habit_model.dart';
import 'package:boonjae/src/models/user_model.dart';
import 'package:boonjae/src/providers/habits_provider.dart';
import 'package:boonjae/src/providers/user_provider.dart';
import 'package:boonjae/src/services/habits_service.dart';
import 'package:boonjae/src/services/image_service.dart';
import 'package:boonjae/src/ui/auth/auth_text_field_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

class CreatePostTabView extends StatefulWidget {
  const CreatePostTabView({super.key});

  @override
  State<CreatePostTabView> createState() => _CreatePostTabViewState();
}

class _CreatePostTabViewState extends State<CreatePostTabView> {
  bool _isLoading = false;
  int _index = 0;
  List<HabitModel>? habits;
  HabitModel? selectedHabit;

  final TextEditingController _descriptionController = TextEditingController();

  Uint8List? _image;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
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

  showSnackBar(String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
      ),
    );
  }

  void uploadPost() async {
    UserModel user = Provider.of<UserProvider>(context, listen: false).getUser;

    if (_image == null || selectedHabit == null || _descriptionController.text.isEmpty) {
      showSnackBar('Please enter all fields');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String res = await HabitsService().uploadPostFromTab(habit: selectedHabit!, file: _image!, description: _descriptionController.text, user: user);

    showSnackBar(res);


    setState(() {
      _isLoading = false;
    });

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
        title: const Text('Upload Post'),
        actions: const [],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: habits != null && habits!.isEmpty ? 
          ListView(
              children: const [
                SizedBox(
                  height: 125.0,
                  child: RiveAnimation.asset('assets/rive/sleepy_lottie.riv'),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    'create a habit on your profile to post !',
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      // fontSize: 18.0, // You can adjust the font size as needed
                    ),
                  ),
                ),
                
              ],
            )
          
          : Column(
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
                    uploadPost();
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
                                : Text(_index == 3 ? 'UPLOAD' : 'NEXT'),
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
                    title: const Text('Habit'),
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
                    title: const Text('Select pic'),
                    content: Column(
                      children: [
                        Stack(
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
                      ],
                    ),
                  ),
                  Step(
                    title: const Text('Description'),
                    content: Column(
                      children: [
                        TextFieldInput(
                          textEditingController: _descriptionController,
                          hintText: 'Enter a description',
                          textInputType: TextInputType.text,
                        ),
                      ],
                    ),
                  ),
                  Step(
                    title: const Text('Submit'),
                    content: Container(),
                    // Text(
                    //     'note: please refresh your profile page after creation'),
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
