import 'package:flutter_test/flutter_test.dart';
import 'package:event_app/models/review.dart';

void main() {
  group('Review Model Tests', () {
    test('Crear una reseña y verificar propiedades', () {
      final review = Review(
        comment: 'Excelente evento, muy bien organizado.',
        rating: 4.5,
        createdAt: DateTime(2025, 5, 1, 18, 0),
      );

      expect(review.comment, 'Excelente evento, muy bien organizado.');
      expect(review.rating, 4.5);
      expect(review.createdAt, DateTime(2025, 5, 1, 18, 0));
    });
  });
}