import 'package:boonjae/src/models/user_model.dart';
import 'package:boonjae/src/services/activity_service.dart';
import 'package:boonjae/src/ui/activity/friend_placement_card.dart';
import 'package:boonjae/src/ui/widgets/user_skeleton_loading.dart';
import 'package:flutter/material.dart';

class TopFiveFriendsActivity extends StatefulWidget {
  final UserModel currentUser;

  const TopFiveFriendsActivity({
    required this.currentUser,
    super.key,
  });

  @override
  State<TopFiveFriendsActivity> createState() => _TopFiveFriendsActivityState();
}

class _TopFiveFriendsActivityState extends State<TopFiveFriendsActivity> {
  // @override
  // void initState() {
  //   Map res =  ActivityService().getThisWeekLeaderboard(currentUser: widget.currentUser);
  //   super.initState();
  // }

  Future<Map<String, dynamic>> getData() async {
    Map<String, dynamic> temp = {};

    if (widget.currentUser.friends.isEmpty) {
      return temp;
    }

    Map<String, dynamic> res = await ActivityService()
        .getThisWeekLeaderboard(currentUser: widget.currentUser);
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While data is being fetched
          //  return Shimmer.fromColors(
          //       baseColor: Color.fromARGB(255, 81, 81, 81),
          //       highlightColor: Color.fromARGB(255, 152, 152, 152),
          //       child: const UserSkeletonLoading(),
          //   );
          return const UserSkeletonLoading();
        } else if (snapshot.hasError) {
          // If an error occurs during fetching
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          // If data is successfully fetched
          Map<String, dynamic> data = snapshot.data!;

          if (data.isEmpty) {
            return const SizedBox();
          }

          List<dynamic> topFriends = data['topFriends'];
          List<dynamic> bottomFriends = data['pokeFriends'];

          return Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              topFriends.isNotEmpty
                  ? const Text("look at your friends go :D")
                  : Container(),
              ListView.builder(
                shrinkWrap: true,
                itemCount: topFriends.length,
                itemBuilder: (context, index) {
                  int score = topFriends[index][0];
                  UserModel user = topFriends[index][1];
                  return FriendPlacementCard(
                    user: user,
                    tasksCompleted: score,
                    needsPoke: false,
                  );
                },
              ),
              const SizedBox(
                height: 25,
              ),
              bottomFriends.isNotEmpty
                  ? const Text("friends that could use a lil poke")
                  : Container(),
              ListView.builder(
                shrinkWrap: true,
                itemCount: bottomFriends.length,
                itemBuilder: (context, index) {
                  UserModel user = bottomFriends[index];
                  return FriendPlacementCard(
                    user: user,
                    tasksCompleted: 0,
                    needsPoke: true,
                  );
                },
              ),
            ],
          );
        }
      },
    );
  }
}
