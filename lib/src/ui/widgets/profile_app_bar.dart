import 'package:boonjae/src/models/user_model.dart';
import 'package:boonjae/src/ui/profile/settings/settings_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfileAppBar extends StatelessWidget {
  final UserModel user;
  final void Function() refreshPage;

  const ProfileAppBar({
    required this.user,
    required this.refreshPage,
    super.key,
  });

  void navigateToSettings(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SettingsView(),
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
            // if (context.watch<MainUser>().mainUser != null)

            Text(user.name),

            const Spacer(),
            IconButton(
              onPressed: () {
                navigateToSettings(context);
              },
              icon: const Icon(Icons.more_horiz_sharp),
            ),
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
                  ]),
            ),
            child: CachedNetworkImage(
              imageUrl: user.photoUrl,
              fit: BoxFit.cover,
              key: UniqueKey(),
              placeholder: (context, url) => const Text(''),
              errorWidget: (context, url, error) => const Icon(Icons.person),
            )

            //  Image.network(
            //   user!.photoUrl,
            //   fit: BoxFit.cover,
            // ),
            ),
      ),
    );
  }
}
