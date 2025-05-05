import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:event_app/pages/past_event_detail_page.dart';
import 'package:event_app/models/event.dart';
import 'package:event_app/controllers/event_controller.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:event_app/models/event_category.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('en_US', null);
  });

  setUp(() {
    Get.put(EventController());
  });

  testWidgets('should display event details correctly', (WidgetTester tester) async {
    final testEvent = Event(
      id: '1',
      title: 'Test Event',
      location: 'Test Location',
      dateTime: DateTime(2025, 5, 5, 10, 0),
      description: 'This is a test event.',
      maxParticipants: 100,
      currentParticipants: RxInt(50).value,
      category: EventCategory.workshop,
      isPastEvent: true,
      imageUrl: 'assets/images/1.jpg',
      rating: RxDouble(4.5).value,
      totalRatings: RxInt(20).value,
      reviews: RxList([]),
    );

    await tester.pumpWidget(
      GetMaterialApp(
        home: PastEventDetailsPage(event: testEvent),
      ),
    );

    // Verificar que el título del evento se muestra
    expect(find.text('Test Event'), findsOneWidget);

    // Verificar que la ubicación se muestra
    expect(find.text('Test Location'), findsOneWidget);

    // Verificar que la hora se muestra correctamente
    expect(find.text('10:00'), findsOneWidget); 

    // Verificar que el botón de añadir reseña se muestra
    expect(find.text('Añadir reseña'), findsOneWidget);
  });

  testWidgets('should display no reviews message when no reviews are available', (WidgetTester tester) async {
    final testEvent = Event(
      id: '1',
      title: 'Test Event',
      location: 'Test Location',
      dateTime: DateTime(2025, 5, 5, 10, 0),
      description: 'This is a test event.',
      maxParticipants: 100,
      currentParticipants: RxInt(50).value,
      category: EventCategory.workshop,
      isPastEvent: true,
      imageUrl: 'assets/images/1.jpg',
      rating: RxDouble(4.5).value,
      totalRatings: RxInt(20).value,
      reviews: RxList([]),
    );

    await tester.pumpWidget(
      GetMaterialApp(
        home: PastEventDetailsPage(event: testEvent),
      ),
    );

    // Verificar que se muestra el mensaje de no hay reseñas
    expect(find.text('No hay reseñas aún'), findsOneWidget);
  });
}