import 'package:boonjae/src/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<UserModel>> searchUsers({
    required String searchKeyword,
  }) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .orderBy('username')
          .startAt([searchKeyword])
          .endAt([
            '$searchKeyword\uf8ff'
          ]) // '\uf8ff' is a Unicode character that ensures the search is inclusive
          .limit(5)
          .get();

      List<UserModel> users =
          querySnapshot.docs.map((doc) => UserModel.fromSnap(doc)).toList();

      return users;
    } catch (err) {
      return [];
    }
  }
}
