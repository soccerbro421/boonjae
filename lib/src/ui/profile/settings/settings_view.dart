import 'package:boonjae/src/ui/auth/login_screen.dart';
import 'package:boonjae/src/ui/profile/settings/edit_profile_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({
    super.key,
  });

  void logoutUser(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
      (Route<dynamic> route) => false,
    );
  }


  void navigateToEditProfileView(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const EditProfileView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: const [],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 25,
          horizontal: 20,
        ),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Divider(
              height: 1,
              thickness: 1,
            ),
            InkWell(
              onTap: () {
                navigateToEditProfileView(context);
              },
              child: const SizedBox(
                width: double.infinity,
                height: 70,
                child: Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(width: 10),
                    Text('Edit Profile'),
                    Spacer(),
                    Icon(Icons.chevron_right)
                  ],
                ),
              ),
            ),
            const Divider(
              height: 1,
              thickness: 1,
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                child: const Text('log out'),
                onPressed: () {
                  logoutUser(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
