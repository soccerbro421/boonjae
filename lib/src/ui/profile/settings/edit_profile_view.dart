import 'dart:typed_data';

import 'package:boonjae/src/models/user_model.dart';
import 'package:boonjae/src/services/image_service.dart';
import 'package:boonjae/src/services/user_service.dart';
import 'package:boonjae/src/ui/auth/auth_text_field_input.dart';
import 'package:boonjae/src/ui/mobile_view.dart';
import 'package:flutter/material.dart';

class EditProfileView extends StatefulWidget {
  final UserModel user;

  const EditProfileView({
    super.key,
    required this.user,
  });

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  Uint8List? _image;
  bool _isLoading = false;
  int _index = 0;

  @override
  void initState() {
    _usernameController.text = widget.user.username;
    _bioController.text = widget.user.bio;
    _nameController.text = widget.user.name;
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _bioController.dispose();
    _nameController.dispose();
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

  void updateUser() async {
    setState(() {
      _isLoading = true;
    });

    String res = await UserService().updateUser(
      username: _usernameController.text,
      bio: _bioController.text,
      name: _nameController.text,
      file: _image,
    );

    setState(() {
      _isLoading = false;
    });

    if (res != 'success') {
      showSnackBar(res);
    } else {
      goHome();
    }
  }

  goHome() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const MobileView(),
      ),
      (Route<dynamic> route) => false,
    );
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
        title: const Text('Update Profile'),
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
                  if (_index < 3) {
                    setState(() {
                      _index += 1;
                    });
                  } else if (_index == 3) {
                    updateUser();
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
                                : Text(_index == 3 ? 'UPDATE' : 'NEXT'),
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
                    title: const Text('Login info'),
                    content: Column(
                      children: [
                        TextFieldInput(
                          textEditingController: _usernameController,
                          hintText: 'Enter your username',
                          textInputType: TextInputType.text,
                        ),
                      ],
                    ),
                  ),
                  Step(
                    title: const Text('About you'),
                    content: Column(
                      children: [
                        TextFieldInput(
                          textEditingController: _nameController,
                          hintText: 'Enter your name',
                          textInputType: TextInputType.text,
                        ),
                        const SizedBox(height: 16),
                        TextFieldInput(
                          textEditingController: _bioController,
                          hintText: 'Enter a lil bio',
                          textInputType: TextInputType.text,
                        ),
                      ],
                    ),
                  ),
                  Step(
                    title: const Text('Profile pic (optional)'),
                    content: Column(
                      children: [
                        const Text(
                            'note: if new pic not provided, will not update current profile pic'),
                        const SizedBox(height: 20),
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
                              left: 80,
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
