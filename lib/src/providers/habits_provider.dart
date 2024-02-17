import 'package:boonjae/src/models/habit_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class HabitsProvider with ChangeNotifier {
  List<HabitModel>? _habits;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<HabitModel> get getHabits {

    if (_habits == null) {
      return [];
    }

    return _habits!;

  }

  void addHabit(HabitModel habit) {

    List<HabitModel> temps = _habits!;

    temps.add(habit);

    _habits = temps;
    

    notifyListeners();
  }

  Future<void> refreshHabits() async {

    List<HabitModel> temp = [];

    User currentUser = _auth.currentUser!;

    DocumentReference userDocRef = _firestore.collection('users').doc(currentUser.uid);

    CollectionReference habitsCollectionRef = userDocRef.collection('habits');

    // Get all documents from the 'habits' subcollection
    QuerySnapshot habitsQuerySnapshot = await habitsCollectionRef.get();

    // Iterate through the documents in the subcollection
    for (var habitDoc in habitsQuerySnapshot.docs) {
      // Access the data of each document
      // Map<String, dynamic> habitData = habitDoc.data() as Map<String, dynamic>;

      HabitModel h = HabitModel.fromSnap(habitDoc);

      temp.add(h);

      // Use 'habitData' as needed
    
    }

    _habits = temp;

    notifyListeners();
  }

}