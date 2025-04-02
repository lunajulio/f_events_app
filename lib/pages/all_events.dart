import 'package:event_app/pages/eventlist.dart';
import 'package:event_app/widget/eventcard.dart';
import 'package:flutter/material.dart';



class AllEventsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("All Events")),
      body: ListView.builder(
        itemCount: EventsList.length,
        itemBuilder: (context, index) {
          return EventCard(event: EventsList[index]);
        },
      ),
    );
  }
}