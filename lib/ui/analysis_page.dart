import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp_calendar_2/controllers/task_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../models/task.dart';
import 'event_list_show.dart';
import 'package:fl_chart/fl_chart.dart';
import 'home_page.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({
    Key? key,
  }) : super(key: key);

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  final TaskController _taskController = Get.put(TaskController());
  int currentPageIndex = 2;
  int touchedIndex = -1;
  int greenColor = 0;
  int blueColor = 0;
  int orangeColor = 0;
  int sumColor = 0;

  double todoCount = 0;
  double completedCount = 0;
  double totalCount = 0;

  int dinnerType = 0;
  int sportType = 0;
  int workType = 0;
  int meditationType = 0;
  int lunchType = 0;
  int entertainmentType = 0;
  int totalType = 0;


  List<PieChartSectionData> dataList = [];

  List<PieChartSectionData> typeDataList = [];

  @override
  void initState() {
    super.initState();
    analysisTask();

    print("analysisPage initial called");
  }

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();

    return Scaffold(
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
              print("currentPageIndex is : $index");
              switch (currentPageIndex) {
                case 0:
                  {
                    currentPageIndex = 2;
                    print("Here is switch case 0 --- Routing : Home Page");
                    Get.to(() => CalendarScreen());
                  }
                  break;
                case 1:
                  {
                    currentPageIndex = 2;
                    print("Here is switch case 1 --- Routing : Schedule List");
                    Get.to(() => const ShowEvent());
                  }
                  break;
                case 2:
                  {
                    currentPageIndex = 2;
                    print("Here is switch case 2 --- Stay : Analysis Page");
                  }
                  break;
                default:
                  {
                    Get.to(() => const AnalysisPage());
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
            "A n a l y s i s",
            style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontWeight: FontWeight.bold),
          ),
        ),
        body: Column(
          children: <Widget>[
            SizedBox(height: 50),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16.0),
              height: 570,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
              ),
              child: PageView(
                controller: controller,
                children: <Widget>[
                  Center(
                    child: PieChart(PieChartData(
                        sections: dataList, centerSpaceRadius: 100)),
                  ),
                  Center(
                      child: BarChart(
                        BarChartData(
                            maxY: totalCount + 1,
                            minY: 0,
                            gridData: FlGridData(show: true),
                            borderData: FlBorderData(show: false),
                            titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: true, getTitlesWidget: getBottomTitles)),

                            ),
                            barGroups: [
                              BarChartGroupData(x: 1, barRods: [
                                BarChartRodData(
                                  toY: todoCount,
                                  color: Colors.limeAccent,
                                  width: 50,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ]),
                              BarChartGroupData(x: 2, barRods: [
                                BarChartRodData(
                                  toY: completedCount,
                                  color: Colors.orange[800],
                                  width: 50,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ]),
                            ]),
                      )),
                  Center(
                    child: PieChart(PieChartData(
                        sections: typeDataList, centerSpaceRadius: 100)),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  Widget getBottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = const Text('TODO', style: style,);
        break;
      case 2:
        text = const Text("COMPLETED", style: style,);
        break;
      default:
        text = const Text("", style: style,);
        break;
    }

    return SideTitleWidget(child: text, axisSide: meta.axisSide);
  }

  analysisTask() async {
    Future<List<Map<String, dynamic>>> _taskListFromDB =
    _taskController.getTaskToEventList();
    List _notFutureListOfTask = await _taskListFromDB;

    print("the taskListFromDB length is: ${_notFutureListOfTask}");
    print("the _taskListFromDB length is: ${_notFutureListOfTask.length}");

    int _lengthOfList = _notFutureListOfTask.length;
    print("Here is addTaskToList function");
    for (var r = 0; r < _lengthOfList; r++) {
      if (_notFutureListOfTask[r]["color"] == 0) {
        blueColor++;
      } else if (_notFutureListOfTask[r]["color"] == 1) {
        greenColor++;
      } else if (_notFutureListOfTask[r]["color"] == 2) {
        orangeColor++;
      }
    }

    for (var r = 0; r < _lengthOfList; r++) {
      if (_notFutureListOfTask[r]["isCompleted"] == 0){
        todoCount++;
      } else if (_notFutureListOfTask[r]["isCompleted"] == 1) {
        completedCount++;
      }
    }

    for (var r = 0; r < _lengthOfList; r++) {
      if (_notFutureListOfTask[r]["type"] == "Work"){
        workType++;
      } else if (_notFutureListOfTask[r]["type"] == "Dinner") {
        dinnerType++;
      } else if (_notFutureListOfTask[r]["type"] == "Lunch") {
        lunchType++;
      } else if (_notFutureListOfTask[r]["type"] == "Sport") {
        sportType++;
      } else if (_notFutureListOfTask[r]["type"] == "Meditation") {
        meditationType++;
      } else if (_notFutureListOfTask[r]["type"] == "Entertainment") {
        entertainmentType++;
      }
    }

    totalType = workType + dinnerType + lunchType + sportType + meditationType + entertainmentType;

    sumColor = greenColor + blueColor + orangeColor;

    totalCount = todoCount + completedCount;

    List<PieChartSectionData> tempList = [];
    List<PieChartSectionData> tempList2 = [];

    dataList.clear();
    tempList.add(PieChartSectionData(
      title: "Green Event ${(greenColor * 100 / sumColor).toStringAsFixed(0)} %",
      color: const Color(0xFF26A69A),
      value: (greenColor / sumColor),
      titleStyle: const TextStyle(
          color: Color(0xFF757575), fontSize: 20, fontWeight: FontWeight.bold),
    ));
    tempList.add(PieChartSectionData(
      title: "Blue Event ${(blueColor * 100 / sumColor).toStringAsFixed(0)} %",
      color: const Color(0xFF1A237E),
      value: (blueColor / sumColor),
      titleStyle: const TextStyle(
          color: Color(0xFF757575), fontSize: 20, fontWeight: FontWeight.bold),
    ));
    tempList.add(PieChartSectionData(
      title: "Orange Event ${(orangeColor * 100 / sumColor).toStringAsFixed(0)} %",
      color: const Color(0xFFE65100),
      value: (orangeColor / sumColor),
      titleStyle: const TextStyle(
          color: Color(0xFF757575), fontSize: 20, fontWeight: FontWeight.bold),
    ));

    typeDataList.clear();
    tempList2.add(PieChartSectionData(
      title: "Work ${(workType * 100 / totalType).toStringAsFixed(0)} %",
      color: const Color(0xFF69F0AE),
      value: (workType / totalType),
      titleStyle: const TextStyle(
          color: Color(0xFF757575), fontSize: 20, fontWeight: FontWeight.bold),
    ));
    tempList2.add(PieChartSectionData(
      title: "Dinner ${(dinnerType * 100 / totalType).toStringAsFixed(0)} %",
      color: const Color(0xFF29B6F6),
      value: (dinnerType / totalType),
      titleStyle: const TextStyle(
          color: Color(0xFF757575), fontSize: 20, fontWeight: FontWeight.bold),
    ));
    tempList2.add(PieChartSectionData(
      title: "Lunch ${(lunchType * 100 / totalType).toStringAsFixed(0)} %",
      color: const Color(0xFFBCAAA4),
      value: (lunchType / totalType),
      titleStyle: const TextStyle(
          color: Color(0xFF757575), fontSize: 20, fontWeight: FontWeight.bold),
    ));
    tempList2.add(PieChartSectionData(
      title: "Meditation ${(meditationType * 100 / totalType).toStringAsFixed(0)} %",
      color: const Color(0xFF9575CD),
      value: (meditationType / totalType),
      titleStyle: const TextStyle(
          color: Color(0xFF757575), fontSize: 20, fontWeight: FontWeight.bold),
    ));
    tempList2.add(PieChartSectionData(
      title: "Sport ${(sportType * 100 / totalType).toStringAsFixed(0)} %",
      color: const Color(0xFFFFD740),
      value: (sportType / totalType),
      titleStyle: const TextStyle(
          color: Color(0xFF757575), fontSize: 20, fontWeight: FontWeight.bold),
    ));
    tempList2.add(PieChartSectionData(
      title: "Entertainment ${(entertainmentType * 100 / totalType).toStringAsFixed(0)} %",
      color: const Color(0xFFFF80AB),
      value: (entertainmentType / totalType),
      titleStyle: const TextStyle(
          color: Color(0xFF757575), fontSize: 20, fontWeight: FontWeight.bold),
    ));

    setState(() {
      dataList = tempList;
      typeDataList = tempList2;
    });

    print("This is the count of Pink: $greenColor");
    print("This is the count of Blue: $blueColor");
    print("This is the count of Orange: $orangeColor");
    print("This is the sum count: $sumColor");
  }
}
