import 'dart:typed_data';

import 'package:boonjae/src/models/task_model.dart';
import 'package:boonjae/src/services/habits_service.dart';
import 'package:boonjae/src/services/image_service.dart';
import 'package:boonjae/src/ui/auth/auth_text_field_input.dart';
import 'package:flutter/material.dart';

class TaskDetailsView extends StatefulWidget {
  final TaskModel task;

  const TaskDetailsView({
    super.key,
    required this.task,
  });

  @override
  State<TaskDetailsView> createState() => _TaskDetailsViewState();
}

class _TaskDetailsViewState extends State<TaskDetailsView> {
  final TextEditingController _descriptionController = TextEditingController();

  Uint8List? _image;
  bool _isLoading = false;
  int _index = 0;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void selectImage() async {
    final im = await ImageService().pickMedia();

    if (im != null) {
      setState(() {
        _image = im;
      });
    }
  }

  void createPost() async {
    setState(() {
      _isLoading = true;
    });

    String res = await HabitsService().uploadPost(
      task: widget.task,
      file: _image,
      description: _descriptionController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (res != 'success') {
      showSnackBar(res);
    } else {
      goBack();
    }
  }

  void goBack() {
    Navigator.of(context).pop();
  }

  showSnackBar(String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Create Post'),
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
                    createPost();
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
                                : Text(_index == 2 ? 'UPLOAD' : 'NEXT'),
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
                    title: const Text('Upload pic'),
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
                                      : Image.asset(
                                          'assets/images/flutter_logo.png'),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: -10,
                              left: 110,
                              child: IconButton(
                                onPressed: selectImage,
                                icon: const Icon(Icons.add_a_photo),
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
                  const Step(
                    title: Text('Submit'),
                    content: Text('note: refresh after submitting'),
                    // content: Stack(
                    //   children: [const Text('submit')],
                    // ),
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
