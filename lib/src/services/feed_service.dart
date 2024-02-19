import 'package:boonjae/src/models/post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FeedService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<PostModel>> getFeed() async {
    try {
      String currentUserId = _auth.currentUser!.uid;

      // Reference to the 'habits' subcollection for the user
      CollectionReference habitsCollectionRef =
          _firestore.collection('users/$currentUserId/habits');

      List<PostModel> allPosts = [];

      // Query all habits for the user
      QuerySnapshot habitsSnapshot = await habitsCollectionRef.get();

      // Iterate through each habit
      for (QueryDocumentSnapshot habitDoc in habitsSnapshot.docs) {
        // Reference to the 'posts' subcollection within the habit
        CollectionReference postsCollectionRef =
            habitDoc.reference.collection('posts');

        DateTime currentDate = DateTime.now();
        DateTime startOfWeek =
            currentDate.subtract(Duration(days: currentDate.weekday));
        DateTime startOfSunday =
            DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);

        startOfWeek = currentDate.weekday == 7
            ? DateTime(currentDate.year, currentDate.month, currentDate.day)
            : startOfSunday;
        DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));

        QuerySnapshot postsSnapshot = await postsCollectionRef
            .where('createdDate', isGreaterThanOrEqualTo: startOfWeek)
            .where('createdDate', isLessThanOrEqualTo: endOfWeek)
            .get();

        // Convert each post to a PostModel and add it to the list
        List<PostModel> habitPosts = postsSnapshot.docs.map((postDoc) {
          return PostModel.fromSnap(postDoc);
        }).toList();

        allPosts.addAll(habitPosts);
      }

      return allPosts;
    } catch (err) {
      return [];
    }
  }
}
