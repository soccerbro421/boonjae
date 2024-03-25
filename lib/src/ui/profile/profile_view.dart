import 'dart:typed_data';

import 'package:boonjae/src/models/group_habit_model.dart';
import 'package:boonjae/src/models/habit_model.dart';
import 'package:boonjae/src/models/user_model.dart';
import 'package:boonjae/src/providers/friend_request_provider.dart';
import 'package:boonjae/src/providers/group_habits_provider.dart';
import 'package:boonjae/src/providers/habits_provider.dart';
import 'package:boonjae/src/providers/user_provider.dart';
import 'package:boonjae/src/ui/profile/habits/group_habits_list.dart';
import 'package:boonjae/src/ui/widgets/habits_list_view.dart';
import 'package:boonjae/src/ui/widgets/mid_screen_user_info.dart';
import 'package:boonjae/src/ui/widgets/profile_app_bar.dart';
// import 'package:boonjae/src/ui/widgets/sleepy_ellie.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({
    super.key,
  });

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  UserModel? user;
  List<HabitModel>? habits;
  int? numFriendRequests;
  late Uint8List? image;
  List<GroupHabitModel>? groupHabits;

  // @override
  // void initState() {
  //   // refreshPage();

  //   super.initState();
  // }

  void refreshPage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        updateData();
      });
    });
  }

  void updateData() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();

    updateHabitProvider();
    updateFriendRequestProvider();
    updateGroupHabitProvider();
  }

  void updateHabitProvider() async {
    HabitsProvider habitsProvider = Provider.of(context, listen: false);
    await habitsProvider.refreshHabits();
  }

  void updateGroupHabitProvider() async {
    GroupHabitsProvider groupHabitsProvider =
        Provider.of(context, listen: false);
    await groupHabitsProvider.refreshGroupHabits();
  }

  void updateFriendRequestProvider() async {
    FriendRequestProvider friendRequestProvider =
        Provider.of(context, listen: false);
    await friendRequestProvider.refreshNumFriendRequests();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context).getUser;
    habits = Provider.of<HabitsProvider>(context).getHabits;
    numFriendRequests =
        Provider.of<FriendRequestProvider>(context).getNumFriendRequests;
    groupHabits = Provider.of<GroupHabitsProvider>(context).getGroupHabits;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          ProfileAppBar(
            user: user!,
            refreshPage: refreshPage,
            isCurrentUser: true,
          ),
          MidScreenUserInfoView(
            user: user!,
            numFriendRequests: numFriendRequests!,
          ),
          habits != null && habits!.isNotEmpty
              ? HabitsListView(
                  habits: habits!..sort((a, b) => a.order.compareTo(b.order)),
                  user: user!)
              : const EmptyContainer(),
          groupHabits != null && groupHabits!.isNotEmpty
              ? const DividerSliver()
              : const EmptyContainer(),
          groupHabits != null && groupHabits!.isNotEmpty
              ? GroupHabitsListView(groupHabits: groupHabits!, user: user!)
              : const EmptyContainer(),
          habits != null &&
                  habits!.isEmpty &&
                  groupHabits != null &&
                  groupHabits!.isEmpty
              ? const EmptyHabitsMessage()
              : const EmptyContainer(),
        ],
      ),
    );
  }
}

class DividerSliver extends StatelessWidget {
  const DividerSliver({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverFixedExtentList(
      itemExtent: 30,
      delegate: SliverChildListDelegate([
        const Divider(
          height: 10,
          indent: 20,
          endIndent: 20,
        ),
        // const Padding(
        //   padding:  EdgeInsets.only(bottom: 8.0),
        //   child: Icon(Icons.groups),
        // ),
      ]),
    );
  }
}

class EmptyContainer extends StatelessWidget {
  const EmptyContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverFixedExtentList(
      itemExtent: 1,
      delegate: SliverChildListDelegate([Container()]),
    );
  }
}

class EmptyHabitsMessage extends StatelessWidget {
  const EmptyHabitsMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverFixedExtentList(
        delegate: SliverChildListDelegate(
          [
            const Column(
              children: [
                SizedBox(
                  height: 125.0,
                  child: RiveAnimation.asset('assets/rive/sleepy_lottie.riv'),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'click on the + to add a habit',
                )
                // style: TextStyle(
                //   fontWeight: FontWeight.bold, // Make it bold
                //   fontSize: 16.0, // Adjust the font size
                // )),
              ],
            )
          ],
        ),
        itemExtent: 170);
  }
}
