import 'package:boonjae/src/models/habit_model.dart';
import 'package:boonjae/src/ui/profile/habits/habit_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class HabitsListView extends StatelessWidget {
  final List<HabitModel> habits;

  const HabitsListView({
    super.key,
    required this.habits,
  });

  void navigateToHabitView(BuildContext context, HabitModel habit) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => HabitView(
          habit: habit,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final HabitModel habit = habits[index];
          return InkWell(
            onTap: () {
              navigateToHabitView(context, habit);
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
                      child: Hero(
                        tag: habit.habitId,
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
        childCount: habits.length,
      ),
    );
  }
}



  // static List<HabitModel> habits = [
  //   HabitModel(
  //       habitId: '0',
  //       photoUrl:
  //           'https://images.unsplash.com/photo-1707489636403-c539c2cdc101?q=80&w=2874&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  //       name: 'surf',
  //       description: 'I want to start surfing',
  //       userId: 'userId',
  //       daysOfWeek: ["MON", "TUES"]),
  //   HabitModel(
  //       habitId: '1',
  //       photoUrl:
  //           'https://images.unsplash.com/photo-1705917674111-50bfa2607d05?q=80&w=3087&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  //       name: 'cook',
  //       description: 'all the food i amke',
  //       userId: 'userId',
  //       daysOfWeek: ["MON", "TUES"]),
  //   HabitModel(
  //       habitId: '0',
  //       photoUrl:
  //           'https://images.unsplash.com/photo-1703252933215-6b089d36d5bc?q=80&w=3087&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  //       name: 'hiking',
  //       description: 'adventuring',
  //       userId: 'userId',
  //       daysOfWeek: ["MON", "TUES"]),
  //   HabitModel(
  //       habitId: '0',
  //       photoUrl:
  //           'https://images.unsplash.com/photo-1558585918-601f4cf404b0?q=80&w=2874&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  //       name: 'art',
  //       description: 'art stuff',
  //       userId: 'userId',
  //       daysOfWeek: ["MON", "TUES"]),
  // ];
