import 'package:event_app/controllers/event_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/event.dart';
import 'subscription_success.dart';

class EventDetailsPage extends StatelessWidget {
  final Event event;
  final EventController controller = Get.find();

  EventDetailsPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth;
          final maxHeight = constraints.maxHeight;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: maxHeight * 0.35,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/${event.id}.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: maxHeight * 0.05,
                      left: maxWidth * 0.02,
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: maxWidth * 0.06,
                        ),
                        onPressed: () => Get.back(),
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: EdgeInsets.all(maxWidth * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título y fecha
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              event.title,
                              style: TextStyle(
                                fontSize: maxWidth * 0.06,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(maxWidth * 0.02),
                            decoration: BoxDecoration(
                              color: Colors.pink,
                              borderRadius: BorderRadius.circular(maxWidth * 0.02),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  event.day,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: maxWidth * 0.05,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  event.month,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: maxWidth * 0.035,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: maxHeight * 0.02),

                      // Información del evento
                      _buildInfoRow(Icons.location_on, event.location, maxWidth),
                      SizedBox(height: maxHeight * 0.01),
                      _buildInfoRow(Icons.access_time, event.time, maxWidth),
                      _buildInfoRow(
                        Icons.people,
                        '${event.maxParticipants - event.currentParticipants.value} spots available',
                        maxWidth
                      ),

                      SizedBox(height: maxHeight * 0.02),

                      // Etiquetas
                      _buildTag('Upcoming Event', maxWidth, maxHeight),
                      SizedBox(height: maxHeight * 0.01),
                      _buildTag(event.category.name, maxWidth, maxHeight),

                      SizedBox(height: maxHeight * 0.02),

                      // Descripción
                      Text(
                        'About ${event.title}',
                        style: TextStyle(
                          fontSize: maxWidth * 0.045,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: maxHeight * 0.01),
                      Text(
                        event.description,
                        style: TextStyle(
                          color: Colors.grey[600],
                          height: 1.5,
                          fontSize: maxWidth * 0.035,
                        ),
                      ),

                      SizedBox(height: maxHeight * 0.03),

                      // Botón de suscripción
                      Obx(() => SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (!controller.isSubscribed(event)) {
                              controller.toggleSubscription(event);
                              Get.to(() => SubscriptionSuccess(), 
                                transition: Transition.fadeIn
                              );
                            } else {
                              controller.toggleSubscription(event);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink,
                            padding: EdgeInsets.symmetric(
                              vertical: maxHeight * 0.02
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(maxWidth * 0.03),
                            ),
                          ),
                          child: Text(
                            controller.isSubscribed(event) 
                                ? 'Unsubscribe' 
                                : 'Subscribe',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: maxWidth * 0.04,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, double maxWidth) {
    return Row(
      children: [
        Icon(icon, size: maxWidth * 0.04, color: Colors.grey),
        SizedBox(width: maxWidth * 0.02),
        Text(
          text,
          style: TextStyle(
            color: Colors.grey,
            fontSize: maxWidth * 0.035,
          ),
        ),
      ],
    );
  }

  Widget _buildTag(String text, double maxWidth, double maxHeight) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: maxWidth * 0.03,
        vertical: maxHeight * 0.008,
      ),
      decoration: BoxDecoration(
        color: Colors.pink.shade100,
        borderRadius: BorderRadius.circular(maxWidth * 0.05),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.pink,
          fontSize: maxWidth * 0.03,
        ),
      ),
    );
  }
}