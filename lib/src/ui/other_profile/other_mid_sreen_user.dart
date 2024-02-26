import 'package:boonjae/src/models/user_model.dart';
import 'package:boonjae/src/services/friends_service.dart';
import 'package:boonjae/src/ui/mobile_view.dart';
import 'package:flutter/material.dart';

class OtherMidScreenUserInfoView extends StatefulWidget {
  final UserModel user;
  final bool isFriend;

  const OtherMidScreenUserInfoView({
    super.key,
    required this.user,
    required this.isFriend,
  });

  @override
  State<OtherMidScreenUserInfoView> createState() =>
      _OtherMidScreenUserInfoViewState();
}

class _OtherMidScreenUserInfoViewState
    extends State<OtherMidScreenUserInfoView> {
  bool _isLoading = false;

  void blockUser(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    await FriendsService().blockUser(userToBeBlocked: widget.user);

    setState(() {
      _isLoading = false;
    });
    goBack(context);
  }

  void removeFriend(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    await FriendsService()
        .removeFriendCloudFunction(friendToBeRemoved: widget.user);

    setState(() {
      _isLoading = false;
    });
    goBack(context);
  }

  goBack(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const MobileView(),
      ),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverFixedExtentList(
      delegate: SliverChildListDelegate(
        [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Row(
                    children: [
                      Text(widget.user.username),
                      const SizedBox(
                        width: 10,
                      ),
                      const Spacer(),
                      PopupMenuButton(
                        itemBuilder: (BuildContext context) => [
                          const PopupMenuItem(
                              value: 'BLOCK', child: Text('Block User')),
                          if (widget.isFriend == true)
                            const PopupMenuItem(
                                value: 'REMOVE', child: Text('Remove Friend')),
                        ],
                        onSelected: (value) {
                          if (value == "BLOCK") {
                            blockUser(context);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              if (_isLoading)
                const Positioned.fill(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Row(
                children: [
                  Text(widget.user.bio),
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
