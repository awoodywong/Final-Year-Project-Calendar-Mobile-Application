import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';


class SettingsController extends GetxController {
  Rx<TimeOfDay> lunchStartTime = Rx<TimeOfDay>(TimeOfDay(hour: 12, minute: 0));
  Rx<TimeOfDay> lunchEndTime = Rx<TimeOfDay>(TimeOfDay(hour: 15, minute: 0));
  Rx<TimeOfDay> dinnerStartTime = Rx<TimeOfDay>(TimeOfDay(hour: 18, minute: 0));
  Rx<TimeOfDay> dinnerEndTime = Rx<TimeOfDay>(TimeOfDay(hour: 20, minute: 0));
  Rx<TimeOfDay> workStartTime = Rx<TimeOfDay>(TimeOfDay(hour: 8, minute: 0));
  Rx<TimeOfDay> workEndTime = Rx<TimeOfDay>(TimeOfDay(hour: 18, minute: 0));
  Rx<TimeOfDay> sportStartTime = Rx<TimeOfDay>(TimeOfDay(hour: 19, minute: 0));
  Rx<TimeOfDay> sportEndTime = Rx<TimeOfDay>(TimeOfDay(hour: 23, minute: 0));
  Rx<TimeOfDay> meditationStartTime = Rx<TimeOfDay>(TimeOfDay(hour: 5, minute: 0));
  Rx<TimeOfDay> meditationEndTime = Rx<TimeOfDay>(TimeOfDay(hour: 23, minute: 59));

  @override
  void onInit() {
    super.onInit();
    // 加载存储的设置值
    _loadSettings();
  }

  // 更新 lunchStartTime
  void updateLunchStartTime(TimeOfDay newTime) {
    lunchStartTime.value = newTime;
    _saveSettings();
  }

  // 更新 lunchEndTime
  void updateLunchEndTime(TimeOfDay newTime) {
    lunchEndTime.value = newTime;
    _saveSettings();
  }

  // 更新 dinnerStartTime
  void updateDinnerStartTime(TimeOfDay newTime) {
    dinnerStartTime.value = newTime;
    _saveSettings();
  }

  // 更新 dinnerEndTime
  void updateDinnerEndTime(TimeOfDay newTime) {
    dinnerEndTime.value = newTime;
    _saveSettings();
  }

  void updateWorkStartTime(TimeOfDay newTime) {
    workStartTime.value = newTime;
    _saveSettings();
  }

  void updateWorkEndTime(TimeOfDay newTime) {
    workEndTime.value = newTime;
    _saveSettings();
  }
  void updateSportStartTime(TimeOfDay newTime) {
    sportStartTime.value = newTime;
    _saveSettings();
  }

  void updateSportEndTime(TimeOfDay newTime) {
    sportEndTime.value = newTime;
    _saveSettings();
  }
  void updateMeditationStartTime(TimeOfDay newTime) {
    meditationStartTime.value = newTime;
    _saveSettings();
  }

  void updateMeditationEndTime(TimeOfDay newTime) {
    meditationEndTime.value = newTime;
    _saveSettings();
  }

  void _loadSettings() {
    final storage = GetStorage();
    lunchStartTime.value = _timeFromString(storage.read("lunchStartTime") ?? "12:00 PM");
    lunchEndTime.value = _timeFromString(storage.read("lunchEndTime") ?? "2:00 PM");
    dinnerStartTime.value = _timeFromString(storage.read("dinnerStartTime") ?? "6:00 PM");
    dinnerEndTime.value = _timeFromString(storage.read("dinnerEndTime") ?? "8:00 PM");
    workStartTime.value = _timeFromString(storage.read("workStartTime") ?? "9:00 AM");
    workEndTime.value = _timeFromString(storage.read("workEndTime") ?? "6:00 PM");
    sportStartTime.value = _timeFromString(storage.read("sportStartTime") ?? "7:00 PM");
    sportEndTime.value = _timeFromString(storage.read("sportEndTime") ?? "11:00 PM");
    meditationStartTime.value = _timeFromString(storage.read("meditationStartTime") ?? "5:00 AM");
    meditationEndTime.value = _timeFromString(storage.read("meditationEndTime") ?? "11:59 PM");
  }

  void _saveSettings() {
    final storage = GetStorage();
    storage.write("lunchStartTime", _stringFromTime(lunchStartTime.value));
    storage.write("lunchEndTime", _stringFromTime(lunchEndTime.value));
    storage.write("dinnerStartTime", _stringFromTime(dinnerStartTime.value));
    storage.write("dinnerEndTime", _stringFromTime(dinnerEndTime.value));
    storage.write("workStartTime", _stringFromTime(workStartTime.value));
    storage.write("workEndTime", _stringFromTime(workEndTime.value));
    storage.write("sportStartTime", _stringFromTime(sportStartTime.value));
    storage.write("sportEndTime", _stringFromTime(sportEndTime.value));
    storage.write("meditationStartTime", _stringFromTime(meditationStartTime.value));
    storage.write("meditationEndTime", _stringFromTime(meditationEndTime.value));
  }

  TimeOfDay _timeFromString(String timeString) {
    final format = DateFormat.jm(); // Use the correct format for your time string
    final dateTime = format.parse(timeString);
    return TimeOfDay.fromDateTime(dateTime);
  }

  String _stringFromTime(TimeOfDay time) {
    final parsedString = DateFormat("h:mm a").format(DateTime(0, 0, 0, time.hour, time.minute));
    return parsedString;
  }
}