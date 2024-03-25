import 'package:boonjae/src/models/group_habit_model.dart';
import 'package:boonjae/src/models/user_model.dart';
import 'package:boonjae/src/providers/user_provider.dart';
import 'package:boonjae/src/services/friends_service.dart';
import 'package:boonjae/src/ui/widgets/add_friend_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class EditMembersGroupHabitView extends StatefulWidget {
  final List<UserModel> addedFriends;
  final Function(List<UserModel>) onAddFriends;
  final GroupHabitModel groupHabit;

  const EditMembersGroupHabitView({
    super.key,
    required this.addedFriends,
    required this.onAddFriends,
    required this.groupHabit,
  });

  @override
  State<EditMembersGroupHabitView> createState() =>
      _EditMembersGroupHabitViewState();
}

class _EditMembersGroupHabitViewState extends State<EditMembersGroupHabitView> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;
  bool isLoading = false;

  List<UserModel> allFriends = [];
  List<UserModel> selectedFriends = [];

  List<UserModel> foundUsers = [];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  initState() {
    selectedFriends = widget.addedFriends;
    refreshFriends();
    super.initState();
  }

  Future refreshFriends() async {
    setState(() {
      isLoading = true;
    });

    List<UserModel> temp = await getFriends();

    setState(() {
      // widget.addedFriends = temp;
      allFriends = temp;
      foundUsers = temp;
    });

    setState(() {
      isLoading = false;
    });
  }

  Future<List<UserModel>> getFriends() async {
        UserModel user = Provider.of<UserProvider>(context, listen: false).getUser;

    List<UserModel> temp = await FriendsService().getPotentialUsersInHabit(
      groupHabit: widget.groupHabit,
      user: user,
    );
    return temp;
  }

  void _runFilter(String enteredKeyword) {
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      setState(() {
        foundUsers = allFriends;
      });
    } else {
      setState(() {
        foundUsers = allFriends
            .where((user) => user.username
                .toLowerCase()
                .contains(enteredKeyword.toLowerCase()))
            .toList();
      });

      // we use the toLowerCase() method to make it case-insensitive
    }
  }

  void selectFriend(UserModel user) {
    final isSelected = selectedFriends.contains(user);
    setState(() {
      isSelected ? selectedFriends.remove(user) : selectedFriends.add(user);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              child: const Row(children: [Text('Save')]),
              // Icon(Icons.add), // Change the icon to your desired button icon
              onPressed: () {
                widget.onAddFriends(selectedFriends);
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: refreshFriends,
        child: FutureBuilder(
            future: getFriends(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Column(
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
                      foundUsers.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: foundUsers.length,
                              itemBuilder: (BuildContext context, int index) {
                                final isSelected =
                                    selectedFriends.contains(foundUsers[index]);

                                return AddFriendCard(
                                  user: foundUsers[index],
                                  isSelected: isSelected,
                                  onSelectedFriend: selectFriend,
                                );
                              },
                            )
                          : const Center(
                              child: Text(
                                'No results found',
                                style: TextStyle(fontSize: 12),
                              ),
                            )
                    ],
                  ),
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
