import 'package:boonjae/src/models/habit_model.dart';
import 'package:boonjae/src/models/user_model.dart';
import 'package:boonjae/src/providers/user_provider.dart';
import 'package:boonjae/src/services/friends_service.dart';
import 'package:boonjae/src/services/habits_service.dart';
import 'package:boonjae/src/ui/other_profile/other_mid_sreen_user.dart';
import 'package:boonjae/src/ui/widgets/habits_list_view.dart';
import 'package:boonjae/src/ui/widgets/profile_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OtherProfileView extends StatefulWidget {
  final UserModel user;
  final String relationship;

  const OtherProfileView({
    super.key,
    required this.user,
    required this.relationship,
  });

  @override
  State<OtherProfileView> createState() => _OtherProfileViewState();
}

class _OtherProfileViewState extends State<OtherProfileView> {
  String friendStatus = '';
  List<HabitModel> otherUsersHabits = [];
  bool _isLoading = false;

  @override
  void initState() {
    checkIsFriend();
    super.initState();
  }

  checkIsFriend() async {
    String res = await FriendsService().getFriendStatus(user: widget.user);
    setState(() {
      friendStatus = res;
    });

    List<HabitModel> habitsTemp = [];
    if (widget.relationship == 'FRIEND' || widget.relationship == 'ME') {
      habitsTemp = await HabitsService().getHabitsByUser(user: widget.user);
    }

    setState(() {
      otherUsersHabits = habitsTemp;
    });
  }

  void updateHabits() async {
    setState(() {
      _isLoading = true;
    });

    List<HabitModel> temp =
        await FriendsService().acceptFriendRequest(user: widget.user);

    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();

    setState(() {
      _isLoading = false;
    });

    setState(() {
      otherUsersHabits = temp;
      friendStatus = "FRIEND";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: CustomScrollView(
        slivers: [
          ProfileAppBar(
            user: widget.user,
            refreshPage: () {},
            isCurrentUser: false,
          ),
          OtherMidScreenUserInfoView(
            user: widget.user,
            isFriend: widget.relationship == 'FRIEND',
          ),
          friendStatus == "FRIEND" ||
                  widget.relationship == 'FRIEND' ||
                  widget.relationship == 'ME'
              ? HabitsListView(
                  habits: otherUsersHabits,
                  user: widget.user,
                )
              : friendStatus == 'BLOCK'
                  ? SliverFixedExtentList(
                      delegate: SliverChildListDelegate(
                        [
                          SizedBox(
                            width: 100,
                            child: InkWell(
                              onTap: () {
                                // navigateToFriendsView(context);
                              },
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  FriendsService().unblockUser(
                                      userToBeUnblocked: widget.user);

                                  setState(() {
                                    _isLoading = false;
                                  });
                                  setState(() {
                                    friendStatus = "";
                                  });
                                },
                                icon: const Icon(Icons.group),
                                label: const Text('unblock user'),
                              ),
                            ),
                          ),
                        ],
                      ),
                      itemExtent: 50)
                  : friendStatus == "requestSent"
                      ? SliverFixedExtentList(
                          delegate: SliverChildListDelegate(
                            [
                              SizedBox(
                                width: 100,
                                child: InkWell(
                                  onTap: () {},
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        friendStatus = '';
                                      });
                                      FriendsService().cancelRequest(
                                          cancelledUser: widget.user);
                                    },
                                    icon: const Icon(Icons.cancel),
                                    label: const Text('cancel request'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          itemExtent: 50)
                      : friendStatus == "requestReceived"
                          ? SliverFixedExtentList(
                              delegate: SliverChildListDelegate(
                                [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 0, 10),
                                        child: ElevatedButton.icon(
                                          onPressed: () {
                                            setState(() {
                                              friendStatus = '';
                                            });
                                            FriendsService().denyRequest(
                                                denyingUser: widget.user);
                                          },
                                          icon: const Icon(Icons.group_remove),
                                          label:
                                              const Text('deny friend request'),
                                          style: ButtonStyle(
                                            foregroundColor:
                                                MaterialStateProperty.all<
                                                        Color>(
                                                    const Color.fromARGB(
                                                        255,
                                                        255,
                                                        133,
                                                        125)), // Text color
                                            overlayColor: MaterialStateProperty
                                                .all<Color>(Colors
                                                    .redAccent), // Ripple color
                                          ),
                                        ),
                                      ),
                                      _isLoading
                                          ? const Positioned.fill(
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 10, 0, 10),
                                              child: ElevatedButton.icon(
                                                onPressed: () {
                                                  updateHabits();
                                                },
                                                icon:
                                                    const Icon(Icons.group_add),
                                                label: const Text(
                                                    'accept friend request'),
                                              ),
                                            ),
                                    ],
                                  ),
                                ],
                              ),
                              itemExtent: 50)
                          : SliverFixedExtentList(
                              delegate: SliverChildListDelegate(
                                [
                                  SizedBox(
                                    width: 100,
                                    child: InkWell(
                                      onTap: () {
                                        // navigateToFriendsView(context);
                                      },
                                      child: _isLoading
                                          ? const CircularProgressIndicator()
                                          : ElevatedButton.icon(
                                              onPressed: () {
                                                setState(() {
                                                  _isLoading = true;
                                                });

                                                FriendsService().createRequest(
                                                    user: widget.user);

                                                setState(() {
                                                  _isLoading = false;
                                                });
                                                setState(() {
                                                  friendStatus = "requestSent";
                                                });
                                              },
                                              icon: const Icon(Icons.group_add),
                                              label: const Text(
                                                  'send friend request'),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                              itemExtent: 50)
        ],
      ),
    );
  }
}
