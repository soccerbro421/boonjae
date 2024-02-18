import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String postId;
  final String habitId;
  final String photoUrl;
  final String description;
  final String userId;
  final DateTime createdDate;
  final String habitName;
  final String userName;


  PostModel({
    required this.habitId,
    required this.photoUrl,
    required this.postId,
    required this.description,
    required this.userId,
    required this.createdDate,
    required this.habitName,
    required this.userName,
  });

  Map<String, dynamic> toJson() => {
        'habitId': habitId,
        'photoUrl': photoUrl,
        'postId': postId,
        'description': description,
        'userId': userId,
        'createdDate': createdDate,
        'habitName': habitName,
        'userName': userName,
      };

  static PostModel fromSnap(DocumentSnapshot snap) {
    

    var snapshot = snap.data() as Map<String, dynamic>;

    return PostModel(
      postId: snapshot['postId'],
      userId: snapshot['userId'],
      habitId: snapshot['habitId'],
      photoUrl: snapshot['photoUrl'],
      description: snapshot['description'],
      createdDate: (snapshot['createdDate'] as Timestamp).toDate(),
      userName: snapshot['userName'],
      habitName: snapshot['habitName']
    );
  }
}
