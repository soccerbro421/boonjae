import 'package:boonjae/src/models/user_model.dart';
import 'package:boonjae/src/ui/profile/friends/explore_friends_view.dart';
import 'package:boonjae/src/ui/profile/friends/friend_requests_view.dart';
import 'package:boonjae/src/ui/profile/friends/my_friends_view.dart';
import 'package:flutter/material.dart';

class FriendsView extends StatefulWidget {
  const FriendsView({super.key});

  @override
  State<FriendsView> createState() => _FriendsViewState();
}

class _FriendsViewState extends State<FriendsView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('friends'),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'my friends',
              ),
              Tab(
                text: 'explore',
              ),
              Tab(
                text: 'requests',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            MyFriendsView(friends: [UserModel(email: 'email', uid: 'uid', photoUrl: 'photoUrl', name: 'will lee', bio: 'bio', username: 'username', friends: [])],),
            ExploreFriendsView(),
            FriendRequestsView(),
          ],
        ),
      ),
    );
  }
}
