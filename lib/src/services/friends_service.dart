import 'package:boonjae/src/models/habit_model.dart';
import 'package:boonjae/src/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  denyRequest({required UserModel denyingUser}) async {
    try {
      String currentUserId = _auth.currentUser!.uid;
      QuerySnapshot friendRequestsSnapshot = await _firestore
          .collection('friendRequests')
          .where('from', isEqualTo: denyingUser.uid)
          .where('to', isEqualTo: currentUserId)
          .get();

      for (QueryDocumentSnapshot doc in friendRequestsSnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (err) {
      // print()
    }
  }

  cancelRequest({required UserModel cancelledUser}) async {
    try {
      String currentUserId = _auth.currentUser!.uid;

      QuerySnapshot friendRequestsSnapshot = await _firestore
          .collection('friendRequests')
          .where('from', isEqualTo: currentUserId)
          .where('to', isEqualTo: cancelledUser.uid)
          .get();

      for (QueryDocumentSnapshot doc in friendRequestsSnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (err) {
      //print
    }
  }

  unblockUser({
    required UserModel userToBeUnblocked,
  }) async {
    try {
      String currentUserId = _auth.currentUser!.uid;

      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'unblockUser',
      );

      final Map<String, dynamic> data = {
        'unblockerUid': currentUserId,
        'unblockedUid': userToBeUnblocked.uid,
      };

      await callable.call(data);
    } catch (err) {
      // print(err);
    }
  }

  blockUser({
    required UserModel userToBeBlocked,
  }) async {
    try {
      String currentUserId = _auth.currentUser!.uid;

      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'blockUser',
      );

      final Map<String, dynamic> data = {
        'blockerUid': currentUserId,
        'blockedUid': userToBeBlocked.uid,
      };

      await callable.call(data);
    } catch (err) {
      // print(err);
    }
  }

  removeFriendCloudFunction({
    required UserModel friendToBeRemoved,
  }) async {
    try {
      String currentUserId = _auth.currentUser!.uid;
      String friendId = friendToBeRemoved.uid;

      await _functions.httpsCallable('removeFriend').call({
        'uid1': currentUserId,
        'uid2': friendId,
      });
    } catch (err) {
      // print(err);
    }
  }

  Future<List<UserModel>> getFriends({
    required UserModel user,
  }) async {
    try {
      if (user.friends.isEmpty) {
        return [];
      }
      QuerySnapshot userSnapshot = await _firestore
          .collection('users')
          .where(FieldPath.documentId, whereIn: user.friends)
          .get();

      List<UserModel> friends = userSnapshot.docs.map((doc) {
        return UserModel.fromSnap(doc);
      }).toList();

      return friends;
    } catch (err) {
      // print(err.toString());
      return [];
    }
  }

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

      // add users to each other

      await _functions.httpsCallable('addFriend').call({
        'uid1': currentUserId,
        'uid2': user.uid, // Assuming UserModel has a uid property
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

      QuerySnapshot friendRequestsSnapshot = await _firestore
          .collection('friendRequests')
          .where('from', isEqualTo: user.uid)
          .where('to', isEqualTo: currentUserId)
          .get();

      for (QueryDocumentSnapshot doc in friendRequestsSnapshot.docs) {
        await doc.reference.delete();
      }

      return habits;
    } catch (err) {
      // print(err.toString());
      return [];
    }
  }

  Future<int> getNumberOfIncomingFriendRequests() async {
    try {
      
      String currentUserId = _auth.currentUser!.uid;
      int result = 0;
      

      await _firestore
          .collection('friendRequests')
          .where('to', isEqualTo: currentUserId)
          .count()
          .get()
          .then((res) => result = res.count!, 
          onError: (e) => ());

      return result;

      
    } catch (err) {
      //
      return 0;
    }
  }

  Future<List<List<UserModel>>> getAllFriendRequests() async {
    try {
      String currentUserId = _auth.currentUser!.uid;

      List<List<UserModel>> res = [];

      QuerySnapshot fromMe = await _firestore
          .collection('friendRequests')
          .where('from', isEqualTo: currentUserId)
          .get();

      // Check if inputted user is in the 'to' field and current user is in the 'from' field
      QuerySnapshot toMe = await _firestore
          .collection('friendRequests')
          .where('to', isEqualTo: currentUserId)
          .get();

      List<String> usersFromMeIds = [];
      List<String> usersRequestedMeIds = [];

      if (fromMe.docs.isNotEmpty) {
        usersFromMeIds = fromMe.docs.map((doc) => doc['to'] as String).toList();
      }

      if (toMe.docs.isNotEmpty) {
        usersRequestedMeIds =
            toMe.docs.map((doc) => doc['from'] as String).toList();
      }

      // Get userIds for usersFromMe and usersRequestedMe

      // Retrieve user data for usersFromMe
      List<UserModel> usersFromMe = await getUsersByIds(usersFromMeIds);

      // Retrieve user data for usersRequestedMe
      List<UserModel> usersRequestedMe =
          await getUsersByIds(usersRequestedMeIds);

      res.add(usersFromMe);
      res.add(usersRequestedMe);

      return res;
    } catch (err) {
      return [];
    }
  }

  // WARNING, CREATING REQUESTS DOES TWO WRITES
  createRequest({required UserModel user}) async {
    try {
      String currentUserId = _auth.currentUser!.uid;

// Create or update the 'myRequests' document for the current user
      // await _firestore.collection('friendRequests').doc(requestId).set(
      //   {'from': currentUserId, 'to': user.uid, 'status': 'PENDING'},
      //   SetOptions(merge: true),
      // );

      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('createFriendRequest');
      await callable.call({
        'requestorUid': currentUserId,
        'requesteeUid': user.uid,
      });
    } catch (err) {
      // print(err.toString());
    }
  }

  Future<String> getFriendStatus({
    required UserModel user,
  }) async {
    try {
      String currentUserId = _auth.currentUser!.uid;

      DocumentSnapshot blockedUserDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .collection('usersIBlocked')
          .doc(user.uid)
          .get();

      if (blockedUserDoc.exists) {
        return 'BLOCK';
      }

      QuerySnapshot fromQuery = await _firestore
          .collection('friendRequests')
          .where('from', isEqualTo: currentUserId)
          .where('to', isEqualTo: user.uid)
          .get();

      // Check if inputted user is in the 'to' field and current user is in the 'from' field
      QuerySnapshot toQuery = await _firestore
          .collection('friendRequests')
          .where('from', isEqualTo: user.uid)
          .where('to', isEqualTo: currentUserId)
          .get();

      if (fromQuery.docs.isNotEmpty) {
        // The inputted user sent a friend request to the current user
        return 'requestSent';
      } else if (toQuery.docs.isNotEmpty) {
        // The current user sent a friend request to the inputted user
        return 'requestReceived';
      } else {
        // No friend request between the two users
        return 'notFriends';
      }
    } catch (err) {
      return err.toString();
    }
  }

  Future<List<UserModel>> searchUsers({
    required String searchKeyword,
  }) async {
    try {
      String currentUserId = _auth.currentUser!.uid;
      QuerySnapshot blockedMeSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .collection('usersBlockedMe')
          .get();

      // Extract user IDs from the documents in the 'usersBlockedMe' collection
      List<String> blockedUserIds =
          blockedMeSnapshot.docs.map((DocumentSnapshot doc) => doc.id).toList();
      // print(blockedUserIds);

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

      return users.where((user) => !blockedUserIds.contains(user.uid)).toList();
    } catch (err) {
      return [];
    }
  }

  Future<List<UserModel>> getUsersByIds(List<String> userIds) async {
    try {
      List<UserModel> users = [];

      // Retrieve users based on userIds
      for (String userId in userIds) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(userId).get();
        if (userDoc.exists) {
          UserModel user = UserModel.fromSnap(
              userDoc); // Replace with your UserModel mapping logic
          users.add(user);
        }
      }

      return users;
    } catch (error) {
      // Handle the error
      return [];
    }
  }
}
