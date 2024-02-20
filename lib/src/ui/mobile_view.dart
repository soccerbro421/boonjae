import 'package:boonjae/src/models/post_model.dart';
import 'package:boonjae/src/models/user_model.dart';
import 'package:boonjae/src/providers/habits_provider.dart';
import 'package:boonjae/src/providers/user_provider.dart';
import 'package:boonjae/src/services/feed_service.dart';
import 'package:boonjae/src/ui/feed/feed_view.dart';
import 'package:boonjae/src/ui/profile/profile_view.dart';
import 'package:boonjae/src/ui/todo/todo_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MobileView extends StatefulWidget {
  const MobileView({
    super.key,
  });

  @override
  State<MobileView> createState() => _MobileViewState();
}

class _MobileViewState extends State<MobileView> {
  int _selectedIndex = 2;
  List<PostModel> feedPosts = [];

  @override
  void initState() {
    super.initState();
    updateData();
  }

  updatePosts() async {
    UserModel user = Provider.of<UserProvider>(context, listen: false).getUser;
    List<PostModel> temp = await FeedService().getFeed(user: user);
    setState(() {
      feedPosts = temp;
      _widgetOptions = <Widget>[
        FeedView(
          posts: feedPosts,
        ),
        const TodoView(),
        // SearchScreen(),
        const ProfileView(),
      ];
    });
  }

  updateData() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    HabitsProvider habitsProvider = Provider.of(context, listen: false);

    await userProvider.refreshUser();
    await updatePosts();
    await habitsProvider.refreshHabits();
  }

  void _navigationTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static List<Widget> _widgetOptions = <Widget>[
    FeedView(
      posts: const [],
    ),
    const TodoView(),
    // SearchScreen(),
    const ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    // model.User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task_alt),
            label: 'to do ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'profile',
          ),
        ],
        onTap: _navigationTapped,
        currentIndex: _selectedIndex,
      ),
    );
  }
}
