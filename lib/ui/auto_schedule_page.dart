import 'package:flutter/material.dart';
import 'package:fyp_calendar_2/ui/setting_page.dart';
import 'package:fyp_calendar_2/ui/theme.dart';
import 'package:get/get.dart';
import 'package:fyp_calendar_2/controllers/task_controller.dart';
import 'package:intl/intl.dart';
import '../controllers/setting_controller.dart';
import '../db/db_helper.dart';
import '../models/task.dart';
import '../ui/widgets/button.dart';
import '../ui/widgets/input_field.dart';
import 'home_page.dart';

class AutoSchedulePage extends StatefulWidget {
  final List<Task> tasks;

  const AutoSchedulePage({super.key, required this.tasks});

  @override
  AutoSchedulePageState createState() => AutoSchedulePageState();
}

class AutoSchedulePageState extends State<AutoSchedulePage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final SettingsController _settingsController = Get.put(SettingsController());

  DateTime _selectedDate = DateTime.now();
  String _endTime = "10:00 PM";
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  int _selectedRemind = 5;
  List<int> remindList = <int>[5, 10, 15, 20];
  int _selectedColor = 0;
  int _selectedDuration = 30;
  String _selectedType = "None";
  List<String> typeList = <String>[
    "Work",
    "Dinner",
    "Lunch",
    "Sport",
    "Meditation",
  ];
  List<int> _durationOptions = <int>[30, 60, 90];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              _goToSettings();
            },
          ),
        ]),
        body: Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Auto Schedule",
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
                  title: "Type",
                  hint: "$_selectedType",
                  controller: _typeController,
                  widget: DropdownButton(
                    icon: Icon(
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
                        _typeController.text = _selectedType;
                      });
                    },
                    items:
                    typeList.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }).toList(),
                  ),
                ),
                MyInputField(
                  title: "Duration",
                  hint: "$_selectedDuration ",
                  controller: _durationController,
                  widget: DropdownButton(
                    icon: Icon(
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
                        _selectedDuration = int.parse(newValue!);
                        _durationController.text = _selectedDuration.toString();
                      });
                    },
                    items: _durationOptions
                        .map<DropdownMenuItem<String>>((int value) {
                      return DropdownMenuItem<String>(
                        value: value.toString(),
                        child: Text(value.toString()),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MyButton(
                      label: "Auto Schedule",
                      onTap: () => _autoSchedule(),
                    ),
                    // 新增的设置按钮
                  ],
                )
              ],
            ),
          ),
        ));
  }

  void _goToSettings() {
    Get.to(() => SettingsPage());
  }

  _addTaskToDB() async {
    int value = await _taskController.addTask(
        task: Task(
          title: _titleController.text,
          note: _noteController.text,
          type: _selectedType,
          duration: _selectedDuration,
          date: DateFormat.yMd().format(_selectedDate),
          startTime: _startTime,
          endTime: _endTime,
          remind: _selectedRemind,
          color: _selectedColor,
          isCompleted: 0,
        ));
    print("My id is " + "$value");
    print("addTaskToList function called");
  }

  Future<void> _autoSchedule() async {
    List<Task> tasks = await DBHelper.getTasks();
    DateTime today = DateTime.now();
    DateTime weekLater = today.add(Duration(days: 7));

    final lunchStartTimeDuration =
    _durationFromTimeOfDay(_settingsController.lunchStartTime.value);
    final lunchEndTimeDuration =
    _durationFromTimeOfDay(_settingsController.lunchEndTime.value);
    final dinnerStartTimeDuration =
    _durationFromTimeOfDay(_settingsController.dinnerStartTime.value);
    final dinnerEndTimeDuration =
    _durationFromTimeOfDay(_settingsController.dinnerEndTime.value);
    final workStartTimeDuration =
    _durationFromTimeOfDay(_settingsController.workStartTime.value);
    final workEndTimeDuration =
    _durationFromTimeOfDay(_settingsController.workEndTime.value);
    final sportStartTimeDuration =
    _durationFromTimeOfDay(_settingsController.sportStartTime.value);
    final sportEndTimeDuration =
    _durationFromTimeOfDay(_settingsController.sportEndTime.value);
    final meditationStartTimeDuration =
    _durationFromTimeOfDay(_settingsController.meditationStartTime.value);
    final meditationEndTimeDuration =
    _durationFromTimeOfDay(_settingsController.meditationEndTime.value);
    List<DateTime> daysToCheck =
    List.generate(7, (index) => today.add(Duration(days: index)));

    bool foundAvailableSlot = false;

    for (DateTime date in daysToCheck) {
      List<DateTime> availableTimeSlots = [];

      // 根据 type 设置起始时间和结束时间
      DateTime startTime;
      DateTime endTime;
      switch(_selectedType){
        case "Lunch":
          startTime = DateTime(date.year, date.month, date.day)
              .add(lunchStartTimeDuration);
          endTime =
              DateTime(date.year, date.month, date.day).add(lunchEndTimeDuration);
          break;
        case "Dinner":
          startTime = DateTime(date.year, date.month, date.day)
              .add(dinnerStartTimeDuration);
          endTime = DateTime(date.year, date.month, date.day)
              .add(dinnerEndTimeDuration);
          break;
        case "Work":
          startTime = DateTime(date.year, date.month, date.day)
              .add(workStartTimeDuration);
          endTime = DateTime(date.year, date.month, date.day)
              .add(workEndTimeDuration);
          break;
        case "Sport":
          startTime = DateTime(date.year, date.month, date.day)
              .add(sportStartTimeDuration);
          endTime = DateTime(date.year, date.month, date.day)
              .add(sportEndTimeDuration);
          break;
        case "Meditation":
          startTime = DateTime(date.year, date.month, date.day)
              .add(meditationStartTimeDuration);
          endTime = DateTime(date.year, date.month, date.day)
              .add(meditationEndTimeDuration);
          break;
        default:
          continue;
      }




      // 找到起始时间后的第一个空闲时间段
      DateTime current = startTime;
      while (current.isBefore(endTime)) {
        bool isAvailable = true;
        for (int i = 0; i < tasks.length; i++) {
          Task task = tasks[i];
          DateFormat dateTimeFormat = DateFormat.yMd().add_jm();
          DateTime taskStartTime =
          dateTimeFormat.parse("${task.date} ${task.startTime!}");
          DateTime taskEndTime =
          dateTimeFormat.parse("${task.date} ${task.endTime!}");

          if (current.isBefore(taskEndTime) &&
              current
                  .add(Duration(minutes: _selectedDuration!))
                  .isAfter(taskStartTime)) {
            // 时间段不可用
            isAvailable = false;
            break;
          }
        }
        if (isAvailable) {
          // 时间段可用，新增活动
          setState(() {
            _selectedDate = date;
            _startTime = DateFormat("hh:mm a").format(current).toString();
            _endTime = DateFormat("hh:mm a")
                .format(current.add(Duration(minutes: _selectedDuration!)))
                .toString();
            _addTaskToDB();
          });
          Get.to(() => CalendarScreen());
          foundAvailableSlot = true;
          break;
        }
        // 时间段不可用，往后推移 30 分钟
        current = current.add(Duration(minutes: 30));
      }

      // 如果找到可用时间段，停止搜寻
      if (foundAvailableSlot) {
        break;
      }
    }

    // 如果找不到可用时间段，显示错误信息
    if (!foundAvailableSlot) {
      Get.snackbar(
        "Error",
        "No available time slots in the next 7 days.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black54,
        colorText: Colors.pink[300],
        icon: Icon(Icons.warning_amber_rounded, color: Colors.pink[300]),
      );
    }
  }

  TimeOfDay _timeFromString(String timeString) {
    final format =
    DateFormat.jm(); // Use the correct format for your time string
    final dateTime = format.parse(timeString);
    return TimeOfDay.fromDateTime(dateTime);
  }

  Duration _durationFromTimeOfDay(TimeOfDay time) {
    return Duration(hours: time.hour, minutes: time.minute);
  }

  Widget _buildTypeInputField() {
    return MyInputField(
      title: "Type",
      hint: "$_selectedType",
      controller: _typeController,
      widget: Row(
        children: [
          ElevatedButton(
            onPressed: () {
              if (_selectedType == "lunch") {
                setState(() {
                  _startTime = "12:00 PM";
                  _endTime = "3:00 PM";
                });
              } else if (_selectedType == "dinner") {
                setState(() {
                  _startTime = "6:00 PM";
                  _endTime = "8:00 PM";
                });
              }else if (_selectedType == "work") {
                setState(() {
                  _startTime = "9:00 AM";
                  _endTime = "6:00 PM";
                });
              }else if (_selectedType == "sport") {
                setState(() {
                  _startTime = "6:45 PM";
                  _endTime = "11:00 PM";
                });
              }
            },
            child: Text("Set Time"),
          ),
          SizedBox(width: 16),
          DropdownButton(
            icon: Icon(
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
                _typeController.text = _selectedType;
              });
            },
            items: typeList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value.toString()),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
