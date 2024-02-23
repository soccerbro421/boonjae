import 'dart:typed_data';

import 'package:boonjae/src/models/user_model.dart';
import 'package:boonjae/src/services/image_service.dart';
import 'package:boonjae/src/services/storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  bool isCurrentUser({required UserModel user}) {
    return user.uid == _auth.currentUser!.uid;
  }

  Future<String> updateUser({
    required String username,
    required String bio,
    required String name,
    Uint8List? file,
  }) async {
    String res = 'error occurred';
    String photoUrl = '';
    Map<String, dynamic> map = {};

    if (username.isEmpty || bio.isEmpty || name.isEmpty) {
      return 'please enter all fields';
    }

    if (username.length < 5) {
      return 'please have your username be at least 5 characters long';
    }

    if (username.contains(RegExp(r'\s'))) {
      return 'please ensure no whitespaces';
    }

    try {
      User currentUser = _auth.currentUser!;

      QuerySnapshot userSnapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        DocumentSnapshot docsnap = userSnapshot.docs[0];
        UserModel currUserModel = UserModel.fromSnap(docsnap);

        if (currUserModel.username != username) {
          return 'sorry that username is taken';
        }
      }

      if (file != null) {
        Reference profilePicRef = _storage
            .ref()
            .child('users/${currentUser.uid}')
            .child('profilePic');

        file = await ImageService().compressImage(file);

        photoUrl = await StorageService()
            .uploadImageToStorageByReference(profilePicRef, file);

        map = {
          'name': name,
          'bio': bio,
          'username': username,
          'photoUrl': photoUrl,
        };
      } else {
        map = {
          'name': name,
          'bio': bio,
          'username': username,
        };
      }

      await _firestore.collection('users').doc(currentUser.uid).update(map);

      return "success";
    } catch (err) {
      res = err.toString();
      return res;
    }
  }
}
