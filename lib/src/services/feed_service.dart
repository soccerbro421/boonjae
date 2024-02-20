import 'package:boonjae/src/models/post_model.dart';
import 'package:boonjae/src/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FeedService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<PostModel>> getFeed({required UserModel user}) async {
    try {
      List<PostModel> allPosts = [];

      DateTime currentDate = DateTime.now();
      DateTime startOfWeek =
          currentDate.subtract(Duration(days: currentDate.weekday));
      DateTime startOfSunday =
          DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);

      startOfWeek = currentDate.weekday == 7
          ? DateTime(currentDate.year, currentDate.month, currentDate.day)
          : startOfSunday;
      DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));

      String currentUserId = _auth.currentUser!.uid;

      
      List<String> posters = user.friends
          .map((dynamic friend) => friend.toString())
          .toList();

      posters.add(currentUserId);

      // iterate through friends + me
      for (int i = 0; i < posters.length; i++) {
        String userId = posters[i];

        // Reference to the 'habits' subcollection for the user
        CollectionReference habitsCollectionRef =
            _firestore.collection('users/$userId/habits');

        // Query all habits for the user
        QuerySnapshot habitsSnapshot = await habitsCollectionRef.get();

        // Iterate through each habit
        for (QueryDocumentSnapshot habitDoc in habitsSnapshot.docs) {
          // Reference to the 'posts' subcollection within the habit
          CollectionReference postsCollectionRef =
              habitDoc.reference.collection('posts');

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
      }

      allPosts.sort((a, b) => b.createdDate.compareTo(a.createdDate));

      return allPosts;
    } catch (err) {
      print(err.toString());
      return [];
    }
  }
}
