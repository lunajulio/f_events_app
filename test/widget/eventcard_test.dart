import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:event_app/widget/eventcard.dart';
import 'package:event_app/models/event.dart';
import 'package:event_app/models/event_category.dart';
import 'package:event_app/controllers/event_controller.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl_standalone.dart';

void main() {
  setUpAll(() async {
    // Initialize locale data for date formatting
    await initializeDateFormatting('es');
  });

  setUp(() {
    // Initialize the EventController before each test
    Get.put(EventController());
  });

  tearDown(() {
    // Remove the EventController after each test
    Get.delete<EventController>();
  });

  testWidgets('EventCard displays event details correctly', (WidgetTester tester) async {
    // Mock event data
    final event = Event(
      id: '1',
      title: 'Test Event',
      location: 'Test Location',
      dateTime: DateTime(2025, 5, 2, 10, 0),
      description: 'This is a test event.',
      maxParticipants: 100,
      category: EventCategory.conference,
      currentParticipants: 50,
      imageUrl: 'assets/images/1.jpg',
    );

    // Build the widget
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: EventCard(event: event),
        ),
      ),
    );

    // Verify the event title is displayed
    expect(find.text('Test Event'), findsOneWidget);

    // Verify the event location is displayed
    expect(find.text('Test Location'), findsOneWidget);

    // Verify the event date and time are displayed
    expect(find.text('2-may-2025 at 10:00'), findsOneWidget);
  });
}