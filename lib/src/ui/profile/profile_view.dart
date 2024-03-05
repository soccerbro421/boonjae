import 'dart:typed_data';

import 'package:boonjae/src/models/habit_model.dart';
import 'package:boonjae/src/models/user_model.dart';
import 'package:boonjae/src/providers/habits_provider.dart';
import 'package:boonjae/src/providers/user_provider.dart';
import 'package:boonjae/src/ui/widgets/habits_list_view.dart';
import 'package:boonjae/src/ui/widgets/mid_screen_user_info.dart';
import 'package:boonjae/src/ui/widgets/profile_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  late Uint8List? image;

  // @override
  // void initState() {
  //   refreshPage();
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
  }

  void updateHabitProvider() async {
    HabitsProvider habitsProvider = Provider.of(context, listen: false);
    await habitsProvider.refreshHabits();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context).getUser;
    habits = Provider.of<HabitsProvider>(context).getHabits;

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
          ),
          habits != null && habits!.isNotEmpty
              ? HabitsListView(habits: habits!..sort((a, b) => a.order.compareTo(b.order)), user: user!)
              : const EmptyHabitsMessage(),
          // const SleepyEllie(),
        ],
      ),
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
            const Center(
              child: Text('click on the + to add a habit',
                  style: TextStyle(
                    fontWeight: FontWeight.bold, // Make it bold
                    fontSize: 16.0, // Adjust the font size
                  )),
            )
          ],
        ),
        itemExtent: 50);
  }
}
