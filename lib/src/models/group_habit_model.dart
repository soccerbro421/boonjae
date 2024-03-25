import 'package:boonjae/src/models/base_habit_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupHabitModel extends BaseHabitModel{
  final String habitId;
  final String photoUrl;
  @override
  final String name;
  final String description;
  final DateTime createdDate;
  final List<dynamic> members;

  GroupHabitModel({
    required this.habitId,
    required this.photoUrl,
    required this.name,
    required this.description,
    required this.createdDate,
    required this.members,
  });

  Map<String, dynamic> toJson() => {
        'habitId': habitId,
        'photoUrl': photoUrl,
        'name': name,
        'description': description,
        'createdDate': createdDate,
        'members': members,
      };

  static GroupHabitModel fromSnap(DocumentSnapshot snap) {
    

    var snapshot = snap.data() as Map<String, dynamic>;

    return GroupHabitModel(
      name: snapshot['name'],
      habitId: snapshot['habitId'],
      photoUrl: snapshot['photoUrl'],
      description: snapshot['description'],
      createdDate: (snapshot['createdDate'] as Timestamp).toDate(),
      members: snapshot['members'],
    );
  }
}
