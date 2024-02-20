import 'package:boonjae/src/models/habit_model.dart';
import 'package:boonjae/src/models/user_model.dart';
import 'package:boonjae/src/providers/user_provider.dart';
import 'package:boonjae/src/services/feed_service.dart';
import 'package:boonjae/src/ui/other_profile/other_profile_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OtherProfileFromFeed extends StatefulWidget {
  final String userId;

  const OtherProfileFromFeed({
    super.key,
    required this.userId,
  });

  @override
  State<OtherProfileFromFeed> createState() => _OtherProfileFromFeedState();
}

class _OtherProfileFromFeedState extends State<OtherProfileFromFeed> {
  String friendStatus = '';
  List<HabitModel> otherUsersHabits = [];

  @override
  void initState() {
    super.initState();
  }

  Future<UserModel> getUser() async {
    UserModel temp = await FeedService().getUserByUserId(userId: widget.userId);
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserProvider>(context).getUser;
    return FutureBuilder(
      future: getUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return OtherProfileView(user: snapshot.data!, relationship: user.uid == widget.userId ? 'ME' : 'FRIEND');
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
