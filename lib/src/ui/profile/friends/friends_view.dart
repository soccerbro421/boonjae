import 'package:boonjae/src/models/user_model.dart';
import 'package:boonjae/src/services/friends_service.dart';
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
  List<UserModel> othersRequested = [];
  List<UserModel> myRequests = [];

  // CALL ALL DATA ONCE HERE
  @override
  void initState() {
    updateData();
    super.initState();
  }

  void updateData() async {
    List<UserModel> temp = await FriendsService().getOthersRequested();
    List<UserModel> temp2 = await FriendsService().getMyRequests();

    setState(() {
      othersRequested = temp;
      myRequests = temp2;
    });
  }

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
        body: TabBarView(
          children: [
            const MyFriendsView(
              friends: [
                UserModel(
                    email: 'email',
                    uid: 'uid',
                    photoUrl: 'photoUrl',
                    name: 'will lee',
                    bio: 'bio',
                    username: 'username',
                    friends: [])
              ],
            ),
            const ExploreFriendsView(),
            FriendRequestsView(
              othersRequested: othersRequested,
              myRequests: myRequests,
            ),
          ],
        ),
      ),
    );
  }
}
