import 'package:boonjae/src/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class OtherMidScreenUserInfoView extends StatelessWidget {
  final UserModel user;

  const OtherMidScreenUserInfoView({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return SliverFixedExtentList(
      delegate: SliverChildListDelegate(
        [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Row(
                children: [
                  Text(user.username),
                  const SizedBox(
                    width: 10,
                  ),
                  const Spacer(),
                  
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Row(
                children: [
                  Text(user.bio),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
      itemExtent: 50.0,
    );
  }
}
