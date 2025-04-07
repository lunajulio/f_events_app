// lib/models/event_model.dart
import 'package:event_app/models/review.dart';

class Event {
  final String id;
  final String title;
  final String location;
  final String dateTime;
  final String description;
  final int maxParticipants;
  int currentParticipants;
  final bool isPastEvent;
  final String imageUrl;
  final double rating;
  final int totalRatings;
  final List<Review> reviews; // Nueva lista para las reseñas

  Event({
    required this.id,
    required this.title,
    required this.location,
    required this.dateTime,
    required this.description,
    required this.maxParticipants,
    this.currentParticipants = 0,
    this.isPastEvent = false,
    required this.imageUrl,
    this.rating = 0.0,
    this.totalRatings = 0,
    this.reviews = const [],
  });

  // Getters
  bool get isFull => currentParticipants >= maxParticipants;
  String get availableSpots => "${maxParticipants - currentParticipants} spots available";
  String get day => dateTime.split(' ')[0];
  String get month => dateTime.split(' ')[1].toLowerCase();
  String get time => dateTime.split(' ').last;

  // Factory constructor para crear un Event desde un Map (útil para JSON)
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      location: json['location'],
      dateTime: json['dateTime'],
      description: json['description'],
      maxParticipants: json['maxParticipants'],
      currentParticipants: json['currentParticipants'],
      isPastEvent: json['isPastEvent'],
      imageUrl: json['imageUrl'],
      rating: json['rating'].toDouble(),
      totalRatings: json['totalRatings'],
      reviews: (json['reviews'] as List?)
          ?.map((review) => Review.fromJson(review))
          .toList() ?? [],
    );
  }

  // Método para convertir el Event a un Map (útil para JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'location': location,
      'dateTime': dateTime,
      'description': description,
      'maxParticipants': maxParticipants,
      'currentParticipants': currentParticipants,
      'isPastEvent': isPastEvent,
      'imageUrl': imageUrl,
      'rating': rating,
      'totalRatings': totalRatings,
      'reviews': reviews.map((review) => review.toJson()).toList(),
    };
  }

  // Método para crear una copia del evento con algunos campos actualizados
  Event copyWith({
    String? id,
    String? title,
    String? location,
    String? dateTime,
    String? description,
    int? maxParticipants,
    int? currentParticipants,
    bool? isPastEvent,
    String? imageUrl,
    double? rating,
    int? totalRatings,
    List<Review>? reviews,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      location: location ?? this.location,
      dateTime: dateTime ?? this.dateTime,
      description: description ?? this.description,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      currentParticipants: currentParticipants ?? this.currentParticipants,
      isPastEvent: isPastEvent ?? this.isPastEvent,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      totalRatings: totalRatings ?? this.totalRatings,
      reviews: reviews ?? this.reviews,
    );
  }
}