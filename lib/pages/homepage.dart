import 'package:event_app/pages/eventlist.dart';
import 'package:event_app/widget/eventcard.dart';
import 'package:flutter/material.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upcoming Events")),
      body: ListView.builder(
        itemCount: EventsList.length,
        itemBuilder: (context, index) {
          return EventCard(event: EventsList[index]);
        },
      ),
    );
  }
}