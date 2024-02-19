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
    List<UserModel> temp = await FriendsService().getOthersRequested();
    List<UserModel> temp2 = await FriendsService().getMyRequests();

   
      setState(() {
        othersRequested = temp;
        myRequests = temp2;
      });
   
  }

  Future<List<UserModel>> getFriends() async {
    UserModel user = Provider.of<UserProvider>(context, listen: false).getUser;

    await FriendsService().removeFriendsReceiver(user: user);

    
    // check for just accepted

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
