import 'package:boonjae/src/models/group_habit_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class GroupHabitsProvider with ChangeNotifier {
  List<GroupHabitModel>? _groupHabits;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<GroupHabitModel> get getGroupHabits {

    if (_groupHabits == null) {
      return [];
    }

    return _groupHabits!;

  }

  void addGroupHabit(GroupHabitModel habit) {

    List<GroupHabitModel> temps = _groupHabits!;

    temps.add(habit);

    _groupHabits = temps;
    

    notifyListeners();
  }

  Future<void> refreshGroupHabits() async {

    List<GroupHabitModel> temp = [];

    String currentUserUid = _auth.currentUser!.uid;

    // Get all documents from the 'habits' subcollection
    QuerySnapshot groupHabitsQuerySnapshot = await _firestore
        .collection('groupHabits')
        .where('members', arrayContains: currentUserUid)
        .get();

    // Iterate through the documents in the query snapshot
    for (var groupHabitDoc in groupHabitsQuerySnapshot.docs) {
        GroupHabitModel h = GroupHabitModel.fromSnap(groupHabitDoc);
        temp.add(h);
    }

    _groupHabits = temp;

    notifyListeners();
  }

}