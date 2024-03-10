import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  Future<String> setNotifsPreferencesByWeek({
    required Map<String, bool> preferences,
  }) async {
    try {
      for (MapEntry<String, bool> entry in preferences.entries) {
        await setDayNotif(dayOfWeek: entry.key, on: entry.value);
      }
      return "Saved notifications preferences successfully";
    } catch (err) {
      return err.toString();
    }
  }

  setDayNotif({
    required String dayOfWeek,
    required bool on,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      if (on) {
        await FirebaseMessaging.instance.subscribeToTopic(dayOfWeek);
        await prefs.setBool(dayOfWeek, true);
      } else {
        await FirebaseMessaging.instance.unsubscribeFromTopic(dayOfWeek);
        await prefs.setBool(dayOfWeek, false);
      }
    } catch (err) {
      // print(err.toString());
    }
  }
}
