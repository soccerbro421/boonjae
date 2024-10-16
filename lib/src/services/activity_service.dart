import 'dart:math';

import 'package:boonjae/src/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class ActivityService {
  final FirebaseDatabase _rtdb = FirebaseDatabase.instance;

  Future<Map<String, dynamic>> getThisWeekLeaderboard(
      {required UserModel currentUser}) async {
    try {
      List<dynamic> tasksByFriend = [];
      List<String> friendsNoTask = [];

      DateTime currentDateTime = DateTime.now();
      String weekYear = ActivityService().weekRange(currentDateTime);
      // String weekYear = '$numWeek-${currentDateTime.year}';
      // String tasksPerWeekPath =
      //     "users/${currentUser.uid}/tasksPerWeek/$weekYear";

      // DatabaseReference tasksPerWeekRef = _rtdb.ref().child(tasksPerWeekPath);
      // DatabaseEvent event = await tasksPerWeekRef.once();

      // // Get the number of tasks for the current week for currentUser
      // int currUserTasksThisWeek =
      //     event.snapshot.value != null ? event.snapshot.value as int : 0;
      // if (currUserTasksThisWeek > 0) {
      //   tasksByFriend[currentUser.uid] = currUserTasksThisWeek;
      // }

      // Iterate over the list of friends
      List<String> friends =
          (currentUser.friends).map((friend) => friend.toString()).toList();

      for (String friendId in friends) {
        // Construct the path to fetch the number of tasks for each friend
        String friendTasksPath = "users/$friendId/tasksPerWeek/$weekYear";
        DatabaseReference friendTasksRef = _rtdb.ref().child(friendTasksPath);
        DatabaseEvent friendEvent = await friendTasksRef.once();

        // Get the number of tasks for the friend for the current week
        int friendTasksThisWeek = friendEvent.snapshot.value != null
            ? friendEvent.snapshot.value as int
            : 0;

        if (friendTasksThisWeek > 0) {
          // topPerformers.add([friendTasksThisWeek, friendId]);
          // Store the number of tasks for the friend
          tasksByFriend.add([friendTasksThisWeek, friendId]);
        } else {
          friendsNoTask.add(friendId);
        }
      }

      // print(res);
      List<dynamic> sortedTopPerformers = tasksByFriend;
      sortedTopPerformers
          .sort((a, b) => b[0].compareTo(a[0])); // Sort in descending order

      // Extract the top performers
      List<dynamic> topPerformersList = sortedTopPerformers.sublist(
          0,
          sortedTopPerformers.length >= 3
              ? 3
              : sortedTopPerformers.length); // Get the top 3 performers

      List<dynamic> topUserPerformers = [];
      List<dynamic> bottomPerformers = [];

      Future<UserModel?> fetchUserModel(String uid) async {
        DocumentSnapshot snapshot =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();
        if (snapshot.exists) {
          return UserModel.fromSnap(snapshot);
        }
        return null;
      }

// Populate topUserPerformers
      for (var performer in topPerformersList) {
        int score = performer[0];
        String uid = performer[1];
        UserModel? user = await fetchUserModel(uid);
        if (user != null) {
          topUserPerformers.add([score, user]);
        }
      }

      // Shuffle the list
      friendsNoTask.shuffle();

// Get the first three items
      for (var i = 0; i < min(3, friendsNoTask.length); i++) {
        UserModel? user = await fetchUserModel(friendsNoTask[i]);
        if (user != null) {
          bottomPerformers.add(user);
        }
      }

      return {"topFriends": topUserPerformers, "pokeFriends": bottomPerformers};
    } catch (err) {
      // Handle errors
      // print(err.toString());
      return {};
    }
  }

  String weekRange(DateTime date) {
    // Find the previous Sunday
    DateTime currentDate = DateTime.now();
    DateTime startOfWeek =
        currentDate.subtract(Duration(days: currentDate.weekday));
    DateTime startOfSunday =
        DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);

    startOfWeek = currentDate.weekday == 7
        ? DateTime(currentDate.year, currentDate.month, currentDate.day)
        : startOfSunday;

    // Find the next Saturday
    DateTime saturday = startOfWeek.add(const Duration(days: 6));

    // Format the dates as strings
    String sundayString =
        '${startOfWeek.month}-${startOfWeek.day}-${startOfWeek.year}';
    String saturdayString =
        '${saturday.month}-${saturday.day}-${saturday.year}';

    // Return the range string
    return '$sundayString--$saturdayString';
  }
}
