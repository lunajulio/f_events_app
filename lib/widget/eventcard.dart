import 'package:event_app/pages/past_event_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/event_controller.dart';
import '../pages/event_details.dart';
import '../pages/past_event_detail_page.dart';
import '../models/event.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final bool isMainCard;
  final EventController controller = Get.find();

  EventCard({
    super.key,
    required this.event,
    this.isMainCard = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(
        () => event.isPastEvent 
            ? PastEventDetailsPage(event: event)
            : EventDetailsPage(event: event)
      ),
      child: Container(
        height: isMainCard ? 200 : 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage('assets/images/${event.id}.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    event.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isMainCard ? 24 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.location,
                          style: TextStyle(color: Colors.white, fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text(
                        '${event.day}-${event.month}-${event.year} at ${event.time}',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                  if (isMainCard) ...[
                    SizedBox(height: 4),
                    Obx(() => Row(
                      children: [
                        Icon(Icons.people, color: Colors.white, size: 16),
                        SizedBox(width: 4),
                        Text(
                          '${event.maxParticipants - event.currentParticipants.value} spots available',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    )),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}