import 'package:flutter/material.dart';
import 'package:fyp_calendar_2/ui/home_page.dart';
import 'package:fyp_calendar_2/ui/oci_add_event_page.dart';
import 'package:get/get.dart';
import 'add_event_page.dart';

class ResultScreen extends StatelessWidget {
  final String text;

  const ResultScreen({super.key, required this.text});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pinkAccent,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () async {
              await Get.to(() => CalendarScreen());
            },
          ),
          centerTitle: true,
          title: Text(
            'R e s u l t',
            style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.upload_outlined,
                color: Colors.white,
              ),
              tooltip: 'Add Schedule',
              onPressed: () async {
                await Get.to(() => OCRAddEventPage(ocrText: text));
              },
            ),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(30.0),
          child: Text(text),
        ),
      );
}
