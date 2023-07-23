import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fyp_calendar_2/controllers/task_controller.dart';
import 'package:fyp_calendar_2/ui/analysis_page.dart';
import 'package:fyp_calendar_2/ui/theme.dart';
import 'package:fyp_calendar_2/ui/update_page.dart';
import 'package:fyp_calendar_2/ui/widgets/task_tile.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../models/task.dart';
import '../services/notification_services.dart';
import 'home_page.dart';

class ShowEvent extends StatefulWidget {
  const ShowEvent({Key? key}) : super(key: key);

  @override
  State<ShowEvent> createState() => _ShowEventState();
}

class _ShowEventState extends State<ShowEvent> {
  var notifyHelper;
  final _taskController = Get.put(TaskController());
  int currentPageIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
            print("currentPageIndex is : $index");
            switch (currentPageIndex) {
              case 0:
                {
                  currentPageIndex = 1;
                  print("Here is switch case 0 --- Routing : Home Page");
                  Get.to(() => CalendarScreen());
                }
                break;
              case 1:
                {
                  currentPageIndex = 1;
                  print("Here is switch case 1 --- Stay : Schedule List");
                }
                break;
              case 2:
                {
                  currentPageIndex = 1;
                  print("Here is switch case 2 --- Routing : Analysis Page");
                  Get.to(() => const AnalysisPage());
                }
                break;
              default:
                {
                  Get.to(() => const ShowEvent());
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
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
        ),
        backgroundColor: Colors.pinkAccent,
        centerTitle: true,
        title: Text(
          "S c h e d u l e   L i s t",
          style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          _showTasks(),
        ],
      ),
    );
  }

  _showTasks() {
    return Expanded(
      child: Obx(() {
        return ListView.builder(
            itemCount: _taskController.taskList.length,
            itemBuilder: (_, index) {
              Task task = _taskController.taskList[index];
              print(_taskController.taskList.length);
              DateTime date = DateFormat.jm().parse(task.startTime.toString());
              var myTime = DateFormat("HH:mm").format(date);
              var notifyHelper = NotifyHelper();
              notifyHelper.scheduledNotification(
                  int.parse(myTime.toString().split(":")[0]),
                  int.parse(myTime.toString().split(":")[1]),
                  task);
              return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Row(children: [
                        GestureDetector(
                          onTap: () {
                            _showBottomSheet(
                                context, _taskController.taskList[index]);
                          },
                          child: TaskTile(_taskController.taskList[index]),
                        )
                      ]),
                    ),
                  ));
            });
      }),
    );
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(Container(
      padding: const EdgeInsets.only(top: 14),
      height: task.isCompleted == 1
          ? MediaQuery.of(context).size.height * 0.24
          : MediaQuery.of(context).size.height * 0.38,
      color: Colors.white,
      child: Column(
        children: [
          Container(
            height: 6,
            width: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[300],
            ),
          ),
          Spacer(),
          task.isCompleted == 1
              ? Container()
              : _bottomSheetButton(
                  label: "Schedule Completed",
                  onTap: () {
                    _taskController.markTaskCompleted(task.id!);
                    Get.back();
                  },
                  clr: Color(0xFF1A237E),
                  context: context),
          task.isCompleted == 1
              ? Container()
              : _bottomSheetButton(
                  label: "Edit Schedule",
                  onTap: () {
                    Get.to(() => UpdatePage(task: task));
                  },
                  clr: Color(0xFF0091EA),
                  context: context),
          _bottomSheetButton(
              label: "Delete Schedule",
              onTap: () {
                _taskController.delete(task);
                Get.back();
              },
              clr: Color(0xFFEF5350),
              context: context),
          SizedBox(
            height: 20,
          ),
          _bottomSheetButton(
              label: "Close",
              onTap: () {
                Get.back();
              },
              clr: Colors.white,
              context: context,
              isClose: true),
          SizedBox(
            height: 10,
          )
        ],
      ),
    ));
  }

  _bottomSheetButton({
    required String label,
    required Function()? onTap,
    required Color clr,
    bool isClose = false,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
              width: 2, color: isClose == true ? Color(0xFFE0E0E0) : clr),
          borderRadius: BorderRadius.circular(20),
          color: isClose == true ? Colors.white : clr,
        ),
        child: Center(
          child: Text(
            label,
            style:
                isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

//22-4-2023 Finish