import 'package:boonjae/src/db/tasks_database.dart';
import 'package:boonjae/src/models/habit_model.dart';
import 'package:boonjae/src/ui/widgets/legend_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PastWeekActivity extends StatefulWidget {
  final List<HabitModel> habits;

  const PastWeekActivity({
    required this.habits,
    super.key,
  });

  @override
  State<PastWeekActivity> createState() => _PastWeekActivityState();
}

class _PastWeekActivityState extends State<PastWeekActivity> {
  List<Map<String, int>> _currentAndNextWeekTasksCount = [];

  @override
  void initState() {
    super.initState();
    _fetchTasksCountByWeek();
  }

  Future<void> _fetchTasksCountByWeek() async {
    try {
      final tasksDatabase = TasksDatabase.instance;
      final tasksCountByWeek =
          await tasksDatabase.getTasksCountByWeek(habits: widget.habits);
      setState(() {
        _currentAndNextWeekTasksCount = tasksCountByWeek;
      });
    } catch (err) {
      // print('Error fetching tasks count by week: $err');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: SizedBox(
            height: 250,
            child: BarChart(
              BarChartData(
                // barTouchData: ,
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: true, interval: 1)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: getBottomTitles,
                          reservedSize: 30)),
                ),
                barGroups: _buildBarGroups(),
              ),
              swapAnimationDuration: const Duration(milliseconds: 0),
            ),
          ),
        ),
        const SizedBox(height: 10),
        LegendsListWidget(
          legends: [
            Legend('last week', const Color.fromARGB(255, 125, 125, 125)),
            Legend('this week ', const Color.fromARGB(255, 203, 182, 255)),
            
          ],
        ),
      ],
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    final List<BarChartGroupData> barGroups = [];

    // Iterate over each habit
    for (final habit in widget.habits) {
      final List<BarChartRodData> barRods = [];

      // Iterate over each week's task counts (should be 2)
      for (int i = 0; i < _currentAndNextWeekTasksCount.length; i++) {
        final weekTasksCount = _currentAndNextWeekTasksCount[i];

        // Get the task count for the current habit in the current week
        final taskCount = weekTasksCount[habit.name] ?? 0;

        // Add a bar for the task count of the current habit
        barRods.add(BarChartRodData(
          toY: taskCount.toDouble(),
          color: i == 1
              ? const Color.fromARGB(255, 203, 182, 255)
              : const Color.fromARGB(255, 125, 125, 125),
          width: 12,
        ));
      }

      // Add the bar group for the current habit
      barGroups.add(
        BarChartGroupData(
          barsSpace: 8,
          barRods: barRods,
          x: barGroups.length, // Set the x-coordinate to the index of the habit
          // showingTooltipIndicators: [0, 1], // Show tooltips for both weeks
        ),
      );
    }

    return barGroups;
  }

  Widget getBottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 13,
    );

    Widget text = Text(
      widget.habits[value.toInt()].name,
      style: style,
    );

    if (widget.habits.length > 3) {
      text = RotationTransition(
        turns: const AlwaysStoppedAnimation(15 / 360),
        child: text,
      );
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }
}
