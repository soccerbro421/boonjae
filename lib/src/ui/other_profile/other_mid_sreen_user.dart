import 'package:boonjae/src/models/user_model.dart';
import 'package:boonjae/src/providers/user_provider.dart';
import 'package:boonjae/src/services/friends_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OtherMidScreenUserInfoView extends StatelessWidget {
  final UserModel user;
  final bool isFriend;

  const OtherMidScreenUserInfoView({
    super.key,
    required this.user,
    required this.isFriend,
  });

  void removeFriend(BuildContext context) async {
    Navigator.of(context).pop();
    await FriendsService().removeFriend(friendToBeRemoved: user);
    Provider.of<UserProvider>(context, listen: false).refreshUser();
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
                  const SizedBox(
                    width: 10,
                  ),
                  const Spacer(),
                  isFriend == true
                      ? PopupMenuButton(
                          itemBuilder: (BuildContext context) => [
                            const PopupMenuItem(
                                value: 'REMOVE',
                                child: Text('Remove Friend')),
                          ],
                          onSelected: (value) {
                            if (value == "REMOVE") {
                  
                              removeFriend(context);
                            }
                          },
                        )
                      : const Text(''),
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
