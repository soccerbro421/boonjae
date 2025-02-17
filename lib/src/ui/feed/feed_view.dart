import 'package:boonjae/src/models/group_habit_model.dart';
import 'package:boonjae/src/models/post_model.dart';
import 'package:boonjae/src/models/user_model.dart';
import 'package:boonjae/src/providers/group_habits_provider.dart';
import 'package:boonjae/src/providers/user_provider.dart';
import 'package:boonjae/src/services/feed_service.dart';
import 'package:boonjae/src/ui/ads/native_ads.dart';
import 'package:boonjae/src/ui/feed/post_tile.dart';
import 'package:boonjae/src/ui/widgets/idle_ellie.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

//
//
//
// USE FUTURE BUILD
//
//
//
//

// ignore: must_be_immutable
class FeedView extends StatefulWidget {
  List<PostModel> posts;

  FeedView({
    super.key,
    required this.posts,
  });

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  bool isLoading = false;

  // @override
  // void initState() {
  //   updateData();
  //   super.initState();
  // }

  Future refreshFeed() async {
    setState(() {
      isLoading = true;
    });

    await updateData();

    setState(() {
      isLoading = false;
    });
  }

  updateData() async {
    UserModel user = Provider.of<UserProvider>(context, listen: false).getUser;
    List<GroupHabitModel> groupHabits =
        Provider.of<GroupHabitsProvider>(context, listen: false).getGroupHabits;
    List<PostModel> temp = await FeedService().getFeed(
      user: user,
      groupHabits: groupHabits,
    );

    setState(() {
      widget.posts = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts for the week'),
      ),
      body: RefreshIndicator(
        onRefresh: refreshFeed,
        child: widget.posts.isEmpty
            ? ListView(
                children: const [
                  Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 125.0,
                        child: RiveAnimation.asset(
                            'assets/rive/sleepy_lottie.riv'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                          child: Text(
                        'no posts for the week',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize:
                              18.0, // You can adjust the font size as needed
                        ),
                      )),
                      Center(child: Text('(upload post to wake Ellie up!)')),
                    ],
                  )
                ],
              )
            : CustomScrollView(
                slivers: [
                  const IdleEllie(),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        int tempTotal =
                            widget.posts.length + (widget.posts.length ~/ 5);
                        final int totalItems =
                            widget.posts.length < 5 ? tempTotal + 1 : tempTotal;
                        if (widget.posts.length < 5 &&
                            index == totalItems - 1) {
                          // Display an ad at the end of the list
                          return const NativeExample();
                          // return Text('hi');
                        } else if (index % 6 == 5) {
                          // Display an ad after every fifth post (assuming indexing starts from 0)
                          return const NativeExample();
                        } else {
                          final int postIndex = index - (index ~/ 6);
                          final PostModel post = widget.posts[postIndex];
                          return PostTile(
                            post: post,
                          );
                        }
                      },
                      childCount: widget.posts.length < 5
                          ? widget.posts.length + (widget.posts.length ~/ 5) + 1
                          : widget.posts.length + (widget.posts.length ~/ 5),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
