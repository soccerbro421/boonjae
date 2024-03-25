import 'dart:typed_data';

import 'package:boonjae/src/models/group_habit_model.dart';
import 'package:boonjae/src/services/habits_service.dart';
import 'package:boonjae/src/services/image_service.dart';
import 'package:boonjae/src/ui/auth/auth_text_field_input.dart';
import 'package:boonjae/src/ui/mobile_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class EditGroupHabitView extends StatefulWidget {

  final GroupHabitModel groupHabit;

  const EditGroupHabitView({super.key, required this.groupHabit,});

  @override
  State<EditGroupHabitView> createState() => _EditGroupHabitViewState();
}

class _EditGroupHabitViewState extends State<EditGroupHabitView> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  Uint8List? _image;
  bool _isLoading = false;
  int _index = 0;

  @override
  void initState() {
    _descriptionController.text = widget.groupHabit.description;
    _nameController.text = widget.groupHabit.name;
    super.initState();
  }
  @override
  void dispose() {
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

  void updateHabit() async {
    setState(() {
      _isLoading = true;
    });

    String res = await HabitsService().updateGroupHabit(
      name: _nameController.text,
      description: _descriptionController.text,
      file: _image,
      oldHabit: widget.groupHabit,
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

  void selectImage() async {
    final im = await ImageService().pickMedia();

    if (im != null) {
      setState(() {
        _image = im;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Edit habit'),
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
                    updateHabit();
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
                                : Text(_index == 2 ? 'UPDATE' : 'NEXT'),
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
                    title: const Text('Cover Photo'),
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
                                      : CachedNetworkImage(
                                          imageUrl: widget.groupHabit.photoUrl,
                                          fit: BoxFit.cover,
                                          key: UniqueKey(),
                                          placeholder: (context, url) =>
                                              const Text(''),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.person),
                                        ),
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
                    title: const Text('Submit'),
                    content: Container(),
                    // Text(
                    //     'note: please refresh your profile page after update'),
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