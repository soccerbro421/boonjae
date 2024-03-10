import 'package:boonjae/src/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditNotificationsView extends StatefulWidget {
  const EditNotificationsView({Key? key}) : super(key: key);

  @override
  State<EditNotificationsView> createState() => _EditNotificationsViewState();
}

class _EditNotificationsViewState extends State<EditNotificationsView> {
  late Future<Map<String, bool>> _userPreferences;
  bool sundayNotif = false;
  bool mondayNotif = false;
  bool tuesdayNotif = false;
  bool wednesdayNotif = false;
  bool thursdayNotif = false;
  bool fridayNotif = false;
  bool saturdayNotif = false;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _userPreferences = _getUserPreferences();
  }


  void saveNotifsPreferences() async {

    setState(() {
      _isLoading = true;
    });

    Map<String, bool> preferences = {
      'Sunday': sundayNotif,
      'Monday': mondayNotif,
      'Tuesday': tuesdayNotif,
      'Wednesday': wednesdayNotif,
      'Thursday': thursdayNotif,
      'Friday': fridayNotif,
      'Saturday': saturdayNotif,
    };

    String res = await NotificationService().setNotifsPreferencesByWeek(preferences: preferences);

    setState(() {
      _isLoading = false;
    });
    showSnackBar(res);
  }

  showSnackBar(String res) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(res)),
    );
  }

  Future<Map<String, bool>> _getUserPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      sundayNotif = prefs.getBool('Sunday') ?? false;
      mondayNotif = prefs.getBool('Monday') ?? false;
      tuesdayNotif = prefs.getBool('Tuesday') ?? false;
      wednesdayNotif = prefs.getBool('Wednesday') ?? false;
      thursdayNotif = prefs.getBool('Thursday') ?? false;
      fridayNotif = prefs.getBool('Friday') ?? false;
      saturdayNotif = prefs.getBool('Saturday') ?? false;
    });

    Map<String, bool> preferences = {
      'Sunday': prefs.getBool('Sunday') ?? false,
      'Monday': prefs.getBool('Monday') ?? false,
      'Tuesday': prefs.getBool('Tuesday') ?? false,
      'Wednesday': prefs.getBool('Wednesday') ?? false,
      'Thursday': prefs.getBool('Thursday') ?? false,
      'Friday': prefs.getBool('Friday') ?? false,
      'Saturday': prefs.getBool('Saturday') ?? false,
    };

    return preferences;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Notifications'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton(
              onPressed: () {
                // Handle save button click
                saveNotifsPreferences();
              },
              child: const Text("Save"),
            ),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, bool>>(
        future: _userPreferences,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return _buildPreferencesList(snapshot.data!);
          }
        },
      ),
    );
  }

  Widget _buildPreferencesList(Map<String, bool> preferences) {
    return ListView(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 10, 8, 30),
            child:
                _isLoading ? const CircularProgressIndicator() : 
                const Text('choose when to get reminders to work on your habits !'),
          ),
        ),
        ListTile(
          title: const Text('Sunday'),
          trailing: Switch(
            value: sundayNotif,
            onChanged: (value) {
              // Save the updated preference to SharedPreferences
              setState(() {
                sundayNotif = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Monday'),
          trailing: Switch(
            value: mondayNotif,
            onChanged: (value) {
              // Save the updated preference to SharedPreferences
              setState(() {
                mondayNotif = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Tuesday'),
          trailing: Switch(
            value: tuesdayNotif,
            onChanged: (value) {
              // Save the updated preference to SharedPreferences
              setState(() {
                tuesdayNotif = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Wednesday'),
          trailing: Switch(
            value: wednesdayNotif,
            onChanged: (value) {
              // Save the updated preference to SharedPreferences
              setState(() {
                wednesdayNotif = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Thursday'),
          trailing: Switch(
            value: thursdayNotif,
            onChanged: (value) {
              // Save the updated preference to SharedPreferences
              setState(() {
                thursdayNotif = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Friday'),
          trailing: Switch(
            value: fridayNotif,
            onChanged: (value) {
              // Save the updated preference to SharedPreferences
              setState(() {
                fridayNotif = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Saturday'),
          trailing: Switch(
            value: saturdayNotif,
            onChanged: (value) {
              // Save the updated preference to SharedPreferences
              setState(() {
                saturdayNotif = value;
              });
            },
          ),
        ),
      ],
    );
  }
}
