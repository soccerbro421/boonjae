import 'package:boonjae/src/models/habit_model.dart';
import 'package:boonjae/src/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool checkIsFriend({
    required UserModel currentUser,
    required UserModel otherUser,
  }) {
    return currentUser.friends.contains(otherUser.uid);
  }

  Future<List<HabitModel>> acceptFriendRequest({
    required UserModel user,
  }) async {
    try {
      String currentUserId = _auth.currentUser!.uid;

      DocumentReference userDocRef =
          _firestore.collection('users').doc(currentUserId);

      // add to my friends list
      await userDocRef.update({
        'friends': FieldValue.arrayUnion([user.uid]),
      });

      List<HabitModel> habits = [];

      CollectionReference habitsCollectionRef =
          _firestore.collection('users').doc(user.uid).collection('habits');

      QuerySnapshot habitsQuerySnapshot = await habitsCollectionRef.get();

      // Iterate through the documents in the subcollection
      for (var habitDoc in habitsQuerySnapshot.docs) {
        // Access the data of each document
        // Map<String, dynamic> habitData = habitDoc.data() as Map<String, dynamic>;

        HabitModel h = HabitModel.fromSnap(habitDoc);

        habits.add(h);

        // Use 'habitData' as needed
      }

      // update requests collection
      DocumentReference otherRequestsReference = _firestore
          .collection('requests')
          .doc(currentUserId)
          .collection('otherRequests')
          .doc(user.uid);

      await otherRequestsReference.update({
        'status': 'FRIEND',
      });

      return habits;
    } catch (err) {
      print(err.toString());
      return [];
    }
  }

  Future<List<UserModel>> getMyRequests() async {
    try {
      String currentUserId = _auth.currentUser!.uid;

      CollectionReference otherRequestsReference = _firestore
          .collection('requests')
          .doc(currentUserId)
          .collection('myRequests');

      QuerySnapshot querySnapshot = await otherRequestsReference.get();

      List<DocumentSnapshot> documents = querySnapshot.docs;

      List<String> inProgress = [];

      // CHECK STATUS ON OTHERS
      List<String> acceptedFriends = [];

      // Now 'documents' contains all documents from the 'otherRequests' collection
      for (DocumentSnapshot document in documents) {
        // Access data using document.data()
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;

        inProgress.add(data['to']);

        // Process the data as needed
      }

      if (inProgress.isNotEmpty) {
        for (int i = 0; i < inProgress.length; i++) {
          String targetId = inProgress[i];
          DocumentSnapshot targetPersonMyRequestSnapshot = await _firestore
              .collection('requests')
              .doc(targetId)
              .collection('otherRequests')
              .doc(currentUserId)
              .get();

          if (targetPersonMyRequestSnapshot.exists) {
            Map<String, dynamic> data =
                targetPersonMyRequestSnapshot.data() as Map<String, dynamic>;
            String status = data['status'];

            if (status == "FRIEND") {
              DocumentReference userDocRef =
                  _firestore.collection('users').doc(currentUserId);

              // add to my friends list
              await userDocRef.update({
                'friends': FieldValue.arrayUnion([targetId]),
              });

              // remove from other person's otherRequests and myRequests
              DocumentReference myRequestDocRef =
                  _firestore.collection('requests').doc(currentUserId).collection('myRequests').doc(targetId);
              await myRequestDocRef.delete();

              DocumentReference otherRequestDocRef =
                  _firestore.collection('requests').doc(targetId).collection('otherRequests').doc(currentUserId);
              await otherRequestDocRef.delete();

              acceptedFriends.add(targetId);
            }
          } else {
            print('Document does not exist for $targetId');
          }
        }

        if (acceptedFriends.isNotEmpty) {
          inProgress
              .removeWhere((element) => acceptedFriends.contains(element));
        }

        if (inProgress.isNotEmpty) {
          CollectionReference usersReference = _firestore.collection('users');

          QuerySnapshot queryUsersSnapshot = await usersReference
              .where(FieldPath.documentId, whereIn: inProgress)
              .get();

          List<DocumentSnapshot> userDocuments = queryUsersSnapshot.docs;

          if (userDocuments.isNotEmpty) {
            List<UserModel> usersRequested = userDocuments.map((document) {
              return UserModel.fromSnap(document);
            }).toList();

            return usersRequested;
          }
        }
      }

      return [];
    } catch (err) {
      print(err.toString());
      return [];
    }
  }

  Future<List<UserModel>> getOthersRequested() async {
    try {
      String currentUserId = _auth.currentUser!.uid;

      QuerySnapshot querySnapshot = await _firestore
          .collection('requests')
          .doc(currentUserId)
          .collection('otherRequests')
          .where('status', isNotEqualTo: 'FRIEND')
          .get();

      List<DocumentSnapshot> documents = querySnapshot.docs;

      List<String> userIds = [];

      // Now 'documents' contains all documents from the 'otherRequests' collection
      for (DocumentSnapshot document in documents) {
        // Access data using document.data()
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;

        // Process the data as needed
        userIds.add(data['from']);
      }

      if (userIds.isNotEmpty) {
        CollectionReference usersReference = _firestore.collection('users');

        QuerySnapshot queryUsersSnapshot = await usersReference
            .where(FieldPath.documentId, whereIn: userIds)
            .get();

        List<DocumentSnapshot> userDocuments = queryUsersSnapshot.docs;

        List<UserModel> usersRequested = userDocuments.map((document) {
          return UserModel.fromSnap(document);
        }).toList();

        return usersRequested;
      }

      return [];
    } catch (err) {
      print(err.toString());
      return [];
    }
  }

  // WARNING, CREATING REQUESTS DOES TWO WRITES
  createRequest({required UserModel user}) async {
    try {
      String currentUserId = _auth.currentUser!.uid;
// Create or update the 'myRequests' document for the current user
      await _firestore
          .collection('requests')
          .doc(currentUserId)
          .collection('myRequests')
          .doc(user.uid)
          .set(
        {'from': currentUserId, 'to': user.uid, 'status': 'PENDING'},
        SetOptions(merge: true),
      );

      // create
      await _firestore
          .collection('requests')
          .doc(user.uid)
          .collection('otherRequests')
          .doc(currentUserId)
          .set(
        {'from': currentUserId, 'to': user.uid, 'status': 'PENDING'},
        SetOptions(merge: true),
      );
    } catch (err) {
      print(err.toString());
    }
  }

  Future<String> getFriendStatus({
    required UserModel user,
  }) async {
    try {
      String currentUserId = _auth.currentUser!.uid;

      DocumentSnapshot myRequestsDoc = await _firestore
          .collection('requests')
          .doc(currentUserId)
          .collection('myRequests')
          .doc(user.uid)
          .get();

      DocumentSnapshot otherRequestsDoc = await _firestore
          .collection('requests')
          .doc(currentUserId)
          .collection('otherRequests')
          .doc(user.uid)
          .get();

      if (myRequestsDoc.exists) {
        String status = myRequestsDoc['status'];
        return status;
      } else if (otherRequestsDoc.exists) {
        return 'OTHER_REQUEST';
      } else {
        return 'not_found';
      }
    } catch (err) {
      return err.toString();
    }
  }

  Future<List<UserModel>> searchUsers({
    required String searchKeyword,
  }) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .orderBy('username')
          .startAt([searchKeyword.toLowerCase()])
          .endAt([
            '${searchKeyword.toLowerCase()}\uf8ff'
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
