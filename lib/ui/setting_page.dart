import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import '../controllers/setting_controller.dart';
import '../main.dart';


class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}



class _SettingsPageState extends State<SettingsPage> {
  final SettingsController settingsController = Get.find();
  TimeOfDay? _lunchStartTime;
  TimeOfDay? _lunchEndTime;
  TimeOfDay? _dinnerStartTime;
  TimeOfDay? _dinnerEndTime;
  TimeOfDay? _workStartTime;
  TimeOfDay? _workEndTime;
  TimeOfDay? _sportStartTime;
  TimeOfDay? _sportEndTime;
  TimeOfDay? _meditationStartTime;
  TimeOfDay? _meditationEndTime;

  void _saveSettings() {
    final storage = GetStorage();
    storage.write("lunchStartTime", _stringFromTime(_lunchStartTime!));
    storage.write("lunchEndTime", _stringFromTime(_lunchEndTime!));
    storage.write("dinnerStartTime", _stringFromTime(_dinnerStartTime!));
    storage.write("dinnerEndTime", _stringFromTime(_dinnerEndTime!));
    storage.write("workStartTime", _stringFromTime(_workStartTime!));
    storage.write("workEndTime", _stringFromTime(_workEndTime!));
    storage.write("sportStartTime", _stringFromTime(_sportStartTime!));
    storage.write("sportEndTime", _stringFromTime(_sportEndTime!));
    storage.write("meditationStartTime", _stringFromTime(_meditationStartTime!));
    storage.write("meditationEndTime", _stringFromTime(_meditationEndTime!));

    // Update the values in SettingsController as well
    settingsController.updateLunchStartTime(_lunchStartTime!);
    settingsController.updateLunchEndTime(_lunchEndTime!);
    settingsController.updateDinnerStartTime(_dinnerStartTime!);
    settingsController.updateDinnerEndTime(_dinnerEndTime!);
    settingsController.updateWorkStartTime(_workStartTime!);
    settingsController.updateWorkEndTime(_workEndTime!);
    settingsController.updateWorkStartTime(_sportStartTime!);
    settingsController.updateWorkEndTime(_sportEndTime!);
    settingsController.updateWorkStartTime(_meditationStartTime!);
    settingsController.updateWorkEndTime(_meditationEndTime!);

    // Debug print statements
    print(storage.read("lunchStartTime"));
    print(storage.read("lunchEndTime"));
    print(storage.read("dinnerStartTime"));
    print(storage.read("dinnerEndTime"));
    print(storage.read("workStartTime"));
    print(storage.read("workEndTime"));
    print(storage.read("sportStartTime"));
    print(storage.read("sportEndTime"));
    print(storage.read("meditationStartTime"));
    print(storage.read("meditationEndTime"));

  }

