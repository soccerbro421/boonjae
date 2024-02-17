import 'dart:typed_data';

import 'package:boonjae/src/services/image_service.dart';
import 'package:boonjae/src/services/storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

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

    try {
      User currentUser = _auth.currentUser!;

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
