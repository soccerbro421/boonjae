import 'package:boonjae/src/models/habit_model.dart';
import 'package:boonjae/src/models/user_model.dart';
import 'package:boonjae/src/ui/widgets/task_heat_map_calendar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';

class HabitCover extends StatefulWidget {
  final HabitModel habit;
  final UserModel user;

  const HabitCover({
    super.key,
    required this.habit,
    required this.user,
  });

  @override
  State<HabitCover> createState() => _HabitCoverState();
}

class _HabitCoverState extends State<HabitCover> {
  late int selectedPage;
  late final PageController _pageController;
  late final TaskHeatMapCalendar _taskHeatMapCalendar;

  @override
  void initState() {
    selectedPage = 0;
    _pageController = PageController(initialPage: selectedPage);
    _taskHeatMapCalendar = TaskHeatMapCalendar(habit: widget.habit, user: widget.user);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> itemsToDisplay = [
      ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: CachedNetworkImage(
          imageUrl: widget.habit.photoUrl,
          fit: BoxFit.cover,
          key: UniqueKey(),
          placeholder: (context, url) => const Text(''),
          errorWidget: (context, url, error) => const Icon(Icons.person),
        ),
      ),
      _taskHeatMapCalendar
    ];
    return SliverFixedExtentList(
      itemExtent: 460,
      delegate: SliverChildListDelegate(
        [
          Center(
            child: Column(
              children: [
                SizedBox(
                  height: 350,
                  width: 350,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (page) {
                        setState(() {
                          selectedPage = page;
                        });
                      },
                      children: itemsToDisplay,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: PageViewDotIndicator(
                    currentItem: selectedPage,
                    count: 2,
                    size: const Size(8, 8),
                    unselectedColor: const Color.fromARGB(255, 114, 114, 114),
                    unselectedSize: const Size(6, 6),
                    selectedColor: const Color.fromARGB(255, 182, 154, 187),

                    // onItemClicked: (index) {
                    //   _pageController.animateToPage(index, duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
                    // },
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.habit.description),
                ),
                const SizedBox(height: 8),
                Text(
                  'started on ${DateFormat('dd MMMM yyyy').format(widget.habit.createdDate)}',
                  style: const TextStyle(
                    color: Colors.grey,
                    // fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
