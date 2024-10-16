import 'package:boonjae/src/models/habit_model.dart';
import 'package:boonjae/src/models/user_model.dart';
import 'package:boonjae/src/providers/habits_provider.dart';
import 'package:boonjae/src/providers/user_provider.dart';
import 'package:boonjae/src/ui/activity/past_week_activity.dart';
import 'package:boonjae/src/ui/activity/top_5_friends.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

class ActivityView extends StatefulWidget {
  const ActivityView({super.key});

  @override
  State<ActivityView> createState() => _ActivityViewState();
}

class _ActivityViewState extends State<ActivityView> {
  List<HabitModel> habits = [];
  UserModel user = const UserModel(
      uid: 'uid',
      photoUrl: 'photoUrl',
      name: 'name',
      bio: 'bio',
      username: 'username',
      friends: []);

  @override
  Widget build(BuildContext context) {
    habits = Provider.of<HabitsProvider>(context).getHabits;
    user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity'),
      ),
      body: habits.isNotEmpty
          ? ListView(
              children: [
                // Add your other widgets here
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PastWeekActivity(habits: habits),
                ),
                SizedBox(
                  height: 700,
                    child: TopFiveFriendsActivity(
                  currentUser: user,
                )),
                // Add more children widgets here
              ],
            )
          : ListView(
              children: const [
                SizedBox(
                  height: 125.0,
                  child: RiveAnimation.asset('assets/rive/sleepy_lottie.riv'),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    'create a habit on your profile to see activity !',
                    style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        // fontSize: 18.0, // You can adjust the font size as needed
                        ),
                  ),
                ),
              ],
            ),
    );
  }
}
