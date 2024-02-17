import 'package:boonjae/src/models/habit_model.dart';
import 'package:boonjae/src/models/post_model.dart';
import 'package:boonjae/src/services/habits_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PostsGridView extends StatefulWidget {
  final HabitModel habit;

  const PostsGridView({
    super.key,
    required this.habit,
  });

  @override
  State<PostsGridView> createState() => _PostsGridViewState();
}

class _PostsGridViewState extends State<PostsGridView> {
  List<PostModel> posts = [];

  @override
  void initState() {
    updateData();
    super.initState();
  }

  void updateData() async {
    List<PostModel> temp =
        await HabitsService().getPostsByHabit(habit: widget.habit);

    setState(() {
      posts = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200.0,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        childAspectRatio: 1,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          PostModel post = posts[index];
          return Container(
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(15.0), // Adjust the radius as needed
            ),
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: CachedNetworkImage(
                imageUrl: post.photoUrl,
                fit: BoxFit.cover,
                key: UniqueKey(),
                placeholder: (context, url) => const Text(''),
                errorWidget: (context, url, error) => const Icon(Icons.person),
              ),
            ),
          );
        },
        childCount: posts.length,
      ),
    );
  }
}
