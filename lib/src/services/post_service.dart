import 'package:boonjae/src/models/post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  deletePost({required PostModel post}) async {
    try {
      String currentUserId = _auth.currentUser!.uid;

      await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('habits')
          .doc(post.habitId)
          .collection('posts')
          .doc(post.postId)
          .delete();


      await _storage
        .ref()
        .child('users/$currentUserId/habits/${post.habitId}/posts/${post.postId}').delete();
    } catch (err) {
      //print(err.toString());
    }
  }
}
