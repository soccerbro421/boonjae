import 'dart:typed_data';

import 'package:boonjae/src/models/user_model.dart';
import 'package:boonjae/src/services/habits_service.dart';
import 'package:boonjae/src/services/image_service.dart';
import 'package:boonjae/src/ui/auth/auth_text_field_input.dart';
import 'package:boonjae/src/ui/mobile_view.dart';
import 'package:boonjae/src/ui/widgets/add_friends_to_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';


class AddGroupHabitView extends StatefulWidget {
  const AddGroupHabitView({
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _AddGroupHabitView();
  }
}

class _AddGroupHabitView extends State<AddGroupHabitView> {
  // final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  Uint8List? _image;
  bool _isLoading = false;
  int _index = 0;

  List<UserModel> friendsToAdd = [];

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

    setState(() {
      _isLoading = true;
    });

    String res = await HabitsService().addGroupHabit(
      name: _nameController.text,
      description: _descriptionController.text,
      file: _image,
      friendsToAdd: friendsToAdd,
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

  void openModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        return AddFriendsToList(
          addedFriends: friendsToAdd,
          onAddFriends: selectFriends,
        );
      },
    );
  }

  void selectFriends(List<UserModel> users) {
    setState(() {
      friendsToAdd = users;
    });
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
                    title: const Text('Friends to add'),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing:
                                8.0, // Adjust the spacing between items as needed
                            runSpacing:
                                8.0, // Adjust the run spacing (spacing between lines) as needed
                            children: friendsToAdd.map((friend) {
                              return Chip(
                                label: Text(friend.name),
                                // You can customize Chip appearance here if needed
                              );
                            }).toList(),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                openModal();
                              },
                              icon: const Icon(Icons.group_add),
                              label: const Text('Add Friends'),
                            ),
                          ),
                        ],
                      ),
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
