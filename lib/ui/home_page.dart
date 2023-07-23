import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:fyp_calendar_2/controllers/task_controller.dart';
import 'package:fyp_calendar_2/services/notification_services.dart';
import 'package:get/get.dart';
import 'add_event_page.dart';
import 'analysis_page.dart';
import 'event_list_show.dart';

class CalendarScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CalendarScreenState();
  }
}

class _CalendarScreenState extends State<CalendarScreen> {
  final DateTime _selectedDate = DateTime.now();
  final TaskController _taskController = Get.put(TaskController());

  int currentPageIndex = 0;
  var notifyHelper;

  @override
  void initState() {
    super.initState();
    _taskController.updateTaskToList();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
    print("initState Called");
  }

  @override
  Widget build(BuildContext context) {
    print("CHECK HERE STATE 1");
    return Scaffold(
      appBar: AppBar(
        leading: null,
        backgroundColor: Colors.pinkAccent,
        centerTitle: true,
        title: Text(
          "T e x P i c   C a l e n d a r",
          style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Calendar(
          startOnMonday: false,
          weekDays: const ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
          eventsList: _taskController.todayEventList,
          isExpandable: true,
          eventDoneColor: Colors.green,
          selectedColor: Colors.blueGrey,
          selectedTodayColor: Colors.pinkAccent,
          todayColor: Colors.redAccent,
          eventColor: null,
          locale: 'en_EN',
          todayButtonText: "TODAY",
          allDayEventText: 'All Day',
          multiDayEndText: 'End',
          isExpanded: true,
          expandableDateFormat: 'EEEE, dd. MMMM yyyy',
          onEventSelected: (value) {
            print('Event selected ${value.summary}');
          },
          onEventLongPressed: (value) {
            print('Event long pressed ${value.summary}');
          },
          datePickerType: DatePickerType.date,
          dayOfWeekStyle: const TextStyle(
              color: Colors.pinkAccent,
              fontWeight: FontWeight.w800,
              fontSize: 11),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              await Get.to(() => const AddEvent());
            },
            child: const Icon(
              Icons.add,
              color: Colors.pinkAccent,
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
            print("currentPageIndex is : $index");
            switch (currentPageIndex) {
              case 0:
                {
                  currentPageIndex = 0;
                  print("Here is switch case 0 --- Stay : Home Page");
                }
                break;
              case 1:
                {
                  currentPageIndex = 0;
                  print("Here is switch case 1 --- Routing : Schedule List");
                  Get.to(() => const ShowEvent());
                }
                break;
              case 2:
                {
                  currentPageIndex = 0;
                  print("Here is switch case 2 --- Routing : Analysis Page");
                  Get.to(() => const AnalysisPage());
                }
                break;
              default:
                {
                  Get.to(() => CalendarScreen());
                }
                break;
            }
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(
              Icons.home_outlined,
              color: Colors.pinkAccent,
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.event_note,
              color: Colors.pinkAccent,
            ),
            label: 'Schedule List',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.analytics_outlined,
              color: Colors.pinkAccent,
            ),
            label: 'Analysis',
          ),
        ],
      ),
    );
  }
}
