import 'package:boonjae/src/models/post_model.dart';
import 'package:boonjae/src/ui/feed/post_view.dart';
import 'package:boonjae/src/ui/other_profile/other_profile_from_feed.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PostTile extends StatefulWidget {
  final PostModel post;

  const PostTile({
    super.key,
    required this.post,
  });

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  final double _adAspectRatioMedium = (370 / 355);

  void navigateToUser(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OtherProfileFromFeed(
          userId: widget.post.userId,
        ),
      ),
    );
  }

  void navigateToPostView(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PostView(post: widget.post),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 16, 16, 0),
          child: InkWell(
            onTap: () {
              navigateToUser(context);
            },
            child: Text(
              widget.post.userName,
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
            widget.post.habitName,
            style: const TextStyle(
              color: Colors.grey,
              fontStyle: FontStyle.italic,
              fontSize: 16,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            navigateToPostView(context);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: CachedNetworkImage(
              imageUrl: widget.post.photoUrl,
              fit: BoxFit.cover,
              key: UniqueKey(),
              // width: double.infinity, // Make the image fill the width
              // height: 200.0, // Set a fixed height for better visual appeal
              placeholder: (context, url) =>  SizedBox(
                height:
                    MediaQuery.of(context).size.width * _adAspectRatioMedium,
                width: MediaQuery.of(context).size.width,
                child: const Text('Loading...'),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 64),
          child: Text(
            widget.post.description,
            style: const TextStyle(
              fontSize: 16.0,
            ),
          ),
        ),
      ],
    );
  }
}
