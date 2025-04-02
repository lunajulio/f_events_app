import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/event_controller.dart';
import '../pages/event_details.dart';



class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("Navigating to: ${event.title}");
        //Get.to<EventDetailsPage>(() => EventDetailsPage(event: event));
        Get.to(() => EventDetailsPage(event: event));
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(event.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text("Location: ${event.location}"),
              Text("Date: ${event.dateTime}"),
              Text("Available Spots: ${event.maxParticipants - event.currentParticipants}"),
              
            ],
          ),
        ),
      ),
    );
  }
}