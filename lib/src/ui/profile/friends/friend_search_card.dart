import 'package:boonjae/src/models/user_model.dart';
import 'package:boonjae/src/providers/user_provider.dart';
import 'package:boonjae/src/ui/other_profile/other_profile_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FriendSearchCard extends StatefulWidget {
  final UserModel user;

  const FriendSearchCard({
    super.key,
    required this.user,
  });

  @override
  State<FriendSearchCard> createState() => _FriendSearchCardState();
}

class _FriendSearchCardState extends State<FriendSearchCard> {
  UserModel currentUser = const UserModel(

      uid: 'uid',
      photoUrl: 'photoUrl',
      name: 'name',
      bio: 'bio',
      username: 'username',
      friends: []);

  void navigateToOtherProfileView(BuildContext context, UserModel currentUser) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OtherProfileView(
          user: widget.user,
          isFriend: currentUser.friends.contains(widget.user.uid),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    currentUser = Provider.of<UserProvider>(context).getUser;
    return InkWell(
      onTap: () {
        navigateToOtherProfileView(context, currentUser);
      },
      child: Card(
        key: ValueKey(widget.user.uid),
        color: Theme.of(context).scaffoldBackgroundColor,
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: CachedNetworkImage(
              imageUrl: widget.user.photoUrl,
              fit: BoxFit.cover,
              key: UniqueKey(),
              placeholder: (context, url) => const Text(''),
              errorWidget: (context, url, error) => const Icon(Icons.person),
            ),
          ),
          title: Text(widget.user.name,
              style: const TextStyle(color: Colors.white)),
          subtitle: Text(widget.user.username,
              style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
