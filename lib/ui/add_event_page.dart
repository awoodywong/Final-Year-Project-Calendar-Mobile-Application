import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp_calendar_2/controllers/task_controller.dart';
import 'package:fyp_calendar_2/ui/theme.dart';
import 'package:fyp_calendar_2/ui/widgets/button.dart';
import 'package:fyp_calendar_2/ui/widgets/input_field.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import 'auto_schedule_page.dart';
import 'ocr_screen.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({Key? key}) : super(key: key);

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _endTime = "10:00 PM";
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  int _selectedRemind = 5;
  List<int> remindList = <int>[5, 10, 15, 20];
  String _selectedType = "Work";
  List<String> typeList = <String>[
    "Work",
    "Dinner",
    "Lunch",
    "Sport",
    "Meditation",
    "Entertainment"
  ];
  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () async {
                  Get.to(() =>
                      AutoSchedulePage(tasks: _taskController.taskList));
                },
                icon: const Icon(Icons.motion_photos_auto_outlined)),
            IconButton(
                onPressed: () async {
                  Get.to(() => Ocr_Screen());
                },
                icon: const Icon(Icons.document_scanner_outlined))
          ],
        ),
        body: Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Add Schedule",
                  style: headingStyle,
                ),
                MyInputField(
                  title: "Title",
                  hint: "Enter your title",
                  controller: _titleController,
                ),
                MyInputField(
                  title: "Note",
                  hint: "Enter your note",
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
                          hint: _startTime,
                          widget: IconButton(
                            onPressed: () {
                              _getTimeFromUser(isStartTime: true);
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
                          hint: _endTime,
                          widget: IconButton(
                            onPressed: () {
                              _getTimeFromUser(isStartTime: false);
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
                    MyButton(label: "Create", onTap: () => _validateData()),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  _validateData() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTaskToDB();
      print("$_titleController and $_noteController");

      Get.back();
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

  _addTaskToDB() async {
    int value = await _taskController.addTask(
        task: Task(
          title: _titleController.text.toString(),
          note: _noteController.text.toString(),
          date: DateFormat.yMd().format(_selectedDate),
          startTime: _startTime,
          endTime: _endTime,
          remind: _selectedRemind,
          type: _selectedType,
          color: _selectedColor,
          duration: 0,
          isCompleted: 0,
        ));
    print("My id is " + "$value");
    //_homePageController.addTaskToList();
    print("addTaskToList function called");
  }

  _colorPalette() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Color",
          style: titleStyle,
        ),
        SizedBox(
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

  _getTimeFromUser({required bool isStartTime}) async {
    var _pickedTime = await _showTimePicker();
    String _formatedTime = _pickedTime.format(context);
    if (_pickedTime == null) {
      print("Time canceled");
    } else if (isStartTime == true) {
      setState(() {
        _startTime = _formatedTime;
      });
    } else if (isStartTime == false) {
      setState(() {
        _endTime = _formatedTime;
      });
    }
  }

  _showTimePicker() {
    return showTimePicker(
        initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(
          hour: int.parse(_startTime.split(":")[0]),
          minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
        ));
  }
}
