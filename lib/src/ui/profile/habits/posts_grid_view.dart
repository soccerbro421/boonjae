import 'package:boonjae/src/models/habit_model.dart';
import 'package:boonjae/src/models/post_model.dart';
import 'package:boonjae/src/models/user_model.dart';
import 'package:boonjae/src/services/habits_service.dart';
import 'package:boonjae/src/ui/feed/post_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PostsGridView extends StatefulWidget {
  final HabitModel habit;
  final UserModel user;
  final bool isCurrentUser;

  const PostsGridView({
    super.key,
    required this.habit,
    required this.isCurrentUser,
    required this.user,
  });

  @override
  State<PostsGridView> createState() => _PostsGridViewState();
}

class _PostsGridViewState extends State<PostsGridView> {
  List<PostModel> posts = [];


  navigateToPostView(BuildContext context, PostModel post) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PostView(
          post: post,
          isCurrentUser: widget.isCurrentUser,
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
    List<PostModel> temp = await HabitsService().getPostsByHabitAndUser(
      habit: widget.habit,
      user: widget.user,
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
