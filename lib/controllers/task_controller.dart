import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:fyp_calendar_2/db/db_helper.dart';
import 'package:get/get.dart';
import '../models/task.dart';

class TaskController extends GetxController {
  @override
  void onReady() {
    super.onReady();
  }

  var taskList = <Task>[].obs;

  List<NeatCleanCalendarEvent> todayEventList = [];

  updateTaskToList() async {
    int? _id;
    String? _title;
    String? _note;
    String? _holdDate;
    int? _dDate;
    int? _mDate;
    int? _yDate;
    String? _holdStartTime;
    int? _hourStartTime;
    int? _minStartTime;
    String? _holdEndTime;
    int? _hourEndTime;
    int? _minEndTime;
    String? _apmStartTime;
    String? _apmEndTime;
    int? _holdColor;
    Color? _color;

    todayEventList.clear();
    print("Here is first _todayEvents list: $todayEventList");

    Future<List<Map<String, dynamic>>> _taskListFromDB = getTaskToEventList();
    List _notFutureListOfTask = await _taskListFromDB;

    print("the taskListFromDB length is: ${_notFutureListOfTask}");
    print("the _taskListFromDB length is: ${_notFutureListOfTask.length}");

    int _lengthOfList = _notFutureListOfTask.length;
    print("Here is addTaskToList function");
    for (var r = 0; r < _lengthOfList; r++) {
      //split the List<Map> elements into specific variable
      _id = _notFutureListOfTask[r]["id"];
      _title = _notFutureListOfTask[r]["title"].toString();
      _note = _notFutureListOfTask[r]["note"].toString();
      _holdDate = _notFutureListOfTask[r]["date"];
      _dDate = int.parse(_holdDate!.split("/")[1]);
      _mDate = int.parse(_holdDate!.split("/")[0]);
      _yDate = int.parse(_holdDate!.split("/")[2]);

      //convert and split the startTime to fulfill NeatCleanEvent format, and 12 hours format convert to 24 hours format
      _holdStartTime = _notFutureListOfTask[r]["startTime"];
      _apmStartTime = _holdStartTime!.split(" ")[1];
      if (_apmStartTime == "PM") {
        if(int.parse(_holdStartTime!.split(":")[0]) == 12){
          _hourStartTime = int.parse(_holdStartTime!.split(":")[0]);
        } else {
          _hourStartTime = int.parse(_holdStartTime!.split(":")[0]) + 12;
        }
      } else {
        if(int.parse(_holdStartTime!.split(":")[0]) == 12){
          _hourStartTime = int.parse(_holdStartTime!.split(":")[0]) - 12;
        } else {
          _hourStartTime = int.parse(_holdStartTime!.split(":")[0]);
        }
      }
      _minStartTime = int.parse(_holdStartTime!.split(":")[1].split(" ")[0]);

      //convert and split the endTime to fulfill NeatCleanEvent format, and 12 hours format convert to 24 hours format
      _holdEndTime = _notFutureListOfTask[r]["endTime"];
      _apmEndTime = _holdEndTime!.split(" ")[1];
      if (_apmEndTime == "PM") {
        if(int.parse(_holdEndTime!.split(":")[0]) == 12){
          _hourEndTime = int.parse(_holdEndTime!.split(":")[0]);
        } else {
          _hourEndTime = int.parse(_holdEndTime!.split(":")[0]) + 12;
        }
      } else {
        if(int.parse(_holdEndTime!.split(":")[0]) == 12){
          _hourEndTime = int.parse(_holdEndTime!.split(":")[0]) - 12;
        } else {
          _hourEndTime = int.parse(_holdEndTime!.split(":")[0]);
        }
      }
      _minEndTime = int.parse(_holdEndTime!.split(":")[1].split(" ")[0]);

      //color: 0 = blue; 1 = pink; 2 = orange; other = blueGrey
      _holdColor = _notFutureListOfTask[r]["color"];
      _holdColor == 0
          ? _color = Color(0xFF1A237E)
          : _holdColor == 1
              ? _color = Color(0xFF26A69A)
              : _holdColor == 2
                  ? _color = Colors.orange
                  : _color = Colors.blueGrey;

      todayEventList.add(NeatCleanCalendarEvent(
        _title.toString(),
        description: _note.toString(),
        startTime:
            DateTime(_yDate, _mDate, _dDate, _hourStartTime, _minStartTime),
        endTime: DateTime(_yDate, _mDate, _dDate, _hourEndTime, _minEndTime),
        color: _color,
      ));
    } //forLoop
  }

  Future<int> addTask({Task? task}) async {
    int i = await DBHelper.insertTask(task);
    await updateTaskToList();
    return i;
  }

  Future<int> updateTask({Task? task}) async {
    int i = await DBHelper.updateFullTask(task);
    await updateTaskToList();
    return i;
  }

  void getTask() async {
    List<Map<String, dynamic>> tasks = await DBHelper.queryTask();
    taskList.assignAll(tasks.map((data) => new Task.fromJson(data)).toList());
  }

  void delete(Task task) async {
    var id = DBHelper.deleteTask(task);
    getTask();
    updateTaskToList();
    print("deleted id: $id");
  }

  void markTaskCompleted(int id) async {
    await DBHelper.updateTask(id);
    getTask();
    updateTaskToList();
    print("update id: $id to completed status");
  }

  Future<List<Map<String, dynamic>>> getTaskToEventList() async {
    List<Map<String, dynamic>> tasksForObs = await DBHelper.queryTask();
    List<Map<String, dynamic>> tasks = await DBHelper.rawQueryTask();
    taskList.assignAll(tasksForObs.map((data) => Task.fromJson(data)).toList());
    print(
        "Here is getTaskToEventList : taskList.obs ------------------------------ : $taskList");
    return Future.value(tasks);
  }

}
