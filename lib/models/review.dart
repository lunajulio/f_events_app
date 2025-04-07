// Clase Review simplificada para reseñas anónimas
class Review {
  final String comment;
  final double rating;
  final DateTime createdAt;

  Review({
    required this.comment,
    required this.rating,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      comment: json['comment'],
      rating: json['rating'].toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'comment': comment,
      'rating': rating,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}