import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String uid;
  final String photoUrl;
  final String name;
  final String bio;
  final String username;
  final List followers;
  final List following;

  const UserModel({
    required this.email,
    required this.uid,
    required this.photoUrl,
    required this.name,
    required this.bio,
    required this.username,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'uid': uid,
        'email': email,
        'photoUrl': photoUrl,
        'bio': bio,
        'username': username,
        'followers': followers,
        'following': following,
      };
  
  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      name: snapshot['name'],
      uid: snapshot['uid'],
      email: snapshot['email'],
      username: snapshot['username'],
      photoUrl: snapshot['photoUrl'],
      bio: snapshot['bio'],
      followers: snapshot['followers'],
      following: snapshot['following'],
      
    );

  }
}
