import 'package:boonjae/src/models/user_model.dart';
import 'package:boonjae/src/services/friends_service.dart';
import 'package:boonjae/src/ui/profile/friends/friend_search_card.dart';
import 'package:flutter/material.dart';

class ExploreFriendsView extends StatefulWidget {
  const ExploreFriendsView({super.key});

  @override
  State<ExploreFriendsView> createState() => _ExploreFriendsViewState();
}

class _ExploreFriendsViewState extends State<ExploreFriendsView> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  List<UserModel> foundUsers = [];

  void searchUser(String enteredKeyword) async {
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      setState(() {
        foundUsers = [];
      });
    } else {
      List<UserModel> temp =
          await FriendsService().searchUsers(searchKeyword: enteredKeyword);
      setState(() {
        foundUsers = temp;
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
          child: TextFormField(
            autocorrect: false,
            // onChanged: (value) => _runFilter(value),
            onFieldSubmitted: (value) {
              searchUser(value);
            },
            controller: searchController,
            decoration: const InputDecoration(
              labelText: 'Search for a user...',
            ),
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
