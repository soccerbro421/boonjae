import 'dart:typed_data';

import 'package:boonjae/src/db/tasks_database.dart';
import 'package:boonjae/src/models/habit_model.dart';
import 'package:boonjae/src/models/post_model.dart';
import 'package:boonjae/src/models/task_model.dart';
import 'package:boonjae/src/models/user_model.dart';
import 'package:boonjae/src/services/image_service.dart';
import 'package:boonjae/src/services/notification_service.dart';
import 'package:boonjae/src/services/storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class HabitsService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final List<String> daysOfWeekStrings = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
  ];

  Future<String> saveHabitOrder({required List<HabitModel> habits}) async {
    try {
      String currentUserId = _auth.currentUser!.uid;
      // Assuming you have a Firestore collection named 'habits'
      CollectionReference habitsCollection =
          _firestore.collection('users').doc(currentUserId).collection('habits');

      for (int newIndex = 0; newIndex < habits.length; newIndex++) {
        final HabitModel habit = habits[newIndex];

        // Update the order attribute in Firestore
        await habitsCollection.doc(habit.habitId).update({'order': newIndex});
      }

      return 'Saved order successfully';
  
    } catch (error) {
      // print('Error saving habit order: $error');
      return error.toString();
    }
  }

  Future<List<HabitModel>> getHabitsByUser({required UserModel user}) async {
    try {
      List<HabitModel> habits = [];

      CollectionReference habitsCollectionRef =
          _firestore.collection('users').doc(user.uid).collection('habits');

      QuerySnapshot habitsQuerySnapshot = await habitsCollectionRef.get();

      // Iterate through the documents in the subcollection
      for (var habitDoc in habitsQuerySnapshot.docs) {
        // Access the data of each document
        // Map<String, dynamic> habitData = habitDoc.data() as Map<String, dynamic>;

        HabitModel h = HabitModel.fromSnap(habitDoc);

        habits.add(h);
      }
      return habits;
    } catch (err) {
      return [];
    }
  }

  void deleteHabit({
    required HabitModel habit,
  }) async {
    try {
      String currentUserId = _auth.currentUser!.uid;

      DocumentReference userDocRef =
          _firestore.collection('users').doc(currentUserId);

      // Reference to the 'habits' subcollection for the user
      DocumentReference habitsDocRef =
          userDocRef.collection('habits').doc(habit.habitId);

      await habitsDocRef.delete();

      Reference habitRef =
          _storage.ref().child('users/$currentUserId/habits/${habit.habitId}');

      Reference coverPhotoRef = habitRef.child('coverPhoto');

      Reference postsRef = habitRef.child('posts');

      ListResult listResult = await postsRef.listAll();

      // Delete each item in the 'posts' directory
      await Future.forEach(listResult.items, (Reference itemRef) async {
        await itemRef.delete();
      });

      await coverPhotoRef.delete();
    } catch (err) {
      //sdf
    }
  }

  Future<List<PostModel>> getPostsByHabitAndUser({
    required HabitModel habit,
    required UserModel user,
  }) async {
    try {
      String userId = user.uid;

      DocumentReference userDocRef = _firestore.collection('users').doc(userId);

      // Reference to the 'habits' subcollection for the user
      DocumentReference habitsDocRef =
          userDocRef.collection('habits').doc(habit.habitId);

      CollectionReference postsCollectionRef = habitsDocRef.collection('posts');

      List<PostModel> posts = [];

      QuerySnapshot querySnapshot = await postsCollectionRef
          .orderBy('createdDate', descending: true)
          .get();

      posts = [];

      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        PostModel post = PostModel.fromSnap(docSnapshot);
        posts.add(post);
      }

      return posts;
    } catch (err) {
      return [];
    }
  }

  Future<String> uploadPostFromTab({
    required HabitModel habit,
    required Uint8List file,
    required String description,
    required UserModel user,
  }) async {

    String photoUrl = '';
    String postId = const Uuid().v1();

    if (description.isEmpty) {
      return 'please enter all fields';
    }

    try {
      String currentUserId = _auth.currentUser!.uid;

      Reference postPicRef = _storage
          .ref()
          .child('users/$currentUserId')
          .child('habits')
          .child(habit.habitId)
          .child('posts')
          .child(postId);

      file = await ImageService().compressImage(file);

      photoUrl = await StorageService()
          .uploadImageToStorageByReference(postPicRef, file);

      PostModel p = PostModel(
        habitId: habit.habitId,
        photoUrl: photoUrl,
        postId: postId,
        description: description,
        userId: currentUserId,
        createdDate: DateTime.now(),
        habitName: habit.name,
        userName: user.username,
      );

      DocumentReference userDocRef =
          _firestore.collection('users').doc(currentUserId);

      // Reference to the 'habits' subcollection for the user
      DocumentReference habitsDocRef =
          userDocRef.collection('habits').doc(habit.habitId);

      CollectionReference postsCollectionRef = habitsDocRef.collection('posts');

      await postsCollectionRef.doc(postId).set(p.toJson());

      return 'successful upload !';

    } catch (err) {
      return err.toString();
    }

  }

  Future<String> uploadPost({
    required TaskModel task,
    Uint8List? file,
    required String description,
    required UserModel user,
  }) async {
    String photoUrl = '';
    String postId = const Uuid().v1();

    if (file == null || description.isEmpty) {
      return 'please enter all fields';
    }

    try {
      User currentUser = _auth.currentUser!;

      Reference postPicRef = _storage
          .ref()
          .child('users/${currentUser.uid}')
          .child('habits')
          .child(task.habitId)
          .child('posts')
          .child(postId);

      file = await ImageService().compressImage(file);

      photoUrl = await StorageService()
          .uploadImageToStorageByReference(postPicRef, file);

      PostModel p = PostModel(
        habitId: task.habitId,
        photoUrl: photoUrl,
        postId: postId,
        description: description,
        userId: currentUser.uid,
        createdDate: DateTime.now(),
        habitName: task.habitName,
        userName: user.username,
      );

      DocumentReference userDocRef =
          _firestore.collection('users').doc(currentUser.uid);

      // Reference to the 'habits' subcollection for the user
      DocumentReference habitsDocRef =
          userDocRef.collection('habits').doc(task.habitId);

      CollectionReference postsCollectionRef = habitsDocRef.collection('posts');

      await postsCollectionRef.doc(postId).set(p.toJson());

      return 'success';
    } catch (err) {
      return err.toString();
    }
  }

  Future<String> updateHabit({
    required String name,
    required String description,
    required List<bool> daysOfWeek,
    required HabitModel oldHabit,
    Uint8List? file,
    // required List<String> daysOfWeek,
  }) async {
    String res = 'error occurred';

    String userId = _auth.currentUser!.uid;
    String habitId = oldHabit.habitId;
    String photoUrl = oldHabit.photoUrl;

    // if (!(daysOfWeek.any((element) => element))) {
    //   return 'Please select at least one day';
    // }

    try {
      if (name.isNotEmpty) {
        Reference habitsFolderRef = _storage
            .ref()
            .child('users/$userId')
            .child('habits')
            .child(habitId)
            .child('coverPhoto');

        if (file != null) {
          file = await ImageService().compressImage(file);

          photoUrl = await StorageService()
              .uploadImageToStorageByReference(habitsFolderRef, file);
        }

        HabitModel h = HabitModel(
          habitId: habitId,
          photoUrl: photoUrl,
          name: name,
          description: description,
          userId: userId,
          daysOfWeek: daysOfWeek,
          createdDate: oldHabit.createdDate,
          order: oldHabit.order
        );

        // create tasks
        for (int i = 0; i < daysOfWeek.length; i++) {
          if (daysOfWeek[i] == true) {
            TaskModel task = TaskModel(
              userId: userId,
              habitId: h.habitId,
              dayOfWeek: daysOfWeekStrings[i],
              habitName: h.name,
              date: DateTime.now(),
              status: "NOTCOMPLETED",
            );
            await TasksDatabase.instance.create(task);
          }
        }

        CollectionReference habitsCollectionRef =
            _firestore.collection('users').doc(userId).collection('habits');

        await habitsCollectionRef.doc(habitId).update(h.toJson());

        // await habitsCollectionRef.doc(habitId).set({
        //   'name': habitName,
        //   // 'created_at': FieldValue.serverTimestamp(),
        //   // Add other habit-related fields as needed
        // });

        res = 'success';
      } else {
        res = 'please enter habit name';
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  Future<String> addHabit({
    required String name,
    required String description,
    required List<bool> daysOfWeek,
    Uint8List? file,
    required int order,
    // required List<String> daysOfWeek,
  }) async {
    String res = 'error occurred';

    String userId = _auth.currentUser!.uid;
    String habitId = const Uuid().v1();
    String photoUrl = '';

    // if (!(daysOfWeek.any((element) => element))) {
    //   return 'Please select at least one day';
    // }

    try {
      if (name.isNotEmpty) {
        Reference habitsFolderRef = _storage
            .ref()
            .child('users/$userId')
            .child('habits')
            .child(habitId)
            .child('coverPhoto');

        if (file != null) {
          file = await ImageService().compressImage(file);

          photoUrl = await StorageService()
              .uploadImageToStorageByReference(habitsFolderRef, file);
        }

        HabitModel h = HabitModel(
          habitId: habitId,
          photoUrl: photoUrl,
          name: name,
          description: description,
          userId: userId,
          daysOfWeek: daysOfWeek,
          createdDate: DateTime.now(),
          order: order,
        );

        for (int i = 0; i < daysOfWeek.length; i++) {
          if (daysOfWeek[i] == true) {
            TaskModel task = TaskModel(
              userId: userId,
              habitId: h.habitId,
              dayOfWeek: daysOfWeekStrings[i],
              habitName: h.name,
              date: DateTime.now(),
              status: "NOTCOMPLETED",
            );
            await TasksDatabase.instance.create(task);

            NotificationService().setDayNotif(dayOfWeek: daysOfWeekStrings[i], on: true);


          }
        }

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
        res = 'please enter a habit name';
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }
}
