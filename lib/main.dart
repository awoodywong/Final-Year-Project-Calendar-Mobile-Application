import 'package:flutter/material.dart';
import 'package:fyp_calendar_2/controllers/task_controller.dart';
import 'package:fyp_calendar_2/services/notification_services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'controllers/setting_controller.dart';
import 'db/db_helper.dart';
import 'ui/add_event_page.dart';
import 'ui/home_page.dart';
import 'ui/theme.dart';
import 'ui/analysis_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDb();
  await GetStorage.init();
  Get.put(SettingsController());
  await GetStorage.init();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'TexPic Calendar',
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      themeMode: ThemeMode.light,
      home: CalendarScreen(),
    );
  }
}

