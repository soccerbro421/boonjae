import 'package:boonjae/src/models/user_model.dart';
import 'package:boonjae/src/providers/user_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddFriendCard extends StatefulWidget {
  final UserModel user;
  final bool isSelected;
  final Function(UserModel) onSelectedFriend;

  const AddFriendCard({
    super.key,
    required this.user,
    required this.isSelected,
    required this.onSelectedFriend,
  });

  @override
  State<AddFriendCard> createState() => _AddFriendCardState();
}

class _AddFriendCardState extends State<AddFriendCard> {
  UserModel currentUser = const UserModel(
      uid: 'uid',
      photoUrl: 'photoUrl',
      name: 'name',
      bio: 'bio',
      username: 'username',
      friends: []);

  // bool? isSelected = false;

  @override
  Widget build(BuildContext context) {
    currentUser = Provider.of<UserProvider>(context).getUser;
    
    return Card(
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
        trailing: Checkbox(
          value: widget.isSelected,
          onChanged: (val) {
            setState(() {
              widget.onSelectedFriend(widget.user);
              // isSelected = val;
            });
            
          },
        ),
        title:
            Text(widget.user.name, style: const TextStyle(color: Colors.white)),
        subtitle: Text(widget.user.username,
            style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
