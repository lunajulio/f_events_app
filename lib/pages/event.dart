import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/event_controller.dart';


class EventDetailsPage extends StatelessWidget {
  final Event event;

  EventDetailsPage({required this.event});

  @override
  Widget build(BuildContext context) {
    final EventController eventController = Get.find<EventController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event.description, style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text("Location: ${event.location}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text("Date & Time: ${event.dateTime}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Obx(() => Text(
                  "Available Spots: ${event.maxParticipants - event.currentParticipants}",
                  style: TextStyle(
                      fontSize: 16, color: (event.maxParticipants - event.currentParticipants > 0) ? Colors.green : Colors.red),
                )),
            SizedBox(height: 20),
            Obx(() => ElevatedButton(
                  onPressed: () {
                    eventController.toggleSubscription(event);
                  },
                  child: Text(eventController.isSubscribed(event) ? "Unsubscribe" : "Subscribe"),
                )),
            SizedBox(height: 20),
            Expanded(child: FeedbackSection(event: event)),
          ],
        ),
      ),
    );
  }
}

class FeedbackSection extends StatelessWidget {
  final Event event;
  final RxInt rating = 0.obs;
  final TextEditingController feedbackController = TextEditingController();

  FeedbackSection({required this.event});

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