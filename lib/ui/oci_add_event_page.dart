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

class OCRAddEventPage extends StatefulWidget {
  final String ocrText;

  const OCRAddEventPage({Key? key, required this.ocrText}) : super(key: key);

  @override
  State<OCRAddEventPage> createState() => _OCRAddEventPageState(ocrText);
}

class _OCRAddEventPageState extends State<OCRAddEventPage> {
  DateTime _selectedDate = DateTime.now();
  String _mDate = "0";
  String _dDate = "0";
  String _title = "Title";
  String _note = "Note";
  String _startTime = "00:00 AM";
  String _endTime = "00:00 AM";
  String _selectedType = "Work";
  List<String> typeList = <String>["Work", "Dinner", "Lunch", "Sport", "Meditation", "Entertainment"];
  int _selectedColor = 0;
  int _selectedRemind = 5;
  String _resultText = " ";
  String _holdDate = " ";

  List<int> remindList = <int>[5, 10, 15, 20];
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  _OCRAddEventPageState(String ocrText) {
    _resultText = ocrText;

    _title = _resultText.split("> <")[0].split("<")[1].toString();
    _note = _resultText.split("> <")[1].toString();

    _holdDate = _resultText.split("> <")[2];

    if (_holdDate!.split("/")[0].length == 1) {
      _dDate = "0${_holdDate!.split("/")[0]}";
    } else if (_holdDate!.split("/")[0].length == 2) {
      _dDate = _holdDate!.split("/")[0];
    }

    if (_holdDate!.split("/")[1].length == 1) {
      _mDate = "0${_holdDate!.split("/")[1]}";
    } else if (_holdDate!.split("/")[1].length == 2) {
      _mDate = _holdDate!.split("/")[1];
    }

    String editDate = "${_holdDate!.split("/")[2]}-" + "${_mDate}-" + _dDate;
    _selectedDate = DateTime.parse(editDate);

    _startTime = _resultText.split("> <")[3];
    _endTime = _resultText.split("> <")[4].split(">")[0];

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
                  "OCR Scanning Schedule",
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
                    items: typeList.map<DropdownMenuItem<String>>((String value) {
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
      duration: 0,
      color: _selectedColor,
      isCompleted: 0,
    ));
    print("My id is " + "$value");
    //_homePageController.addTaskToList();
    print("addTaskToList function called");
  }

  void _showList() {
    print("title is : $_title");
    print("note is : $_note");
    print("date is : $_selectedDate");
    print("remind is : $_selectedRemind");
    //print("repeated is : $_selectedRepeated");
    print("color is : $_selectedColor");
    print("starttime is : $_startTime");
    print("endtime is : $_endTime");
    //print("isCompleted is : $_isCompleted");
    print("holdDate is : $_holdDate");
    print("The text is : $_resultText");
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
          hour: int.parse(_startTime.toString().split(":")[0]),
          minute: int.parse(_startTime.toString().split(":")[1].split(" ")[0]),
        ));
  }

  _showTimePickerEndTime() {
    return showTimePicker(
        initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(
          hour: int.parse(_endTime.toString().split(":")[0]),
          minute: int.parse(_endTime.toString().split(":")[1].split(" ")[0]),
        ));
  }
}
