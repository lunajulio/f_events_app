import 'package:event_app/controllers/event_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/event.dart';
import '../widget/reviewcard.dart';
import '../widget/add_review_dialog.dart';

class PastEventDetailsPage extends StatelessWidget {
  final Event event;
  EventController eventController = Get.find();

  PastEventDetailsPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen y botones de navegación
            Stack(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/${event.id}.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 10,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Get.back(),
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 10,
                  child: IconButton(
                    icon: Icon(Icons.more_horiz, color: Colors.white),
                    onPressed: () {},
                  ),
                ),
              ],
            ),

            // Contenido principal
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título y fecha
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          event.title,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Text(
                              event.day,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              event.month,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  // Información del evento
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(
                        event.location,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 16, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(
                        '${event.time}',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  // Etiqueta de evento pasado
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Past Event',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 12,
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Descripción
                  Text(
                    'About ${event.title}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    event.description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                  
                  SizedBox(height: 24),

                  // Sección de Rating
                  GetX<EventController>(
                    builder: (controller) => Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rating',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Text(
                                event.rating.value.toStringAsFixed(1),
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 16),
                              Row(
                                children: List.generate(5, (index) {
                                  return Icon(
                                    index < event.rating.value ? Icons.star : Icons.star_border,
                                    color: Colors.orange,
                                    size: 24,
                                  );
                                }),
                              ),
                            ],
                          ),
                          Text(
                            '${event.totalRatings.value} ratings',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 24),

                  // Sección de Reseñas
                  GetX<EventController>(
                    builder: (controller) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Reseñas',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (event.reviews.isNotEmpty)
                                Text(
                                  '${event.reviews.length} reviews',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (event.reviews.isNotEmpty)
                          SizedBox(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: BouncingScrollPhysics(),
                              itemCount: event.reviews.length,
                              itemBuilder: (context, index) => ReviewCard(
                                review: event.reviews[index],
                              ),
                            ),
                          )
                        else
                          Text(
                            'No hay reseñas aún',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24),
                  
                  // Botón de añadir reseña
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.dialog(
                          AddReviewDialog(
                            onSubmit: (rating, comment) {
                              eventController.addReview(event, rating, comment);
                              Get.back(); // Cierra el diálogo
                            },
                          ),
                          barrierDismissible: true,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Añadir reseña',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}