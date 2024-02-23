import 'package:boonjae/src/models/user_model.dart';
import 'package:boonjae/src/providers/user_provider.dart';
import 'package:boonjae/src/services/friends_service.dart';
import 'package:boonjae/src/ui/profile/friends/friend_search_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyFriendsView extends StatefulWidget {
   List<UserModel> friends;

   MyFriendsView({
    super.key,
    required this.friends,
  });

  @override
  State<MyFriendsView> createState() => _MyFriendsViewState();
}

class _MyFriendsViewState extends State<MyFriendsView> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;
  bool isLoading = false;

  List<UserModel> foundUsers = [];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  initState() {
    foundUsers = widget.friends;
    super.initState();
  }

  Future refreshFriends() async {
    setState(() {
      isLoading = true;
    });

    List<UserModel> temp = await getFriends();

    setState(() {
      foundUsers = temp;
    });

    setState(() {
      isLoading = false;
    });
  }

    Future<List<UserModel>> getFriends() async {
    UserModel user = Provider.of<UserProvider>(context, listen: false).getUser;

    // await FriendsService().removeFriendsReceiver(user: user);

    
    // check for just accepted

    await Provider.of<UserProvider>(context, listen: false).refreshUser();
    List<UserModel> temp = await FriendsService().getFriends(user: user);
    return temp;
  }

  void _runFilter(String enteredKeyword) {
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      setState(() {
        foundUsers = widget.friends;
      });
    } else {
      setState(() {
        foundUsers = widget.friends
            .where((user) => user.username
                .toLowerCase()
                .contains(enteredKeyword.toLowerCase()))
            .toList();
      });

      // we use the toLowerCase() method to make it case-insensitive
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshFriends,
   
      child: CustomScrollView(
        slivers: [
          SliverFixedExtentList(
            itemExtent: 100.0,
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    onChanged: (value) => _runFilter(value),
                    controller: searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search for a friend...',
                    ),
                    autocorrect: false,
                  ),
                ),
              ],
            ),
          ),
          foundUsers.isNotEmpty
              ? SliverList(delegate: SliverChildBuilderDelegate(
                childCount: foundUsers.length,
                  (BuildContext context, int index) {
                    return FriendSearchCard(
                      user: foundUsers[index],
                    );
                  },
                ))
              : SliverFixedExtentList(
                  itemExtent: 50.0,
                  delegate: SliverChildListDelegate(
                    [
                      const Center (child: Text(
                        'No results found',
                        style: TextStyle(fontSize: 12),
                      ),)
                    ],
                  ),
                )
        ],
      ),
    );
  }
}
