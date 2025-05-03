import 'package:event_app/pages/past_event_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/event_controller.dart';
import '../pages/event_details.dart';
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final maxHeight = constraints.maxHeight;

        return GestureDetector(
          onTap: () => Get.to(
            () => event.isPastEvent 
                ? PastEventDetailsPage(event: event)
                : EventDetailsPage(event: event)
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(maxWidth * 0.05),
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
                      borderRadius: BorderRadius.circular(maxWidth * 0.05),
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
                  padding: EdgeInsets.all(maxWidth * 0.03),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          event.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isMainCard ? maxWidth * 0.055 : maxWidth * 0.045,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: maxHeight * 0.08),
                        Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.white, size: maxWidth * 0.04),
                            SizedBox(width: maxWidth * 0.01),
                            Expanded(
                              child: Text(
                                event.location,
                                style: TextStyle(color: Colors.white, fontSize: maxWidth * 0.035),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: maxHeight * 0.008),
                        Row(
                          children: [
                            Icon(Icons.calendar_today, color: Colors.white, size: maxWidth * 0.04),
                            SizedBox(width: maxWidth * 0.01),
                            Expanded(
                              child: Text(
                                '${event.day}-${event.month}-${event.year} at ${event.time}',
                                style: TextStyle(color: Colors.white, fontSize: maxWidth * 0.035),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        if (isMainCard) ...[
                          SizedBox(height: maxHeight * 0.008),
                          Obx(() => Row(
                            children: [
                              Icon(Icons.people, color: Colors.white, size: maxWidth * 0.04),
                              SizedBox(width: maxWidth * 0.01),
                              Text(
                                '${event.maxParticipants - event.currentParticipants.value} spots available',
                                style: TextStyle(color: Colors.white, fontSize: maxWidth * 0.035),
                              ),
                            ],
                          )),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}