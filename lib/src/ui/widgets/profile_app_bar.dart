import 'dart:typed_data';

import 'package:boonjae/src/models/user_model.dart';
import 'package:boonjae/src/ui/profile/settings/settings_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfileAppBar extends StatelessWidget {
  final UserModel user;
  final Uint8List? image;
  final void Function() refreshPage;
  final bool isCurrentUser;

  const ProfileAppBar({
    required this.user,
    this.image,
    required this.refreshPage,
    required this.isCurrentUser,
    super.key,
  });

  void navigateToSettings(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SettingsView(user: user),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      
      // title: Text('my profile'),
      stretch: true,
      onStretchTrigger: () async {
        refreshPage();
      },
      expandedHeight: 350.0,
      pinned: true,
      // backgroundColor: Colors.grey[400],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        stretchModes: const [
          StretchMode.blurBackground,
          StretchMode.zoomBackground,
        ],
        title: Row(
          children: [
            Text(user.name, softWrap: true,),
            const Spacer(),
            isCurrentUser == true ?
              IconButton(
                onPressed: () {
                  navigateToSettings(context);
                },
                icon: const Icon(Icons.more_horiz_sharp),
              ) : const Text(''),
          ],
        ),
        background: DecoratedBox(
            position: DecorationPosition.foreground,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.center,
                colors: [
                  Theme.of(context).scaffoldBackgroundColor,
                  Colors.transparent,
                ],
              ),
            ),
            child:
                // image != null ? Image(
                //   image: MemoryImage(image!),
                //   fit: BoxFit.cover,
                //   gaplessPlayback: true,
                // ): const Text(''),
                // Image.file(
                //   profileImage,
                //   fit: BoxFit.cover,
                // ),
                CachedNetworkImage(
              imageUrl: user.photoUrl,
              fit: BoxFit.cover,
              key: UniqueKey(),
              placeholder: (context, url) => const Text(''),
              errorWidget: (context, url, error) => const Icon(Icons.person),
            )

            //  Image.network(
            //   user.photoUrl,
            //   fit: BoxFit.cover,
            // ),

            //     FutureBuilder<File>(
            //   future: getImageFile(),
            //   builder: (context, snapshot) {
            //     if (snapshot.connectionState == ConnectionState.done) {
            //       if (snapshot.hasData) {
            //         return Image.file(snapshot.data!, fit: BoxFit.cover);
            //       } else {
            //         return Text("no image found");
            //       }
            //     } else {
            //       return CircularProgressIndicator();
            //     }
            //   },
            // ),
            ),
      ),
    );
  }
}
