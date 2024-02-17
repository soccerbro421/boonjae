import 'package:boonjae/src/models/habit_model.dart';
import 'package:boonjae/src/services/habits_service.dart';
import 'package:boonjae/src/ui/mobile_view.dart';
import 'package:flutter/material.dart';

class HabitSettingsView extends StatelessWidget {

  final HabitModel habit;

  const HabitSettingsView({
    super.key,
    required this.habit,
  });

  void deleteHabit(BuildContext context) {

    HabitsService().deleteHabit(habit: habit);
    
    
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const MobileView(),
      ),
      (Route<dynamic> route) => false,
    );
  }


  // void navigateToEditProfileView(BuildContext context) {
  //   Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (context) => EditProfileView(user: user,),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: const [],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 25,
          horizontal: 20,
        ),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Divider(
              height: 1,
              thickness: 1,
            ),
            InkWell(
              onTap: () {
                
              },
              child: const SizedBox(
                width: double.infinity,
                height: 70,
                child: Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(width: 10),
                    Text('Edit Habit'),
                    Spacer(),
                    Icon(Icons.chevron_right)
                  ],
                ),
              ),
            ),
            const Divider(
              height: 1,
              thickness: 1,
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
              
                child: const Text('delete habit'),
                onPressed: () {
                  deleteHabit(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
