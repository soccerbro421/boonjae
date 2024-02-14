import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TodoView extends StatefulWidget {
  const TodoView({super.key});

  @override
  State<TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  final List<String> daysOfWeek = ["S", "M", "T", "W", "T", "F", "S"];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('weekly tasks'),
          bottom: const TabBar(tabs: [
            Tab(text: "S"),
            Tab(text: "M"),
            Tab(text: "T"),
            Tab(text: "W"),
            Tab(text: "T"),
            Tab(text: "F"),
            Tab(text: "S"),
          ]),
        ),
        body: TabBarView(
          children: [
            Center(
              child: const Text('sun'),
            ),
            Center(
              child: const Text('mon'),
            ),
            Center(
              child: const Text('tues'),
            ),
            Center(
              child: const Text('wed'),
            ),
            Center(
              child: const Text('thur'),
            ),
            Center(
              child: const Text('fri'),
            ),
            Center(
              child: const Text('sat'),
            ),
          ],
        ),
      ),
    );
  }
}
