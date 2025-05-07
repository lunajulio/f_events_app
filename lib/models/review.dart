import 'package:hive/hive.dart';

part 'review.g.dart'; // Este archivo será generado automáticamente

@HiveType(typeId: 1)
class Review {
  @HiveField(0)
  final String comment;
  
  @HiveField(1)
  final double rating;
  
  @HiveField(2)
  final DateTime createdAt;

  Review({
    required this.comment,
    required this.rating,
    required this.createdAt,
  });
}