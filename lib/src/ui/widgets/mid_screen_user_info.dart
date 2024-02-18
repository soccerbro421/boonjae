import 'package:boonjae/src/models/user_model.dart';
import 'package:boonjae/src/ui/profile/friends/friends_view.dart';
import 'package:boonjae/src/ui/profile/habits/add_habit_view.dart';
import 'package:flutter/material.dart';

class MidScreenUserInfoView extends StatelessWidget {
  final UserModel user;

  const MidScreenUserInfoView({
    required this.user,
    super.key,
  });

  void navigateToAddHabitView(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddHabitView(),
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
                  Text(user.username),
                  const SizedBox(width: 10,),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      navigateToFriendsView(context);
                    },
                    child: const Icon(Icons.group),
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
                    child: const Icon(Icons.add),
                  ),
                  // ElevatedButton.icon(
                  //   onPressed: () {
                  //     navigateToAddHabitView(context);
                  //   },
                  //   icon: const Icon(Icons.add),
                  //   label: const Text('add habit'),
                  // )
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
