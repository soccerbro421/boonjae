import 'package:boonjae/src/models/user_model.dart';
import 'package:boonjae/src/ui/profile/friends/friend_search_card.dart';
import 'package:flutter/material.dart';

class MyFriendsView extends StatefulWidget {
  final List<UserModel> friends;

  const MyFriendsView({
    super.key,
    required this.friends,
  });

  @override
  State<MyFriendsView> createState() => _MyFriendsViewState();
}

class _MyFriendsViewState extends State<MyFriendsView> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  List<UserModel> foundUsers = [];

  @override
  initState() {
    foundUsers = widget.friends;
    super.initState();
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
    return Column(
      children: [
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
        Expanded(
          child: foundUsers.isNotEmpty
              ? ListView.builder(
                  itemCount: foundUsers.length,
                  itemBuilder: (context, index) => FriendSearchCard(
                    user: foundUsers[index],
                  ),
                )
              : const Text(
                  'No results found',
                  style: TextStyle(fontSize: 12),
                ),
        )
      ],
    );
  }
}
