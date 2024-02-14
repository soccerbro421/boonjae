import 'package:boonjae/src/models/user_model.dart';
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
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text(
                      'friends',
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
                  ElevatedButton.icon(
                    onPressed: () {
                      navigateToAddHabitView(context);
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('add habit'),
                  )
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
