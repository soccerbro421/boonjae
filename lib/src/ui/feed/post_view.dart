import 'package:boonjae/src/models/post_model.dart';
import 'package:boonjae/src/services/post_service.dart';
import 'package:boonjae/src/ui/mobile_view.dart';
import 'package:boonjae/src/ui/other_profile/other_profile_from_feed.dart';
import 'package:boonjae/src/ui/widgets/report_post_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostView extends StatelessWidget {
  final PostModel post;
  final bool isCurrentUser;

  const PostView({
    super.key,
    required this.post,
    this.isCurrentUser = false,
  });

  void navigateToUser(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OtherProfileFromFeed(
          userId: post.userId,
        ),
      ),
    );
  }

  goBack(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const MobileView(),
      ),
      (Route<dynamic> route) => false,
    );
  }

  void reportPost(BuildContext context) async {
    // await FriendsService().removeFriend(friendToBeRemoved: user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        actions: [
          isCurrentUser
              ? PopupMenuButton(
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem(
                        value: 'DELETE', child: Text('Delete post')),
                  ],
                  onSelected: (value) async {
                    if (value == "DELETE") {
                      await PostService().deletePost(post: post);
                      goBack(context);
                    }
                  },
                )
              : PopupMenuButton(
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem(
                        value: 'REPORT', child: Text('Report post')),
                  ],
                  onSelected: (value) {
                    if (value == "REPORT") {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ReportPostView(
                            post: post,
                          ),
                          fullscreenDialog: true,
                        ),
                      );
                    }
                  },
                )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 16, 16, 0),
            child: InkWell(
              onTap: () {
                navigateToUser(context);
              },
              child: Text(
                post.userName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  // color: Color.fromARGB(255, 213, 178, 255)
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
            child: Text(
              post.habitName,
              style: const TextStyle(
                color: Colors.grey,
                fontStyle: FontStyle.italic,
                fontSize: 16,
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: CachedNetworkImage(
              imageUrl: post.photoUrl,
              fit: BoxFit.cover,
              key: UniqueKey(),
              // width: double.infinity, // Make the image fill the width
              // height: 200.0, // Set a fixed height for better visual appeal
              placeholder: (context, url) => const Text('Loading...'),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 32),
                  child: Text(
                    post.description,
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
                Text(
                  DateFormat('dd MMMM yyyy').format(post.createdDate),
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
