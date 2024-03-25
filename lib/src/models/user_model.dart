import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String photoUrl;
  final String name;
  final String bio;
  final String username;
  final List friends;

  const UserModel({
    required this.uid,
    required this.photoUrl,
    required this.name,
    required this.bio,
    required this.username,
    required this.friends,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel && runtimeType == other.runtimeType && uid == other.uid;

  // Override hashCode for consistency with the overridden == operator
  @override
  int get hashCode => uid.hashCode;

  Map<String, dynamic> toJson() => {
        'name': name,
        'uid': uid,
        'photoUrl': photoUrl,
        'bio': bio,
        'username': username,
        'friends': friends,
      };

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      name: snapshot['name'],
      uid: snapshot['uid'],
      username: snapshot['username'],
      photoUrl: snapshot['photoUrl'],
      bio: snapshot['bio'],
      friends: snapshot['friends'],
    );
  }
}
