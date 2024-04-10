import 'dart:typed_data';

import 'package:boonjae/src/db/tasks_database.dart';
import 'package:boonjae/src/models/base_habit_model.dart';
import 'package:boonjae/src/models/group_habit_model.dart';
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
      CollectionReference habitsCollection = _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('habits');

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

  Future<List<GroupHabitModel>> getGroupHabitsByUser({
    required UserModel user,
  }) async {
    try {
      List<GroupHabitModel> res = [];

      // Get all documents from the 'habits' subcollection
      QuerySnapshot groupHabitsQuerySnapshot = await _firestore
          .collection('groupHabits')
          .where('members', arrayContains: user.uid)
          .get();

      // Iterate through the documents in the query snapshot
      for (var groupHabitDoc in groupHabitsQuerySnapshot.docs) {
        GroupHabitModel h = GroupHabitModel.fromSnap(groupHabitDoc);
        res.add(h);
      }

      return res;
    } catch (err) {
      return [];
    }
  }

  Future<List<PostModel>> getGroupHabitPosts({
    required GroupHabitModel groupHabit,
  }) async {
    try {
      CollectionReference postsCollectionRef = _firestore
          .collection('groupHabits')
          .doc(groupHabit.habitId)
          .collection('posts');

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
      // print(err.toString());
      return [];
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
    required BaseHabitModel habit,
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

      if (habit is HabitModel) {
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

        CollectionReference postsCollectionRef =
            habitsDocRef.collection('posts');

        await postsCollectionRef.doc(postId).set(p.toJson());
      } else if (habit is GroupHabitModel) {
        Reference postPicRef =
            _storage.ref().child('groupHabits/${habit.habitId}/posts/$postId');

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
        CollectionReference postsCollectionRef = _firestore
            .collection('groupHabits')
            .doc(habit.habitId)
            .collection('posts');

        await postsCollectionRef.doc(postId).set(p.toJson());
      }

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

  Future<String> leaveGroupHabit({
    required GroupHabitModel habit,
  }) async {
    String res = 'error occurred';

    try {
      String currentUserId = _auth.currentUser!.uid;

      habit.members.remove(currentUserId);

      GroupHabitModel h = GroupHabitModel(
        habitId: habit.habitId,
        photoUrl: habit.photoUrl,
        name: habit.name,
        description: habit.description,
        createdDate: habit.createdDate,
        members: habit.members,
      );

      await _firestore
          .collection('groupHabits')
          .doc(habit.habitId)
          .update(h.toJson());
      return 'success';
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  Future<String> updateMembersInGroupHabit({
    required List<UserModel> newUsers,
    required GroupHabitModel oldHabit,
    Uint8List? file,
    // required List<String> daysOfWeek,
  }) async {
    String res = 'error occurred';

    try {
      List<String> uids = newUsers.map((user) => user.uid).toList();

      GroupHabitModel h = GroupHabitModel(
        habitId: oldHabit.habitId,
        photoUrl: oldHabit.photoUrl,
        name: oldHabit.name,
        description: oldHabit.description,
        createdDate: oldHabit.createdDate,
        members: uids,
      );

      await _firestore
          .collection('groupHabits')
          .doc(oldHabit.habitId)
          .update(h.toJson());
      return 'success';
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  Future<String> updateGroupHabit({
    required String name,
    required String description,
    required GroupHabitModel oldHabit,
    Uint8List? file,
    // required List<String> daysOfWeek,
  }) async {
    String res = 'error occurred';
    String habitId = oldHabit.habitId;
    String photoUrl = oldHabit.photoUrl;

    // if (!(daysOfWeek.any((element) => element))) {
    //   return 'Please select at least one day';
    // }

    try {
      if (name.isNotEmpty) {
        Reference habitsFolderRef = _storage
            .ref()
            .child('groupHabits/${oldHabit.habitId}')
            .child('coverPhoto');

        if (file != null) {
          file = await ImageService().compressImage(file);

          photoUrl = await StorageService()
              .uploadImageToStorageByReference(habitsFolderRef, file);
        }

        GroupHabitModel h = GroupHabitModel(
          habitId: habitId,
          photoUrl: photoUrl,
          name: name,
          description: description,
          createdDate: oldHabit.createdDate,
          members: oldHabit.members,
        );

        await _firestore
            .collection('groupHabits')
            .doc(oldHabit.habitId)
            .update(h.toJson());

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
            order: oldHabit.order);

        // create tasks
        await createTasksForHabit(
          daysOfWeek: daysOfWeek,
          h: h,
        );

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

  Future<String> addGroupHabit({
    required String name,
    required String description,
    required List<UserModel> friendsToAdd,
    Uint8List? file,
  }) async {
    String res = 'error occurred';

    String currentUserId = _auth.currentUser!.uid;
    String habitId = const Uuid().v1();
    String photoUrl = '';

    if (name.isEmpty) {
      return res;
    }

    try {
      // upload cover photo
      Reference habitsFolderRef = _storage
          .ref()
          .child('groupHabits')
          .child(habitId)
          .child('coverPhoto');

      if (file != null) {
        file = await ImageService().compressImage(file);

        photoUrl = await StorageService()
            .uploadImageToStorageByReference(habitsFolderRef, file);
      }

      List<String> uids = friendsToAdd.map((user) => user.uid).toList();
      uids.add(currentUserId);

      // upload data to firebase
      GroupHabitModel h = GroupHabitModel(
          habitId: habitId,
          photoUrl: photoUrl,
          name: name,
          description: description,
          createdDate: DateTime.now(),
          members: uids);

      // Reference to the user document
      CollectionReference groupHabitRef = _firestore.collection('groupHabits');

      // Add the currentUserUid to the list of uids

      await groupHabitRef.doc(habitId).set(h.toJson());
      return 'success';
    } catch (err) {
      return err.toString();
    }
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

        await createTasksForHabit(
          daysOfWeek: daysOfWeek,
          h: h,
        );

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

  Future<dynamic> createTasksForHabit({
    required List<bool> daysOfWeek,
    required HabitModel h,
  }) async {
    try {
      String userId = _auth.currentUser!.uid;

      DateTime currentDate = DateTime.now();
      DateTime startOfWeek =
          currentDate.subtract(Duration(days: currentDate.weekday));
      DateTime startOfSunday =
          DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);

      startOfWeek = currentDate.weekday == 7
          ? DateTime(currentDate.year, currentDate.month, currentDate.day)
          : startOfSunday;

      for (int i = 0; i < daysOfWeek.length; i++) {
        if (daysOfWeek[i] == true) {
          DateTime taskDate = startOfWeek.add(Duration(days: i));
          TaskModel task = TaskModel(
            userId: userId,
            habitId: h.habitId,
            dayOfWeek: daysOfWeekStrings[i],
            habitName: h.name,
            date: taskDate,
            status: "NOTCOMPLETED",
          );
          await TasksDatabase.instance.create(task);

          NotificationService()
              .setDayNotif(dayOfWeek: daysOfWeekStrings[i], on: true);
        }
      }
    } catch (err) {
      // test
    }
  }
}
