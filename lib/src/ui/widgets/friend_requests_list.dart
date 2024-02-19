import 'package:boonjae/src/models/user_model.dart';
import 'package:boonjae/src/ui/profile/friends/friend_search_card.dart';
import 'package:flutter/material.dart';

class FriendRequestsList extends StatelessWidget {



  final List<UserModel> othersRequested;
  const FriendRequestsList({
    super.key,
    required this.othersRequested,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      
      delegate: SliverChildBuilderDelegate(
        childCount: othersRequested.length,
        (BuildContext context, int index) {
          final UserModel user = othersRequested[index];
          return FriendSearchCard(user: user);


        },
    ));
  }
}
