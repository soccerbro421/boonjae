import 'package:boonjae/src/models/user_model.dart';
import 'package:boonjae/src/services/auth_service.dart';
import 'package:boonjae/src/ui/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DeleteProfileView extends StatefulWidget {
  final UserModel user;
  const DeleteProfileView({
    super.key,
    required this.user,
  });

  @override
  State<DeleteProfileView> createState() => _DeleteProfileViewState();
}

class _DeleteProfileViewState extends State<DeleteProfileView> {
  bool _isLoading = false;

  void deleteUser() async {
    setState(() {
      _isLoading = true;
    });

    await AuthService().deleteUser(user: widget.user);

    setState(() {
      _isLoading = false;
    });


    FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
      (Route<dynamic> route) => false,
    );



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Delete Account'),
        ),
        body: Center(
          child: Column(children: [
            const SizedBox(height: 100),
            const Text('Are you sure you want to delete your profile?'),
            const Text('This will delete all your habits, posts, etc'),
            const Text('You will not be able to undo this action'),
            const SizedBox(height: 100),
            ElevatedButton.icon(
              icon: const Icon(Icons.delete),
              label: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : const Text('Delete Account'),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 255, 133, 125)), // Text color
                overlayColor: MaterialStateProperty.all<Color>(
                    Colors.redAccent), // Ripple color
              ),
              onPressed: () {
                deleteUser();
              },
            ),
          ]),
        ));
  }
}
