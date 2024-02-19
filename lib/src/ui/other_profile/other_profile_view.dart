import 'package:boonjae/src/models/habit_model.dart';
import 'package:boonjae/src/models/user_model.dart';
import 'package:boonjae/src/providers/user_provider.dart';
import 'package:boonjae/src/services/friends_service.dart';
import 'package:boonjae/src/services/habits_service.dart';
import 'package:boonjae/src/ui/other_profile/other_mid_sreen_user.dart';
import 'package:boonjae/src/ui/widgets/habits_list_view.dart';
import 'package:boonjae/src/ui/widgets/mid_screen_user_info.dart';
import 'package:boonjae/src/ui/widgets/profile_app_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OtherProfileView extends StatefulWidget {
  final UserModel user;
  final bool isFriend;

  const OtherProfileView({
    super.key,
    required this.user,
    required this.isFriend,
  });

  @override
  State<OtherProfileView> createState() => _OtherProfileViewState();
}

class _OtherProfileViewState extends State<OtherProfileView> {
  String friendStatus = 'PENDING';
  List<HabitModel> otherUsersHabits = [];


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
    if (widget.isFriend) {
      habitsTemp = await HabitsService().getHabitsByUser(user: widget.user);
    }

    setState(() {
      otherUsersHabits = habitsTemp;
    });
  }

  void updateHabits() async {
    List<HabitModel> temp =
        await FriendsService().acceptFriendRequest(user: widget.user);

    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();

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
          ),
          friendStatus == "FRIEND" || widget.isFriend
              ? HabitsListView(
                  habits: otherUsersHabits,
                  user: widget.user,
                )
              : friendStatus == "PENDING"
                  ? SliverFixedExtentList(
                      delegate: SliverChildListDelegate(
                        [
                          Container(
                            width: 100,
                            child: InkWell(
                              onTap: () {
                                // navigateToFriendsView(context);
                              },
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                icon: Icon(Icons.cancel),
                                label: Text('cancel request'),
                              ),
                            ),
                          ),
                        ],
                      ),
                      itemExtent: 50)
                  : friendStatus == "OTHER_REQUEST"
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
                                      updateHabits();
                                    },
                                    icon: Icon(Icons.group_add),
                                    label: Text('accept friend request'),
                                  ),
                                ),
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
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        friendStatus = "PENDING";
                                        FriendsService()
                                            .createRequest(user: widget.user);
                                      });
                                    },
                                    icon: Icon(Icons.group_add),
                                    label: Text('add user'),
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
