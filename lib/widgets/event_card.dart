import 'package:flutter/material.dart';
import '../models/events.dart';

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final hasImage = event.image != null && event.image!.isNotEmpty;

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Stack(
        children: [
          hasImage
              ? Image.asset(
                  event.image!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              : Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
          Positioned(
            left: 12,
            bottom: 12,
            child: Text(
              '${event.title}\n${event.location} • ${event.date}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (event.subscribed)
            const Positioned(
              top: 12,
              right: 12,
              child: Icon(Icons.star, color: Colors.yellow),
            ),
        ],
      ),
    );
  }
}