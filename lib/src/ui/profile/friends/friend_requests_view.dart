import 'package:boonjae/src/models/user_model.dart';
import 'package:boonjae/src/services/friends_service.dart';
import 'package:boonjae/src/ui/widgets/friend_requests_list.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FriendRequestsView extends StatefulWidget {
   List<UserModel> othersRequested;
   List<UserModel> myRequests;

   FriendRequestsView({
  super.key,
    required this.othersRequested,
    required this.myRequests,
  });

  @override
  State<FriendRequestsView> createState() => _FriendRequestsViewState();
}

class _FriendRequestsViewState extends State<FriendRequestsView> {

  bool isLoading = false;


  Future refreshRequests() async {
setState(() {
      isLoading = true;
    });

    await updateData();

    setState(() {
      isLoading = false;
    });
  }

  updateData() async {

    List<List<UserModel>> temp = await FriendsService().getAllFriendRequests();

    setState(() {
        widget.othersRequested = temp[1];
        widget.myRequests = temp[0];
      });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refreshRequests,
        child: CustomScrollView(
          slivers: [
            widget.othersRequested.isNotEmpty
                ? RequestSliverHeader(text: 'Friend Requests')
                : RequestSliverHeader(text: ''),
            FriendRequestsList(othersRequested: widget.othersRequested),
            widget.myRequests.isNotEmpty
                ? RequestSliverHeader(text: 'Your Requests')
                : RequestSliverHeader(text: ''),
            FriendRequestsList(othersRequested: widget.myRequests),
            widget.myRequests.isEmpty && widget.othersRequested.isEmpty
                ? RequestSliverHeader(
                    text: 'Your friend requests will be found here',
                    soleText: true,
                  )
                : RequestSliverHeader(text: ''),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class RequestSliverHeader extends StatelessWidget {
  final String text;
  bool soleText;
  RequestSliverHeader({
    super.key,
    required this.text,
    this.soleText = false,
  });

  @override
  Widget build(BuildContext context) {
    return SliverFixedExtentList(
        delegate: SliverChildListDelegate(
          [
            soleText
                ? Center(
                    child: Text(text),
                  )
                : Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0, 0),
                    child: Text(text),
                  ),
          ],
        ),
        itemExtent: 25);
  }
}
