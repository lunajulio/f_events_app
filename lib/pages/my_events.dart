import 'package:event_app/widget/eventcard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/event_controller.dart';


class MyEventsPage extends StatelessWidget {
  final EventController eventController = Get.find<EventController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Subscribed Events")),
      body: Obx(() {
        return ListView.builder(
          itemCount: eventController.subscribedEvents.length,
          itemBuilder: (context, index) {
            return EventCard(event: eventController.subscribedEvents[index]);
          },
        );
      }),
    );
  }
}