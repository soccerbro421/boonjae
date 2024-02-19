import 'package:boonjae/src/models/post_model.dart';
import 'package:boonjae/src/services/feed_service.dart';
import 'package:boonjae/src/ui/feed/post_tile.dart';
import 'package:flutter/material.dart';

// TODO: USE FUTURE BUILDER HERE !!!!!!


//
//
//
// USE FUTURE BUILDer
//
//
//
//

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
    List<PostModel> temp = await FeedService().getFeed();

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
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: widget.posts.length,
                (BuildContext context, int index) {
                  final PostModel post = widget.posts[index];
                  return PostTile(post: post);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
