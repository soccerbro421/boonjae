import 'package:boonjae/src/models/user_model.dart';
import 'package:boonjae/src/ui/profile/friends/friends_view.dart';
import 'package:boonjae/src/ui/profile/habits/add_habit.dart';
import 'package:flutter/material.dart';

class MidScreenUserInfoView extends StatelessWidget {
  final UserModel user;
  final int numFriendRequests;

  const MidScreenUserInfoView({
    required this.user,
    required this.numFriendRequests,
    super.key,
  });

  void navigateToAddHabitView(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddHabit(),
      ),
    );
  }

  void navigateToFriendsView(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const FriendsView(),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return SliverFixedExtentList(
      delegate: SliverChildListDelegate(
        [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Row(
                children: [
                  Text(
                    user.username,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Spacer(),
                  // FutureBuilder<int>(
                  //     future: getNumOfFriendRequested(),
                  //     builder: (context, snapshot) {
                  //       if (snapshot.hasData) {
                  //         return Badge(
                  //           label: Text(snapshot.data.toString()),
                  //           isLabelVisible: snapshot.data != 0,
                  //           backgroundColor:
                  //               const Color.fromARGB(255, 235, 183, 244),
                  //           child: InkWell(
                  //             onTap: () {
                  //               navigateToFriendsView(context);
                  //             },
                  //             child: const Icon(Icons.group),
                  //           ),
                  //         );
                  //       } else {
                  //         return InkWell(
                  //           onTap: () {
                  //             navigateToFriendsView(context);
                  //           },
                  //           child: const Icon(Icons.group),
                  //         );
                  //       }
                  //     }),
                  Badge(
                    label: Text(numFriendRequests.toString()),
                    isLabelVisible: numFriendRequests != 0,
                    backgroundColor: const Color.fromARGB(255, 235, 183, 244),
                    child: InkWell(
                      onTap: () {
                        navigateToFriendsView(context);
                      },
                      child: const Icon(Icons.group),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Row(
                children: [
                  Text(user.bio),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      navigateToAddHabitView(context);
                    },
                    child: const Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      itemExtent: 50.0,
    );
  }
}
