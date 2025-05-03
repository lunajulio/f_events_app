import 'package:flutter_test/flutter_test.dart';
import 'package:event_app/models/event.dart';
import 'package:event_app/models/event_category.dart';

void main() {
  group('Event Model Tests', () {
    test('Crear un evento y verificar propiedades iniciales', () {
      final event = Event(
        id: '1',
        title: 'Concierto de Rock',
        location: 'Auditorio Nacional',
        dateTime: DateTime(2025, 5, 1, 20, 0),
        description: 'Un concierto inolvidable.',
        maxParticipants: 100,
        category: EventCategory.course,
        imageUrl: 'https://example.com/image.jpg',
      );

      expect(event.id, '1');
      expect(event.title, 'Concierto de Rock');
      expect(event.isFull, false);
      expect(event.availableSpots, '100 spots available');
    });

    test('Actualizar participantes y verificar estado', () {
      final event = Event(
        id: '2',
        title: 'Taller de Pintura',
        location: 'Centro Cultural',
        dateTime: DateTime(2025, 6, 15, 10, 0),
        description: 'Aprende técnicas de pintura.',
        maxParticipants: 20,
        category: EventCategory.workshop,
        imageUrl: 'https://example.com/image2.jpg',
      );

      event.currentParticipants.value = 20;
      expect(event.isFull, true);
      expect(event.availableSpots, '0 spots available');
    });
  });
}