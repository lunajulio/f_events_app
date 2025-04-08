// lib/models/event_model.dart
import 'package:event_app/models/review.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Event {
  final String id;
  final String title;
  final String location;
  final DateTime dateTime;
  final String description;
  final int maxParticipants;
  RxInt currentParticipants;
  final bool isPastEvent;
  final String imageUrl;
  RxDouble rating;
  RxInt totalRatings;
  RxList<Review> reviews;

  Event({
    required this.id,
    required this.title,
    required this.location,
    required this.dateTime,
    required this.description,
    required this.maxParticipants,
    int currentParticipants = 0,
    this.isPastEvent = false,
    required this.imageUrl,
    double rating = 0.0,
    int totalRatings = 0,
    List<Review> reviews = const [],
  }) : 
    this.currentParticipants = currentParticipants.obs,
    this.rating = rating.obs,
    this.totalRatings = totalRatings.obs,
    this.reviews = reviews.obs;

  // Getters
  bool get isFull => currentParticipants.value >= maxParticipants;
  String get availableSpots => "${maxParticipants - currentParticipants.value} spots available";

  String get day => dateTime.day.toString();

  String get year => dateTime.year.toString();
  
  String get month => DateFormat('MMM', 'es').format(dateTime);
  
  String get time => DateFormat('HH:mm').format(dateTime);
}