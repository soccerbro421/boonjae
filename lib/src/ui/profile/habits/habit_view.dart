import 'package:boonjae/src/models/habit_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class HabitView extends StatelessWidget {
  final HabitModel habit;

  const HabitView({
    super.key,
    required this.habit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(habit.name),
      ),
      body: Center(
        child: Column(
          children: [
            Hero(
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
            Text(habit.description),
          ],
        ),
      ),
    );
  }
}
