import 'package:boonjae/src/models/habit_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class HabitCover extends StatelessWidget {
  final HabitModel habit;

  const HabitCover({
    super.key,
    required this.habit,
  });

  @override
  Widget build(BuildContext context) {
    return SliverFixedExtentList(
      itemExtent: 450,
      delegate: SliverChildListDelegate(
        [
          Center(
            child: Column(
              children: [
             
                  SizedBox(
                    height: 350,
                    width: 350,
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
        ],
      ),
    );
  }
}
