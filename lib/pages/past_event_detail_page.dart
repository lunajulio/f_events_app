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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth;
          final maxHeight = constraints.maxHeight;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagen y botones de navegación
                Stack(
                  children: [
                    Container(
                      height: maxHeight * 0.3,
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
                    Positioned(
                      top: maxHeight * 0.05,
                      right: maxWidth * 0.02,
                      child: IconButton(
                        icon: Icon(
                          Icons.more_horiz,
                          color: Colors.white,
                          size: maxWidth * 0.06,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),

                // Contenido principal
                Padding(
                  padding: EdgeInsets.all(maxWidth * 0.05),
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
                                fontSize: maxWidth * 0.06,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(maxWidth * 0.02),
                            decoration: BoxDecoration(
                              color: Colors.purple,
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
                      Row(
                        children: [
                          Icon(Icons.location_on, size: maxWidth * 0.04, color: Colors.grey),
                          SizedBox(width: maxWidth * 0.02),
                          Text(
                            event.location,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: maxWidth * 0.035,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: maxHeight * 0.01),

                      Row(
                        children: [
                          Icon(Icons.access_time, size: maxWidth * 0.04, color: Colors.grey),
                          SizedBox(width: maxWidth * 0.02),
                          Text(
                            event.time,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: maxWidth * 0.035,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: maxHeight * 0.02),

                      // Etiquetas
                      Wrap(
                        spacing: maxWidth * 0.02,
                        children: [
                          _buildTag('Past Event', maxWidth, maxHeight),
                          _buildTag(event.category.name, maxWidth, maxHeight),
                        ],
                      ),

                      SizedBox(height: maxHeight * 0.02),

                      // Sección de Rating y reseñas
                      _buildRatingSection(maxWidth, maxHeight),
                      
                      SizedBox(height: maxHeight * 0.02),

                      // Sección de reseñas
                      _buildReviewsSection(maxWidth, maxHeight),

                      SizedBox(height: maxHeight * 0.02),

                      // Botón de añadir reseña
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _showAddReviewDialog(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            padding: EdgeInsets.symmetric(vertical: maxHeight * 0.02),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(maxWidth * 0.03),
                            ),
                          ),
                          child: Text(
                            'Añadir reseña',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: maxWidth * 0.04,
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
          );
        },
      ),
    );
  }

  Widget _buildTag(String text, double maxWidth, double maxHeight) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: maxWidth * 0.03,
        vertical: maxHeight * 0.008,
      ),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(maxWidth * 0.05),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.orange,
          fontSize: maxWidth * 0.03,
        ),
      ),
    );
  }

  Widget _buildRatingSection(double maxWidth, double maxHeight) {
    return GetX<EventController>(
      builder: (controller) => Container(
        padding: EdgeInsets.all(maxWidth * 0.04),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(maxWidth * 0.03),
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
                fontSize: maxWidth * 0.045,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: maxHeight * 0.015),
            Row(
              children: [
                Text(
                  event.rating.value.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: maxWidth * 0.08,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: maxWidth * 0.04),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < event.rating.value ? Icons.star : Icons.star_border,
                      color: Colors.orange,
                      size: maxWidth * 0.06,
                    );
                  }),
                ),
              ],
            ),
            Text(
              '${event.totalRatings.value} ratings',
              style: TextStyle(
                color: Colors.grey,
                fontSize: maxWidth * 0.035,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsSection(double maxWidth, double maxHeight) {
    return GetX<EventController>(
      builder: (controller) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Reseñas',
                style: TextStyle(
                  fontSize: maxWidth * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (event.reviews.isNotEmpty)
                Text(
                  '${event.reviews.length} reviews',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: maxWidth * 0.035,
                  ),
                ),
            ],
          ),
          SizedBox(height: maxHeight * 0.02),
          if (event.reviews.isNotEmpty)
            SizedBox(
              height: maxHeight * 0.25,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemCount: event.reviews.length,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.only(right: maxWidth * 0.04),
                  child: ReviewCard(review: event.reviews[index]),
                ),
              ),
            )
          else
            Text(
              'No hay reseñas aún',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: maxWidth * 0.04,
              ),
            ),
        ],
      ),
    );
  }

  void _showAddReviewDialog() {
    Get.dialog(
      AddReviewDialog(
        onSubmit: (rating, comment) {
          eventController.addReview(event, rating, comment);
          Get.back();
        },
      ),
      barrierDismissible: true,
    );
  }
}