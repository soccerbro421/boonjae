import 'dart:typed_data';

import 'package:boonjae/src/models/habit_model.dart';
import 'package:boonjae/src/models/post_model.dart';
import 'package:boonjae/src/models/user_model.dart';
import 'package:boonjae/src/services/friends_service.dart';
import 'package:boonjae/src/services/image_service.dart';
import 'package:boonjae/src/services/storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  deleteUser({required UserModel user}) async {
    try {
      User currentUser = _auth.currentUser!;

      String currentUserId = currentUser.uid;
      // remove friends
      List<UserModel> friendsToRemove = [];

      for (String friendId in user.friends) {
        DocumentSnapshot friendSnapshot =
            await _firestore.collection('users').doc(friendId).get();

        if (friendSnapshot.exists) {
          UserModel friend = UserModel.fromSnap(friendSnapshot);
          friendsToRemove.add(friend);
        }
      }

      for (UserModel friend in friendsToRemove) {
        await FriendsService().removeFriend(friendToBeRemoved: friend);
      }

      Reference profilePicRef = _storage.ref().child('users/$currentUserId');

// List all items in the folder
      ListResult result = await profilePicRef.listAll();

// Check if there are items before attempting deletion
      if (result.items.isNotEmpty) {
        // Delete files in Firestore Storage
        await profilePicRef
            .child('profilePic')
            .delete();
      }

      // delete firestore data

      CollectionReference usersCollection = _firestore.collection('users');

      QuerySnapshot querySnapshot =
          await usersCollection.where('uid', isEqualTo: currentUserId).get();
      List<DocumentSnapshot> docs = querySnapshot.docs;

      if (docs.isNotEmpty) {
        DocumentSnapshot snap = docs[0];

        CollectionReference habitsCollection =
            usersCollection.doc(currentUserId).collection('habits');
        QuerySnapshot querySnapshotHabits = await habitsCollection.get();
        List<DocumentSnapshot> habitDocs = querySnapshotHabits.docs;

        if (habitDocs.isNotEmpty) {
          for (DocumentSnapshot habitSnap in habitDocs) {
            HabitModel habit = HabitModel.fromSnap(habitSnap);

            // delete photos
            Reference habitsStorageRef = _storage
                .ref()
                .child('users/$currentUserId/habits/${habit.habitId}');

            await habitsStorageRef.child('coverPhoto').delete();

            CollectionReference postsCollection =
                habitsCollection.doc(habit.habitId).collection('posts');
            QuerySnapshot querySnapshotPosts = await postsCollection.get();
            List<DocumentSnapshot> postDocs = querySnapshotPosts.docs;
            Reference postsStorageRef = _storage
                .ref()
                .child('users/$currentUserId/habits/${habit.habitId}/posts');

            for (DocumentSnapshot postSnap in postDocs) {
              PostModel post = PostModel.fromSnap(postSnap);
              await postsStorageRef.child(post.postId).delete();

              await postSnap.reference.delete();
            }

            await habitSnap.reference.delete();
          }
        }

        await snap.reference.delete();
      }

      // Delete from FirebaseAuth
      await currentUser.delete();
    } catch (err) {
      // err
    }
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String name,
    required String bio,
    Uint8List? file,
  }) async {
    String res = 'Error occurred';

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        // register user

        UserCredential creds = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String photoUrl = '';

        if (file != null) {
          Reference profilePicRef = _storage
              .ref()
              .child('users/${creds.user!.uid}')
              .child('profilePic');

          file = await ImageService().compressImage(file);

          photoUrl = await StorageService()
              .uploadImageToStorageByReference(profilePicRef, file);
        }

        UserModel user = UserModel(
          uid: creds.user!.uid,
          username: 'plz-change-username',
          photoUrl: photoUrl,
          name: name,
          bio: bio,
          friends: [],
        );

        // add user
        // doc(creds.user!.uid) sets the document id
        await _firestore
            .collection('users')
            .doc(creds.user!.uid)
            .set(user.toJson());

        res = "success";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = 'The email is badly formatted';
      } else if (err.code == 'email-already-in-use') {
        res = 'The email address is already in use by another account';
      } else if (err.code == 'weak-password') {}
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Login the user

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "Please enter all fields";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = 'The email is badly formatted';
      } else if (err.code == 'email-already-in-use') {
        res = 'The email address is already in use by another account';
      } else if (err.code == 'weak-password') {}
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  Future<UserModel> getUserDetails() async {
    // get from FirebaseAuth
    User currentUser = _auth.currentUser!;

    // get other info from FirebaseFirestore
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    UserModel user = UserModel.fromSnap(snap);

    return user;
  }
}
