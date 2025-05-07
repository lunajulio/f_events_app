// lib/models/event_model.dart
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'event_category.dart';
import 'review.dart';

part 'event.g.dart'; // Este archivo será generado automáticamente

@HiveType(typeId: 0)
class Event {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final String location;
  
  @HiveField(3)
  final DateTime dateTime;
  
  @HiveField(4)
  final String description;
  
  @HiveField(5)
  final int maxParticipants;
  
  // Cambiamos a variables no finales para permitir la gestión manual de valores reactivos
  @HiveField(6)
  int _currentParticipantsValue;
  RxInt currentParticipants;
  
  @HiveField(7)
  final EventCategory category;
  
  @HiveField(8)
  final bool isPastEvent;
  
  @HiveField(9)
  final String imageUrl;
  
  @HiveField(10)
  double _ratingValue;
  RxDouble rating;
  
  @HiveField(11)
  int totalRatings;
  
  @HiveField(12)
  List<Review> _reviewsList;
  // Hacemos que la lista de reviews sea reactiva
  late RxList<Review> reviews;

  Event({
    required this.id,
    required this.title,
    required this.location,
    required this.dateTime,
    required this.description,
    required this.maxParticipants,
    int? currentParticipants,
    required this.category,
    this.isPastEvent = false,
    required this.imageUrl,
    double rating = 0.0,
    this.totalRatings = 0,
    List<Review>? reviews,
  }) : 
       this._currentParticipantsValue = currentParticipants ?? 0,
       this.currentParticipants = (currentParticipants ?? 0).obs,
       this._ratingValue = rating,
       this.rating = rating.obs,
       this._reviewsList = reviews ?? [] {
    // Inicializar la lista reactiva de reviews
    this.reviews = (_reviewsList).obs;
  }

  // Getters
  bool get isFull => currentParticipants.value >= maxParticipants;
  String get availableSpots => "${maxParticipants - currentParticipants.value} spots available";

  String get day => dateTime.day.toString();
  String get year => dateTime.year.toString();
  String get month => DateFormat('MMM', 'es').format(dateTime);
  String get time => DateFormat('HH:mm').format(dateTime);
  
  // Métodos especiales para Hive
  // Estos se llamarán antes de guardar y después de cargar
  void beforeSave() {
    _currentParticipantsValue = currentParticipants.value;
    _ratingValue = rating.value;
    _reviewsList = reviews.toList(); // Guardar la lista actual de reviews
  }
  
  void afterLoad() {
    currentParticipants = _currentParticipantsValue.obs;
    rating = _ratingValue.obs;
    reviews = _reviewsList.obs; // Inicializar la lista reactiva con los valores guardados
  }
  
  // Método para agregar una reseña
  void addReview(Review review) {
    reviews.add(review);
    // Actualizar la calificación promedio
    double totalScore = 0;
    for (var rev in reviews) {
      totalScore += rev.rating;
    }
    totalRatings = reviews.length;
    rating.value = totalRatings > 0 ? totalScore / totalRatings : 0.0;
    // Actualizar los valores para Hive
    beforeSave();
  }
}