import 'package:boonjae/src/models/group_habit_model.dart';
import 'package:boonjae/src/models/user_model.dart';
import 'package:boonjae/src/ui/profile/habits/group_habit_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class GroupHabitsListView extends StatelessWidget {
  final List<GroupHabitModel> groupHabits;
  final UserModel user;

  const GroupHabitsListView({
    super.key,
    required this.groupHabits,
    required this.user,
  });

  void navigateToGroupHabitView(BuildContext context, GroupHabitModel habit) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GroupHabitView(
          habit: habit,
          user: user,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final GroupHabitModel habit = groupHabits[index];
          return InkWell(
            onTap: () {
              navigateToGroupHabitView(context, habit);
            },
            child: SizedBox(
              height: 150,
              child: Card(
                clipBehavior: Clip
                    .antiAliasWithSaveLayer, // Use Clip.antiAliasWithSaveLayer for anti-aliased clipping
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      height: 150,
                      width: 150,
                      // child: Image.network(habit.photoUrl, fit: BoxFit.cover),

                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: CachedNetworkImage(
                          imageUrl: habit.photoUrl,
                          fit: BoxFit.cover,
                          key: UniqueKey(),
                          placeholder: (context, url) => const Text(''),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.person),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              habit.name,
                              style: const TextStyle(
                                fontSize: 20, // Adjust the size as needed
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(habit.description),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        childCount: groupHabits.length,
      ),
    );
  }
}
