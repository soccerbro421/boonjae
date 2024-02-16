// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloud_functions/cloud_functions.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  // Make sure Widgets are initialized
  WidgetsFlutterBinding.ensureInitialized();
  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  // Initialize the Firebase app
  await Firebase.initializeApp();

  if (kDebugMode) {
    try {

      // comment/uncomment the following code block to disable/enable local emulator
      // FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
      // FirebaseFirestore.instance.settings = Settings(
      //   host: 'localhost:8080',
      //   sslEnabled: false,
      //   persistenceEnabled: false,
      // );
      // FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
      // FirebaseStorage.instance.useStorageEmulator('localhost', 9199);
      // FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
      
      
    } catch (e) {
      print(e);
    }
  }

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(MyApp(settingsController: settingsController));
}