  void main() async {
    await GetStorage.init();
    runApp(MyApp());
  }
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    _lunchStartTime = settingsController.lunchStartTime.value;
    _lunchEndTime = settingsController.lunchEndTime.value;
    _dinnerStartTime = settingsController.dinnerStartTime.value;
    _dinnerEndTime = settingsController.dinnerEndTime.value;
    _workStartTime = settingsController.workStartTime.value;
    _workEndTime = settingsController.workEndTime.value;
    _sportStartTime = settingsController.sportStartTime.value;
    _sportEndTime = settingsController.sportEndTime.value;
    _meditationStartTime = settingsController.meditationStartTime.value;
    _meditationEndTime = settingsController.meditationEndTime.value;

  }

  TimeOfDay _timeFromString(String time) {
    final parsedTime = TimeOfDay.fromDateTime(DateFormat("h:mm a").parse(time));
    return parsedTime;
  }

  String _stringFromTime(TimeOfDay time) {
    final parsedString = DateFormat("h:mm a").format(DateTime(0, 0, 0, time.hour, time.minute));
    return parsedString;
  }


  Future<void> _selectTime(BuildContext context, String title, TimeOfDay initialTime, Function(TimeOfDay) onSelected) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.pink,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null && pickedTime != initialTime) {
      onSelected(pickedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Lunch"),
            ListTile(
              title: Text("Start Time: ${_stringFromTime(_lunchStartTime!)}"),
              trailing: Icon(Icons.edit),
              onTap: () => _selectTime(context, "Select Lunch Start Time", _lunchStartTime!, (TimeOfDay pickedTime) {
                setState(() {
                  _lunchStartTime = pickedTime;
                  _saveSettings();
                });
              }),
            ),
            ListTile(
              title: Text("End Time: ${_stringFromTime(_lunchEndTime!)}"),
              trailing: Icon(Icons.edit),
              onTap: () => _selectTime(context, "Select Lunch End Time", _lunchEndTime!, (TimeOfDay pickedTime) {
                setState(() {
                  _lunchEndTime =pickedTime;
                  _saveSettings();
                });
              }),
            ),
            SizedBox(height: 16.0),
            Text("Dinner"),
            ListTile(
              title: Text("Start Time: ${_stringFromTime(_dinnerStartTime!)}"),
              trailing: Icon(Icons.edit),
              onTap: () => _selectTime(context, "Select Dinner Start Time", _dinnerStartTime!, (TimeOfDay pickedTime) {
                setState(() {
                  _dinnerStartTime = pickedTime;
                  _saveSettings();
                });
              }),
            ),
            ListTile(
              title: Text("End Time: ${_stringFromTime(_dinnerEndTime!)}"),
              trailing: Icon(Icons.edit),
              onTap: () => _selectTime(context, "Select Dinner End Time", _dinnerEndTime!, (TimeOfDay pickedTime) {
                setState(() {
                  _dinnerEndTime = pickedTime;
                  _saveSettings();
                });
              }),
            ),
            SizedBox(height: 16.0),
            Text("Work"),
            ListTile(
              title: Text("Start Time: ${_stringFromTime(_workStartTime!)}"),
              trailing: Icon(Icons.edit),
              onTap: () => _selectTime(context, "Select Work Start Time", _workStartTime!, (TimeOfDay pickedTime) {
                setState(() {
                  _workStartTime = pickedTime;
                  _saveSettings();
                });
              }),
            ),
            ListTile(
              title: Text("End Time: ${_stringFromTime(_workEndTime!)}"),
              trailing: Icon(Icons.edit),
              onTap: () => _selectTime(context, "Select work End Time", _workEndTime!, (TimeOfDay pickedTime) {
                setState(() {
                  _workEndTime = pickedTime;
                  _saveSettings();
                });
              }),
            ),
            SizedBox(height: 16.0),
            Text("Sport"),
            ListTile(
              title: Text("Start Time: ${_stringFromTime(_sportStartTime!)}"),
              trailing: Icon(Icons.edit),
              onTap: () => _selectTime(context, "Select Sport Start Time", _sportStartTime!, (TimeOfDay pickedTime) {
                setState(() {
                  _sportStartTime = pickedTime;
                  _saveSettings();
                });
              }),
            ),
            ListTile(
              title: Text("End Time: ${_stringFromTime(_sportEndTime!)}"),
              trailing: Icon(Icons.edit),
              onTap: () => _selectTime(context, "Select sport End Time", _sportEndTime!, (TimeOfDay pickedTime) {
                setState(() {
                  _sportEndTime = pickedTime;
                  _saveSettings();
                });
              }),
            ),
            SizedBox(height: 16.0),
            Text("meditation"),
            ListTile(
              title: Text("Start Time: ${_stringFromTime(_meditationStartTime!)}"),
              trailing: Icon(Icons.edit),
              onTap: () => _selectTime(context, "Select Meditation Start Time", _meditationStartTime!, (TimeOfDay pickedTime) {
                setState(() {
                  _meditationStartTime = pickedTime;
                  _saveSettings();
                });
              }),
            ),
            ListTile(
              title: Text("End Time: ${_stringFromTime(_meditationEndTime!)}"),
              trailing: Icon(Icons.edit),
              onTap: () => _selectTime(context, "Select meditation End Time", _meditationEndTime!, (TimeOfDay pickedTime) {
                setState(() {
                  _meditationEndTime = pickedTime;
                  _saveSettings();
                });
              }),
            ),
          ],
        ),
      ),
    );
  }
}