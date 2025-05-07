import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:event_app/controllers/event_controller.dart';
import 'package:event_app/models/event.dart';
import 'package:event_app/models/review.dart';
import 'package:event_app/models/event_category.dart';
import 'package:flutter/material.dart';
import 'package:event_app/services/sync_service.dart';

// Implementación básica de SyncService para pruebas
  @override
  Future<bool> addReview(String eventId, Review review) async {
    return true; // Simplemente retorna éxito para las pruebas
  }

  @override
  Future<bool> addEvent(Event event) async {
    return true; // Retorna éxito para las pruebas
  }

  @override
  Future<bool> deleteAllRemoteEvents() async {
    return true; // Retorna éxito para las pruebas
  }

  @override
  Future<bool> deleteEvent(String eventId) async {
    return true; // Retorna éxito para las pruebas
  }

  @override
  void dispose() {
    // No se necesita implementación para las pruebas
  }

  @override
  Future<List<Event>> fetchEvents() async {
    return []; // Retorna una lista vacía para las pruebas
  }

  @override
  Future<bool> syncEvents(List<Event> events) async {
    return true; // Retorna éxito para las pruebas
  }

  @override
  Future<bool> updateEvent(Event event) async {
    return true; // Retorna éxito para las pruebas
  }
}

void main() {
  late EventController eventController;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    Get.testMode = true; // Configurar GetX en modo de prueba
    
    // Registrar SyncService antes que EventController
    Get.put<SyncService>(TestSyncService());
    
    eventController = EventController();
    Get.put(eventController);
  });

  tearDown(() {
    Get.delete<EventController>();
    Get.delete<SyncService>();
  });

  test('loadEvents should populate allEvents', () {
    eventController.loadEvents();
    expect(eventController.allEvents.isNotEmpty, true);
  });

  test('toggleSubscription should subscribe and unsubscribe to an event', () {
    final event = Event(
      id: '1',
      title: 'Test Event',
      location: 'Test Location',
      dateTime: DateTime.now().add(Duration(days: 1)),
      description: 'Test Description',
      maxParticipants: 100,
      category: EventCategory.conference,
      imageUrl: 'assets/images/1.jpg',
    );

    eventController.toggleSubscription(event);
    expect(eventController.isSubscribed(event), true);

    eventController.toggleSubscription(event);
    expect(eventController.isSubscribed(event), false);
  });

  test('addReview should add a review and update the rating', () {
    final event = Event(
      id: '1',
      title: 'Test Event',
      location: 'Test Location',
      dateTime: DateTime.now().add(Duration(days: 1)),
      description: 'Test Description',
      maxParticipants: 100,
      category: EventCategory.course,
      imageUrl: 'assets/images/1.jpg',
    );

    eventController.addReview(event, 5.0, 'Great event!', showSnackbar: false);
    expect(event.reviews.length, 1);
    expect(event.rating.value, 5.0);
  });

  test('searchEvents should filter events by query', () {
    final event1 = Event(
      id: '1',
      title: 'Music Festival',
      location: 'City Park',
      dateTime: DateTime.now().add(Duration(days: 1)),
      description: 'A great music festival.',
      maxParticipants: 100,
      category: EventCategory.investigation,
      imageUrl: 'assets/images/1.jpg',
    );

    final event2 = Event(
      id: '2',
      title: 'Art Exhibition',
      location: 'Art Gallery',
      dateTime: DateTime.now().add(Duration(days: 2)),
      description: 'An amazing art exhibition.',
      maxParticipants: 50,
      category: EventCategory.course,
      imageUrl: 'assets/images/2.jpg',
    );

    eventController.loadEvents();
    eventController.allEvents.addAll([event1, event2]);
    eventController.featuredEvents.addAll([event1]);
    eventController.recommendedEvents.addAll([event2]);

    eventController.searchEvents('Music');
    expect(eventController.searchResults.length, 1);
    expect(eventController.searchResults.first.title, 'Music Festival');
  });
}