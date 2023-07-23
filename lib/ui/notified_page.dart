import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class NotifiedPage extends StatelessWidget {
  final String? label;

  const NotifiedPage({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
        ),
        backgroundColor: Colors.pinkAccent,
        centerTitle: true,
        title: Text(
          this.label.toString().split("|")[0],
          style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Container(
            height: 400,
            width: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey[400]!,
            ),
            child: Center(
              child: Text(this.label.toString().split("|")[1],
                  style: const TextStyle(color: Colors.white, fontSize: 25)),
            )),
      ),
    );
  }
}
