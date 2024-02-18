import 'package:boonjae/src/models/post_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PostTile extends StatelessWidget {
  final PostModel post;

  const PostTile({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 16, 16, 4),
            child: Text(
              post.userName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                // color: Color.fromARGB(255, 213, 178, 255)
              ),
            ),
          ),
          Padding(
        padding: const EdgeInsets.fromLTRB(8, 10, 0, 0),
        child: Text(
          post.habitName,
          style: const TextStyle(
            color: Colors.grey,
            fontStyle: FontStyle.italic,
            fontSize: 16,
          ),
        ),
      ),
        ],
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
      Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 64),
        child: Text(
          post.description,
          style: const TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    ],
  );
}

}
