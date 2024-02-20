import 'package:boonjae/src/models/user_model.dart';
import 'package:boonjae/src/ui/auth/login_screen.dart';
import 'package:boonjae/src/ui/profile/settings/delete_profile_view.dart';
import 'package:boonjae/src/ui/profile/settings/edit_profile_view.dart';
import 'package:boonjae/src/ui/profile/settings/settings_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  final UserModel user;

  const SettingsView({
    super.key,
    required this.user,
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
        builder: (context) => EditProfileView(
          user: user,
        ),
      ),
    );
  }

  void navigateToDeleteProfileView(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DeleteProfileView(
          user: user,
        ),
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
            SettingsCard(
              onTap: navigateToEditProfileView,
              text: 'Edit Profile',
              icon: const Icon(Icons.person),
            ),
            SettingsCard(
              onTap: navigateToEditProfileView,
              text: 'Contact Us',
              icon: const Icon(Icons.contact_mail),
            ),
            SettingsCard(
              onTap: navigateToEditProfileView,
              text: 'About',
              icon: const Icon(Icons.info),
            ),
            SettingsCard(
              onTap: navigateToDeleteProfileView,
              text: 'Delete Account',
              icon: const Icon(Icons.person_remove),
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
