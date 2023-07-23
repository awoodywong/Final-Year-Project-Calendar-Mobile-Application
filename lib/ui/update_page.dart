import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp_calendar_2/controllers/task_controller.dart';
import 'package:fyp_calendar_2/main.dart';
import 'package:fyp_calendar_2/ui/event_list_show.dart';
import 'package:fyp_calendar_2/ui/home_page.dart';
import 'package:fyp_calendar_2/ui/theme.dart';
import 'package:fyp_calendar_2/ui/widgets/button.dart';
import 'package:fyp_calendar_2/ui/widgets/input_field.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';

class UpdatePage extends StatefulWidget {
  final Task task;

  const UpdatePage({Key? key, required this.task}) : super(key: key);

  @override
  State<UpdatePage> createState() => _UpdatePageState(task);
}

class _UpdatePageState extends State<UpdatePage> {
  late final Task _task;
  DateTime _selectedDate = DateTime.now();
  String _mDate = "0";
  String _dDate = "0";
  int _id = -1;
  String _title = "Title";
  String _note = "Note";
  String _startTime = "00:00 AM";
  String _endTime = "00:00 AM";
  String _selectedType = " ";
  int _selectedColor = 0;
  int _selectedRemind = 5;
  int _isCompleted = 0;

  List<int> remindList = <int>[5, 10, 15, 20];
  List<String> typeList = <String>[
    "Work",
    "Dinner",
    "Lunch",
    "Sport",
    "Meditation",
    "Entertainment"
  ];
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  _UpdatePageState(this._task) {
    if (_task.date.toString()!.split("/")[0].length == 1) {
      _mDate = "0${_task.date.toString()!.split("/")[0]}";
    } else if (_task.date.toString()!.split("/")[0].length == 2) {
      _mDate = _task.date.toString()!.split("/")[0];
    }

    if (_task.date.toString()!.split("/")[1].length == 1) {
      _dDate = "0${_task.date.toString()!.split("/")[1]}";
    } else if (_task.date.toString()!.split("/")[1].length == 2) {
      _dDate = _task.date.toString()!.split("/")[1];
    }

    String editDate =
        "${_task.date.toString()!.split("/")[2]}-" + "${_mDate}-" + _dDate;

    _id = int.parse(_task.id.toString());
    _selectedDate = DateTime.parse(editDate);
    _title = _task.title.toString();
    _note = _task.note.toString();
    _startTime = _task.startTime.toString();
    _endTime = _task.endTime.toString();
    _selectedType = _task.type.toString();
    _selectedRemind = int.parse(_task.remind.toString());
    _selectedColor = int.parse(_task.color.toString());
    _isCompleted = int.parse(_task.isCompleted.toString());

    _titleController.text = _title;
    _noteController.text = _note;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(),
        body: Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Update Schedule",
                  style: headingStyle,
                ),
                MyInputField(
                  title: "Title",
                  hint: _task.title.toString(),
                  controller: _titleController,
                ),
                MyInputField(
                  title: "Note",
                  hint: _task.note.toString(),
                  controller: _noteController,
                ),
                MyInputField(
                  title: "Date",
                  hint: DateFormat('yyyy-MM-dd').format(_selectedDate),
                  widget: IconButton(
                    icon: const Icon(
                      Icons.calendar_today_outlined,
                      color: hintClr,
                    ),
                    onPressed: () {
                      print(
                          "user press the calendar icon on add schedule page");
                      _getDateFromUser();
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                        child: MyInputField(
                      title: "Start Time",
                      hint: _startTime.toString(),
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUserStartTime();
                        },
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color: hintClr,
                        ),
                      ),
                    )),
                    const SizedBox(
                      width: 22,
                    ),
                    Expanded(
                        child: MyInputField(
                      title: "End Time",
                      hint: _endTime.toString(),
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUserEndTime();
                        },
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color: hintClr,
                        ),
                      ),
                    )),
                  ],
                ),
                MyInputField(
                  title: "Remind",
                  hint: "$_selectedRemind minutes early",
                  widget: DropdownButton(
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: hintClr,
                    ),
                    iconSize: 32,
                    elevation: 4,
                    style: hintStyle,
                    underline: Container(
                      height: 0,
                      color: Colors.transparent,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRemind = int.parse(newValue!);
                      });
                    },
                    items:
                        remindList.map<DropdownMenuItem<String>>((int value) {
                      return DropdownMenuItem<String>(
                        value: value.toString(),
                        child: Text(value.toString()),
                      );
                    }).toList(),
                  ),
                ),
                MyInputField(
                  title: "Type",
                  hint: "$_selectedType",
                  widget: DropdownButton(
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: hintClr,
                    ),
                    iconSize: 32,
                    elevation: 4,
                    style: hintStyle,
                    underline: Container(
                      height: 0,
                      color: Colors.transparent,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedType = newValue!;
                      });
                    },
                    items:
                        typeList.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _colorPalette(),
                    MyButton(label: "Update", onTap: () => _validateData()),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  _validateData() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _updateTaskToDB();
      print("$_titleController and $_noteController");

      Get.to(() => const ShowEvent());
    } else if (_titleController.text.isEmpty && _noteController.text.isEmpty) {
      Get.snackbar("Required", "All fields Are required !",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black54,
          colorText: Colors.pink[300],
          icon: Icon(
            Icons.warning_amber_rounded,
            color: Colors.pink[300],
          ));
      print("Data validation fail : ALL");
    } else if (_titleController.text.isNotEmpty &&
        _noteController.text.isEmpty) {
      Get.snackbar("Required", "Note field is required !",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black54,
          colorText: Colors.pink[300],
          icon: Icon(
            Icons.warning_amber_rounded,
            color: Colors.pink[300],
          ));
      print("Data validation fail : Note Field");
    } else if (_titleController.text.isEmpty &&
        _noteController.text.isNotEmpty) {
      Get.snackbar("Required", "Title field is required !",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black54,
          colorText: Colors.pink[300],
          icon: Icon(
            Icons.warning_amber_rounded,
            color: Colors.pink[300],
          ));
      print("Data validation fail : Title Field");
    }
  }

  _updateTaskToDB() async {
    int value = await _taskController.updateTask(
        task: Task(
      id: _id,
      title: _titleController.text.toString(),
      note: _noteController.text.toString(),
      date: DateFormat.yMd().format(_selectedDate),
      startTime: _startTime,
      endTime: _endTime,
      remind: _selectedRemind,
      type: _selectedType,
      color: _selectedColor,
      isCompleted: _isCompleted,
    ));
    print("My id is " + "$value");
    //_homePageController.addTaskToList();
    print("updateTaskToList function called");
  }

  _colorPalette() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Color",
          style: titleStyle,
        ),
        const SizedBox(
          height: 8.0,
        ),
        Wrap(
          children: List<Widget>.generate(3, (int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                  print(_selectedColor);
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: index == 0
                      ? Color(0xFF1A237E)
                      : index == 1
                          ? Color(0xFF26A69A)
                          : Colors.orange,
                  child: _selectedColor == index
                      ? const Icon(Icons.done, color: Colors.white, size: 16)
                      : Container(),
                ),
              ),
            );
          }),
        )
      ],
    );
  }

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2999));
    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
        print(_selectedDate);
      });
    } else {
      print("it is null value of date");
    }
  }

  _getTimeFromUserStartTime() async {
    var _pickedTime = await _showTimePickerStartTime();
    String _formatedTime = _pickedTime.format(context);
    if (_pickedTime == null) {
      print("Time canceled");
    } else {
      setState(() {
        _startTime = _formatedTime;
      });
    }
  }

  _getTimeFromUserEndTime() async {
    var _pickedTime = await _showTimePickerEndTime();
    String _formatedTime = _pickedTime.format(context);
    if (_pickedTime == null) {
      print("Time canceled");
    } else {
      setState(() {
        _endTime = _formatedTime;
      });
    }
  }

  _showTimePickerStartTime() {
    return showTimePicker(
        initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(
          hour: int.parse(_task.startTime.toString().split(":")[0]),
          minute:
              int.parse(_task.startTime.toString().split(":")[1].split(" ")[0]),
        ));
  }

  _showTimePickerEndTime() {
    return showTimePicker(
        initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(
          hour: int.parse(_task.endTime.toString().split(":")[0]),
          minute:
              int.parse(_task.endTime.toString().split(":")[1].split(" ")[0]),
        ));
  }
}
