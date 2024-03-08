import 'package:boonjae/src/models/user_model.dart';
import 'package:boonjae/src/providers/user_provider.dart';
import 'package:boonjae/src/services/friends_service.dart';
import 'package:boonjae/src/ui/profile/friends/explore_friends_view.dart';
import 'package:boonjae/src/ui/profile/friends/friend_requests_view.dart';
import 'package:boonjae/src/ui/profile/friends/my_friends_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FriendsView extends StatefulWidget {
  const FriendsView({super.key});

  @override
  State<FriendsView> createState() => _FriendsViewState();
}

class _FriendsViewState extends State<FriendsView> {
  List<UserModel> othersRequested = [];
  List<UserModel> myRequests = [];
  int numFriendRequests = 0;

  // CALL ALL DATA ONCE HERE
  @override
  void initState() {
    updateData();
    super.initState();
  }

  @override
  void dispose() {
    // Cancel asynchronous operations here
    super.dispose();
  }

  Future<void> updateData() async {
    List<List<UserModel>> temp = await FriendsService().getAllFriendRequests();

    setState(() {
      
      othersRequested = temp[1];
      numFriendRequests = othersRequested.length;
      myRequests = temp[0];
    });
  }

  Future<List<UserModel>> getFriends() async {
    UserModel user = Provider.of<UserProvider>(context, listen: false).getUser;


    await Provider.of<UserProvider>(context, listen: false).refreshUser();
    List<UserModel> temp = await FriendsService().getFriends(user: user);
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('friends'),
          bottom:  TabBar(
            tabs: [
              const Tab(
                text: 'my friends',
              ),
              const Tab(
                text: 'explore',
              ),
              Tab(
                // text: 'requests',
                child: Badge(
                  label: Text(numFriendRequests.toString()),
                  isLabelVisible: numFriendRequests != 0,
                  backgroundColor: const Color.fromARGB(255, 235, 183, 244),
                  offset: const Offset(10, -10),
                  child: const Text('requests')
                ),
              ),
            ],
          ),
        ),
        body: FutureBuilder(
            future: getFriends(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return TabBarView(
                  children: [
                    MyFriendsView(
                      friends: snapshot.data!,
                    ),
                    const ExploreFriendsView(),
                    FriendRequestsView(
                      othersRequested: othersRequested,
                      myRequests: myRequests,
                      updateNumFriendRequests: updateData,
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }
}
