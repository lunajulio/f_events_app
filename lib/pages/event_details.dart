import 'package:event_app/controllers/event_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventDetailsPage extends StatelessWidget {
  final Event event;
  EventController eventController = Get.find(); 

   EventDetailsPage({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(event.title)),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event.description, style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text("Location: ${event.location}"),
            Text("Date: ${event.dateTime}"),
            Text("Available Spots: ${event.maxParticipants - event.currentParticipants}"),
           Obx(() {
              bool isSubscribed = eventController.isSubscribed(event);
              return ElevatedButton(
                onPressed: () {
                  eventController.toggleSubscription(event);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSubscribed ? Colors.red : Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(isSubscribed ? 'Unsubscribe' : 'Subscribe'),
              );
            }),

            //feedback
            if (!event.isFull)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text("Feedback Section", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
          ],
        ),
      ),
    );
  }
}

class FeedbackSection extends StatelessWidget {
  final RxInt rating = 0.obs;
  final TextEditingController feedbackController = TextEditingController();

  void submitFeedback() {
    if (rating.value == 0 || feedbackController.text.isEmpty) {
      // Show an error
      return;
    }
    // Submit the feedback to backend
    print('Rating: ${rating.value}, Feedback: ${feedbackController.text}');
    // Reset after submission
    rating.value = 0;
    feedbackController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Rate this event', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(5, (index) {
            return IconButton(
              icon: Icon(
                index < rating.value ? Icons.star : Icons.star_border,
                color: Colors.amber,
              ),
              onPressed: () {
                rating.value = index + 1;
              },
            );
          }),
        ),
        Text('Your feedback', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        TextField(
          controller: feedbackController,
          decoration: InputDecoration(hintText: 'Leave your feedback here'),
          maxLines: 3,
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: submitFeedback,
          child: Text('Submit Feedback'),
        ),
      ],
    );
  }
}