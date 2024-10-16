import 'package:boonjae/src/models/user_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FriendPlacementCard extends StatefulWidget {
  final UserModel user;
  final int tasksCompleted;
  final bool needsPoke;

  const FriendPlacementCard({
    required this.user,
    required this.tasksCompleted,
    required this.needsPoke,
    super.key,
  });

  @override
  State<FriendPlacementCard> createState() => _FriendPlacementCardState();
}

class _FriendPlacementCardState extends State<FriendPlacementCard> {
  @override
  Widget build(BuildContext context) {
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
        trailing: 
        widget.needsPoke ? 
        // Checkbox(
        //   value: false,
        //   onChanged: (val) {
        //     // setState(() {
        //     //   widget.onSelectedFriend(widget.user);
        //     //   // isSelected = val;
        //     // });
            
        //   },
        // ) 
        const Text("0 tasks :(")
        : Text('${widget.tasksCompleted} tasks')
        ,
        title:
            Text(widget.user.name, style: const TextStyle(color: Colors.white)),
        subtitle: Text(widget.user.username,
            style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
