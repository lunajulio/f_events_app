import 'package:event_app/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/event_controller.dart'; // Import the EventController

void main() {
  // Register the EventController before the app starts
  Get.put(EventController());  // Registers EventController globally

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Event App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MainPage(),  // Your initial screen
    );
  }
}