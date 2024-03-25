import 'package:boonjae/src/models/group_habit_model.dart';
import 'package:boonjae/src/models/post_model.dart';
import 'package:boonjae/src/models/user_model.dart';
import 'package:boonjae/src/services/habits_service.dart';
import 'package:boonjae/src/ui/feed/post_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class GroupHabitPostsGridView extends StatefulWidget {
  final GroupHabitModel habit;
  final UserModel user;
  final bool isCurrentUser;

  const GroupHabitPostsGridView({
    super.key,
    required this.habit,
    required this.isCurrentUser,
    required this.user,
  });

  @override
  State<GroupHabitPostsGridView> createState() => _GroupHabitPostsGridView();
}

class _GroupHabitPostsGridView extends State<GroupHabitPostsGridView> {
  List<PostModel> posts = [];


  navigateToPostView(BuildContext context, PostModel post) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PostView(
          post: post,
          isCurrentUser: widget.isCurrentUser,
          habit: widget.habit,
        ),
      ),
    );
  }

  @override
  void initState() {
    updateData();
    super.initState();
  }

  void updateData() async {
    List<PostModel> temp = await HabitsService().getGroupHabitPosts(
      groupHabit: widget.habit,
    );

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
          return InkWell(
            onTap: () => navigateToPostView(context, post),
            child: Container(
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
            ),
          );
        },
        childCount: posts.length,
      ),
    );
  }
}
