import 'dart:typed_data';

import 'package:boonjae/src/models/user_model.dart';
import 'package:boonjae/src/services/image_service.dart';
import 'package:boonjae/src/services/storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

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
          username: 'user${creds.user!.uid}',
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
