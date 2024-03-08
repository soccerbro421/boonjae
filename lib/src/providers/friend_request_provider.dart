import 'package:boonjae/src/services/friends_service.dart';
import 'package:flutter/material.dart';

class FriendRequestProvider with ChangeNotifier {
  int? _numFriendRequests;

  int get getNumFriendRequests {
    if (_numFriendRequests == null) {
      return 0;
    }

    return _numFriendRequests!;
  }


  Future<void> refreshNumFriendRequests() async {
    int temp = await FriendsService().getNumberOfIncomingFriendRequests();
    _numFriendRequests = temp;

    notifyListeners();
  }


}