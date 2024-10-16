import 'package:boonjae/src/models/habit_model.dart';
import 'package:boonjae/src/models/task_model.dart';
import 'package:boonjae/src/models/user_model.dart';
import 'package:boonjae/src/services/activity_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class TasksService {
  final FirebaseDatabase _rtdb = FirebaseDatabase.instance;

  Future<Map<DateTime, int>> getTasksByUserAndHabit({
    required HabitModel habit,
    required UserModel user,
  }) async {
    Map<DateTime, int> taskCountByDate = {};

    try {
      String userId = user.uid;
      DateTime currentDate = DateTime.now();

      DateTime previousMonth = currentDate.subtract(const Duration(days: 30));

      // If the current month is January, adjust the year accordingly
      if (currentDate.month == DateTime.january) {
        previousMonth = DateTime(currentDate.year - 1, DateTime.december);
      } else {
        previousMonth = DateTime(currentDate.year, currentDate.month - 1);
      }

      String prevMonthYear =
          "${previousMonth.month.toString().padLeft(2, '0')}-${previousMonth.year}";
      String prevHabitPath = "users/$userId/habits/${habit.habitId}";
      String prevDatePath = "$prevHabitPath/$prevMonthYear";

      DatabaseReference prevHabitRef = _rtdb.ref().child(prevDatePath);

      // Fetch the data
      DatabaseEvent prevEvent = await prevHabitRef.once();

      // Parse the data into the taskCountByDate map
      if (prevEvent.snapshot.value != null) {
        Map<dynamic, dynamic> data = prevEvent.snapshot.value as Map;
        data.forEach((key, value) {
          taskCountByDate[DateTime.parse(key)] = value;
        });
      }

      String monthYear =
          "${currentDate.month.toString().padLeft(2, '0')}-${currentDate.year}";

      // Constructing the path
      String habitPath = "users/$userId/habits/${habit.habitId}";
      String datePath = "$habitPath/$monthYear";

      // Get a reference to the database path
      DatabaseReference habitRef = _rtdb.ref().child(datePath);

      // Fetch the data
      DatabaseEvent event = await habitRef.once();

      // Parse the data into the taskCountByDate map
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> data = event.snapshot.value as Map;
        data.forEach((key, value) {
          taskCountByDate[DateTime.parse(key)] = value;
        });
      }
      return taskCountByDate;

      // return 'Your report has been submitted';
    } catch (err) {
      // print(err.toString());
      return taskCountByDate;
      // return err.toString();
    }
  }

  updateTask({
    required TaskModel task,
    required bool complete,
  }) async {
    try {
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;

      String monthYear =
          "${task.date.month.toString().padLeft(2, '0')}-${task.date.year}";

      // Constructing the path
      String habitPath = "users/$currentUserId/habits/${task.habitId}";
      String datePath =
          "$habitPath/$monthYear/${task.date.toIso8601String().substring(0, 10)}";

      DatabaseReference habitRef = _rtdb.ref().child(datePath);

      // Set the value to 1
      // update tasks by week
      DateTime currentDateTime = DateTime.now();
      String weekYear = ActivityService().weekRange(currentDateTime);

      // String weekYear = '$numWeek-${currentDateTime.year}';
      String tasksPerWeek = "users/$currentUserId/tasksPerWeek/$weekYear";

      DatabaseReference tasksPerWeekRef = _rtdb.ref().child(tasksPerWeek);

      DatabaseEvent event = await tasksPerWeekRef.once();
      int tasksThisWeek = 0;

      // Parse the data into the taskCountByDate map
      if (event.snapshot.value != null) {
        int data = event.snapshot.value as int;
        tasksThisWeek = data;
      }

      if (complete) {
        await habitRef.set(1);
        await tasksPerWeekRef.set(tasksThisWeek + 1);
      } else {
        await habitRef.remove();
        await tasksPerWeekRef.set(tasksThisWeek <= 0 ? 0 : tasksThisWeek - 1);
      }
    } catch (err) {
      // return err.toString();
    }
  }

  deleteTask({required TaskModel task}) async {
    try {
      if (task.status == "COMPLETED") {
        TasksService().updateTask(task: task, complete: false);
      }
    } catch (err) {
      // print(err.toString());
    }
  }
}
