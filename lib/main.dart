import 'package:flutter/material.dart';
import 'pages/main_page.dart';

void main() {
  runApp(const EventApp());
}

class EventApp extends StatelessWidget {
  const EventApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event App',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
} 