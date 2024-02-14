import 'package:cloud_firestore/cloud_firestore.dart';

class HabitModel {
  final String habitId;
  final String photoUrl;
  final String name;
  final String description;
  final String userId;
  final List<dynamic> daysOfWeek;
  List? tasks;

  HabitModel({
    required this.habitId,
    required this.photoUrl,
    required this.name,
    required this.description,
    required this.userId,
    required this.daysOfWeek,
    this.tasks,
  });

  Map<String, dynamic> toJson() => {
        'habitId': habitId,
        'photoUrl': photoUrl,
        'name': name,
        'description': description,
        'userId': userId,
        'daysOfWeek': daysOfWeek,
      };

  static HabitModel fromSnap(DocumentSnapshot snap) {
    

    var snapshot = snap.data() as Map<String, dynamic>;

    return HabitModel(
      name: snapshot['name'],
      userId: snapshot['userId'],
      habitId: snapshot['habitId'],
      photoUrl: snapshot['photoUrl'],
      description: snapshot['description'],
      daysOfWeek: snapshot['daysOfWeek'],
    );
  }
}
