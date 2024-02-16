import 'package:boonjae/src/providers/habits_provider.dart';
import 'package:boonjae/src/providers/user_provider.dart';
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
  String username = "";
  int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    updateData();
  }

  updateData() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    HabitsProvider habitsProvider = Provider.of(context, listen: false);
    
    await userProvider.refreshUser();
    await habitsProvider.refreshHabits();

  }

  void _navigationTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Widget> _widgetOptions = <Widget>[
    
    Text('feed'),
    TodoView(),
    // SearchScreen(),
    ProfileView(),

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
