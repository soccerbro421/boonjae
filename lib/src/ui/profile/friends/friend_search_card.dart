import 'package:boonjae/src/models/user_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FriendSearchCard extends StatelessWidget {
  final UserModel user;

  const FriendSearchCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      key: ValueKey(user.uid),
      color: Theme.of(context).scaffoldBackgroundColor,
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: CachedNetworkImage(
            imageUrl: user.photoUrl,
            fit: BoxFit.cover,
            key: UniqueKey(),
            placeholder: (context, url) => const Text(''),
            errorWidget: (context, url, error) => const Icon(Icons.person),
          ),
        ),
        title: Text(user.name, style: const TextStyle(color: Colors.white)),
        subtitle: Text(user.username, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
