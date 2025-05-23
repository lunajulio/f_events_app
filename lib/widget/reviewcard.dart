// widgets/review_card.dart
import 'package:event_app/models/review.dart';
import 'package:flutter/material.dart';

class ReviewCard extends StatelessWidget {
  final Review review;

  const ReviewCard({
    super.key,
    required this.review,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rating
            Row(
              children: List.generate(5, (index) {
                if (index < review.rating.floor()) {
                  return Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 24,
                  );
                } else if (index < review.rating) {
                  return Icon(
                    Icons.star_half,
                    color: Colors.amber,
                    size: 24,
                  );
                } else {
                  return Icon(
                    Icons.star_border,
                    color: Colors.amber,
                    size: 24,
                  );
                }
              }),
            ),
            SizedBox(height: 8),
            // Fecha
            Text(
              '${review.createdAt.day}/${review.createdAt.month}/${review.createdAt.year}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            SizedBox(height: 12),
            // Comentario
            Text(
              review.comment,
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 16,
                height: 1.4,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}