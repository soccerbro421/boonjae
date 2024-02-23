import 'package:async_preferences/async_preferences.dart';
import 'package:boonjae/src/models/user_model.dart';
import 'package:boonjae/src/ui/auth/login_screen.dart';
import 'package:boonjae/src/ui/profile/settings/contact_us_view.dart';
import 'package:boonjae/src/ui/profile/settings/delete_profile_view.dart';
import 'package:boonjae/src/ui/profile/settings/edit_privacy_view.dart';
import 'package:boonjae/src/ui/profile/settings/edit_profile_view.dart';
import 'package:boonjae/src/ui/profile/settings/settings_card.dart';
import 'package:boonjae/src/ui/widgets/privacy_policy_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  final UserModel user;

  const SettingsView({
    super.key,
    required this.user,
  });

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late final Future<bool> _isGDPR;

  @override
  void initState() {
    _isGDPR = _isUnderGdpr();
    super.initState();
  }

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
          user: widget.user,
        ),
      ),
    );
  }

  void navigateToContactUsView(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ContactUsView(),
      ),
    );
  }

  void navigateToEditPrivacyView(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const EditPrivacyView(),
      ),
    );
  }

  void navigateToDeleteProfileView(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DeleteProfileView(
          user: widget.user,
        ),
      ),
    );
  }

  void navigateToPrivacyPolicyView(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PrivacyPolicyView(),
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
              onTap: navigateToContactUsView,
              text: 'Contact Us',
              icon: const Icon(Icons.contact_mail),
            ),
            SettingsCard(
              onTap: navigateToPrivacyPolicyView,
              text: 'Privacy Policy/Terms of Use',
              icon: const Icon(Icons.info),
            ),
            FutureBuilder<bool>(
                future: _isGDPR,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data! == true) {
                    return SettingsCard(
                      onTap: navigateToEditPrivacyView,
                      text: 'Update Data Privacy',
                      icon: const Icon(Icons.privacy_tip),
                    );
                  } else {
                    return Container();
                  }
                }),
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

Future<bool> _isUnderGdpr() async {
  final preferences = AsyncPreferences();
  return await preferences.getInt('IABTCF_gdprApplies') == 1;
}
