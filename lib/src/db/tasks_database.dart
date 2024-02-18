import 'package:boonjae/src/models/task_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TasksDatabase {
  static final TasksDatabase instance = TasksDatabase._init();

  static Database? _database;

  TasksDatabase._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB('tasks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE $tableTasks (
        ${TaskFields.taskId} $idType,
        ${TaskFields.userId} $textType,
        ${TaskFields.dayOfWeek} $textType,
        ${TaskFields.habitId} $textType,
        ${TaskFields.habitName} $textType,
        ${TaskFields.date} $textType,
        ${TaskFields.status} $textType
      )
    ''');
  }

  Future<TaskModel> create(TaskModel task) async {
    final db = await instance.database;
    final id = await db.insert(tableTasks, task.toJson());
    return task.copy(taskId: id);
  }

  Future<TaskModel> readTask(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableTasks,
      columns: TaskFields.values,
      where: '${TaskFields.taskId} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return TaskModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<List<TaskModel>>> readCurrentWeekTasks() async {
    try {
      final db = await instance.database;

      final List<String> daysOfWeek = [
        "Sunday",
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday",
      ];

      // Get the current date and find the beginning and end of the current week
      DateTime currentDate = DateTime.now();
   
      DateTime startOfWeek = currentDate.weekday == 7 ?   DateTime(currentDate.year, currentDate.month, currentDate.day) :
          currentDate.subtract(Duration(days: currentDate.weekday - 1));
      DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));

      final maps = await db.query(
        tableTasks,
        columns: TaskFields.values,
        where: '${TaskFields.date} BETWEEN ? AND ?',
        whereArgs: [startOfWeek.toIso8601String(), endOfWeek.toIso8601String()],
      );

      List<TaskModel> allTasks =
          maps.map((taskMap) => TaskModel.fromJson(taskMap)).toList();

      List<List<TaskModel>> lists = [[], [], [], [], [], [], []];

      for (TaskModel task in allTasks) {
        // Determine the index based on the dayOfWeek property
        int dayIndex = daysOfWeek.indexOf(task.dayOfWeek);
        if (dayIndex != -1) {
          lists[dayIndex].add(task);
        }
      }

      return lists;
    } catch (err) {
      throw Exception('sadness');
    }
  }

  Future<int> update(TaskModel task) async {
    final db = await instance.database;

    return db.update(tableTasks, task.toJson(),
        where: '${TaskFields.taskId} = ?', whereArgs: [task.taskId]);
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableTasks,
      where: '${TaskFields.taskId} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
