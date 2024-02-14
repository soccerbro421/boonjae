import 'dart:typed_data';

import 'package:boonjae/src/models/habit_model.dart';
import 'package:boonjae/src/services/storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class HabitsService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> addHabit({
    required String name,
    required String description,
    required List<bool> daysOfWeek,
    Uint8List? file,
    // required List<String> daysOfWeek,
  }) async {
    String res = 'error occurred';

    String userId = _auth.currentUser!.uid;
    String habitId = const Uuid().v1();
    String photoUrl = '';

    if (!(daysOfWeek.any((element) => element))) {
      return 'Please select at least one day';
    }

    try {
      if (name.isNotEmpty && description.isNotEmpty) {
        
        Reference habitsFolderRef = _storage
            .ref()
            .child('users/$userId')
            .child('habits')
            .child(habitId);

        if (file != null) {
          photoUrl = await StorageService()
              .uploadImageToStorageByReference(habitsFolderRef, file);
        }

        HabitModel h = HabitModel(
            habitId: habitId,
            photoUrl: photoUrl,
            name: name,
            description: description,
            userId: userId,
            daysOfWeek: daysOfWeek);

        // Reference to the user document
        DocumentReference userDocRef =
            _firestore.collection('users').doc(userId);

        // Reference to the 'habits' subcollection for the user
        CollectionReference habitsCollectionRef =
            userDocRef.collection('habits');

        await habitsCollectionRef.doc(habitId).set(h.toJson());

        // await habitsCollectionRef.doc(habitId).set({
        //   'name': habitName,
        //   // 'created_at': FieldValue.serverTimestamp(),
        //   // Add other habit-related fields as needed
        // });

        res = 'success';
      } else {
        res = 'fill in both name and description';
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }
}
