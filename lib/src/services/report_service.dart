import 'package:boonjae/src/models/post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> reportPost({
    required PostModel post,
    required String reason,
  }) async {
    // String res = 'some error occurred';

    if (reason.isEmpty) {
      return 'please fill out form';
    }

    try {
      String currentUserId = _auth.currentUser!.uid;
      Map<String, dynamic> json = post.toJson();
      json['reasoning'] = reason;

      await _firestore
          .collection('reports')
          .doc(currentUserId)
          .collection('myReports')
          .doc(post.postId)
          .set(json);

      return 'Your report has been submitted';
    } catch (err) {
      return err.toString();
    }
  }
}
