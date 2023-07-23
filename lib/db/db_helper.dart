import 'dart:ffi';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task.dart';

class DBHelper {
  static Database? _db;
  static final int _version = 1;
  static final String _tableName = "schedule6";

  static Future<void> initDb() async {
    if (_db != null) {
      return;
    }
    try {
      String _path = await getDatabasesPath() + 'schedule6.db';
      _db = await openDatabase(
        _path,
        version: _version,
        onCreate: (db, _version) {
          print("creating a new one");
          return db.execute(
            "CREATE TABLE $_tableName("
                "id INTEGER PRIMARY KEY AUTOINCREMENT, "
                "title STRING, note TEXT, date STRING, "
                "startTime STRING, endTime STRING, "
                "remind INTEGER, type STRING, duration INTEGER, "
                "color INTEGER, "
                "isCompleted INTEGER)",
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  static Future<int> insertTask(Task? task) async {
    print("insert function called");
    return await _db?.insert(_tableName, task!.toJson()) ?? 1;
  }

  static Future<List<Map<String, dynamic>>> queryTask() async {
    print("query function called");
    List<Map<String, dynamic>> result = await _db!.query(_tableName);
    print("The result is: $result");
    print("The length is: ${result.length}");
    print("The future.value is ${Future.value(result)}");
    return result;
  }

  static Future<List<Map<String, dynamic>>> rawQueryTask() async {
    List<Map<String, dynamic>> result = await _db!.rawQuery(
        'SELECT * FROM $_tableName');
    return result;
  }

  static deleteTask(Task? task) async {
    return await _db!.delete(_tableName, where: 'id=?', whereArgs: [task?.id]);
  }

  static updateFullTask(Task? task) async{
    int? id = task?.id;
    String? title = task?.title.toString();
    String? note = task?.note.toString();
    String? date = task?.date.toString();
    String? startTime = task?.startTime.toString();
    String? endTime = task?.endTime.toString();
    int? color = task?.color;
    int? remind = task?. remind;
    int? isCompleted = task?.isCompleted;
    String? type = task?.type;

    print("Here is updateFullTask : ${task?.toJson()}");

    return await _db!.rawUpdate('''
      UPDATE $_tableName
      SET title = ?,
      note = ?,
      date = ?,
      startTime = ?,
      endTime = ?,
      color = ?,
      remind = ?,
      type = ?,
      isCompleted = ?
      WHERE id = ?
    ''', [title, note, date, startTime, endTime, color, remind, type, isCompleted, id]
    );
  }

  static updateTask(int id) async{
    return await _db!.rawUpdate('''
      UPDATE $_tableName 
      SET isCompleted = ?
      WHERE id = ?
    ''', [1, id]);
  }

  Future<List<Task>> queryTasks() async {
    final List<Map<String, dynamic>> taskMaps = await DBHelper.queryTask();
    return taskMaps.map((map) => Task.fromJson(map)).toList();
  }

  static Future<List<Task>> getTasks() async {
    final List<Map<String, dynamic>> maps = await _db!.query(_tableName);
    return List.generate(maps.length, (i) {
      return Task.fromJson(maps[i]);
    });
  }

}

