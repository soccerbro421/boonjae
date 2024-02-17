import 'dart:typed_data';

import 'package:boonjae/src/services/auth_service.dart';
import 'package:boonjae/src/services/image_service.dart';
import 'package:boonjae/src/ui/auth/auth_text_field_input.dart';
import 'package:boonjae/src/ui/auth/login_screen.dart';
import 'package:boonjae/src/ui/mobile_view.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _SignUpScreenState();
  }
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  // final TextEditingController _phoneNumberController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;
  int _index = 0;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _nameController.dispose();
    // _phoneNumberController.dispose();
    super.dispose();
  }

  showSnackBar(String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
      ),
    );
  }

  void signUpUserWithPhone() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthService().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      name: _nameController.text,
      bio: _bioController.text,
      file: _image,
    );

    setState(() {
      _isLoading = false;
    });

    if (res != 'success') {
      showSnackBar(res);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MobileView()),
      );
    }
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthService().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      name: _nameController.text,
      bio: _bioController.text,
      file: _image,
    );

    setState(() {
      _isLoading = false;
    });

    if (res != 'success') {
      showSnackBar(res);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MobileView()),
      );
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

  void navigateToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                    signUpUser();
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
                                : Text(_index == 3 ? 'SIGN UP' : 'NEXT'),
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
                          textEditingController: _emailController,
                          hintText: 'Enter your email',
                          textInputType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        TextFieldInput(
                          textEditingController: _passwordController,
                          hintText: 'Enter your password',
                          textInputType: TextInputType.text,
                          isPass: true,
                        ),
                        // const SizedBox(height: 16),
                        // const Text("or"),
                        // const SizedBox(height: 16),
                        // TextFieldInput(
                        //   textEditingController: _phoneNumberController,
                        //   hintText: 'Enter your phone number',
                        //   textInputType: TextInputType.number,
                        // ),
                      ],
                    ),
                  ),
                  Step(
                    title: const Text('About you (optional)'),
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
                  ),
                  const Step(
                    title: Text('Submit'),
                    content: Text(
                        'note: You will be able to create a username later'),
                    // content: Stack(
                    //   children: [const Text('submit')],
                    // ),
                  ),
                ],
              ),
              Flexible(
                flex: 2,
                child: Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                    child: const Text('Already have an account?'),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: navigateToLogin,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      child: const Text('Log in'),
                    ),
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


        // child: Column(
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //     // Flexible(child: Container(), flex: 2),
        //     // const CircleAvatar(
        //     //   // Display the Flutter Logo image asset.
        //     //   foregroundImage: AssetImage('assets/images/flutter_logo.png'),
        //     // ),
        //     // const SizedBox(height: 64),
        //     Stack(
        //       children: [
        //         _image != null
        //             ? CircleAvatar(
        //                 radius: 64,
        //                 backgroundImage: MemoryImage(_image!),
        //               )
        //             : const CircleAvatar(
        //                 radius: 64,
        //                 backgroundImage:
        //                     AssetImage('assets/images/flutter_logo.png'),
        //               ),
        //         Positioned(
        //           bottom: -10,
        //           left: 80,
        //           child: IconButton(
        //             onPressed: selectImage,
        //             icon: const Icon(Icons.add_a_photo),
        //           ),
        //         ),
        //       ],
        //     ),
        //     const SizedBox(height: 64),
        //     TextFieldInput(
        //       textEditingController: _usernameController,
        //       hintText: 'Enter you username',
        //       textInputType: TextInputType.text,
        //     ),
        //     const SizedBox(height: 32),
        //     TextFieldInput(
        //       textEditingController: _bioController,
        //       hintText: 'Enter you bio',
        //       textInputType: TextInputType.emailAddress,
        //     ),
        //     const SizedBox(height: 32),
        //     TextFieldInput(
        //       textEditingController: _emailController,
        //       hintText: 'Enter you email',
        //       textInputType: TextInputType.emailAddress,
        //     ),
        //     const SizedBox(height: 32),
        //     TextFieldInput(
        //       textEditingController: _passwordController,
        //       hintText: 'Enter you password',
        //       textInputType: TextInputType.text,
        //       isPass: true,
        //     ),
        //     const SizedBox(height: 32),
        //     InkWell(
        //       onTap: signUpUser,
        //       child: Container(
        //         width: double.infinity,
        //         alignment: Alignment.center,
        //         padding: const EdgeInsets.symmetric(vertical: 12),
        //         decoration: const ShapeDecoration(
        //           shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadius.all(
        //               Radius.circular(4),
        //             ),
        //           ),
        //           color: Color.fromARGB(49, 182, 83, 215),
        //         ),
        //         child: _isLoading
        //             ? const Center(
        //                 child: CircularProgressIndicator(),
        //               )
        //             : const Text('Sign up'),
        //       ),
        //     ),
        //     const SizedBox(height: 64),
        //     Flexible(child: Container(), flex: 2),
        //   ],
        // ),



