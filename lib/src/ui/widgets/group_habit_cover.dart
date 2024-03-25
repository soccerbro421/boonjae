import 'package:boonjae/src/models/group_habit_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GroupHabitCover extends StatelessWidget {
  final GroupHabitModel habit;

  const GroupHabitCover({
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(habit.description),
                ),
                const SizedBox(height: 8),
                Text(
                  'started on ${DateFormat('dd MMMM yyyy').format(habit.createdDate)}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
