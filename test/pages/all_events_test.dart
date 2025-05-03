import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:event_app/pages/all_events.dart';
import 'package:event_app/controllers/event_controller.dart';
import 'package:event_app/models/event.dart';
import 'package:event_app/models/event_category.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  group('AllEventsPage', () {
    late EventController controller;

    setUp(() async {
      // Inicializar localización para formateo de fechas
      await initializeDateFormatting('es');

      // Registrar un EventController con eventos simples y todos los atributos requeridos
      controller = Get.put(EventController());
      controller.allEvents.clear();
      controller.allEvents.addAll([
        Event(
          id: '1',
          title: 'Evento Futuro',
          description: 'Un evento que ocurrirá',
          dateTime: DateTime(2025, 6, 1),
          isPastEvent: false,
          location: 'CDMX',
          maxParticipants: 100,
          currentParticipants: 10,
          category: EventCategory.conference,
          imageUrl: 'assets/images/1.jpg',
          rating: 4.0,
          totalRatings: 1,
          reviews: const [],
        ),
        Event(
          id: '2',
          title: 'Evento Pasado',
          description: 'Un evento que ya pasó',
          dateTime: DateTime(2024, 1, 1),
          isPastEvent: true,
          location: 'GDL',
          maxParticipants: 50,
          currentParticipants: 5,
          category: EventCategory.workshop,
          imageUrl: 'assets/images/2.jpg',
          rating: 3.0,
          totalRatings: 1,
          reviews: const [],
        ),
      ]);
      controller.setFilter('All');
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('Renderiza la página y muestra eventos', (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: AllEventsPage(),
        ),
      );
      expect(find.text('All Events'), findsOneWidget);
      expect(find.text('Evento Futuro'), findsOneWidget);
      expect(find.text('Evento Pasado'), findsOneWidget);
    });

    testWidgets('Filtra eventos por Upcoming', (WidgetTester tester) async {
      await tester.pumpWidget(GetMaterialApp(home: AllEventsPage()));
      await tester.tap(find.text('Upcoming'));
      await tester.pumpAndSettle();
      expect(find.text('Evento Futuro'), findsOneWidget);
      expect(find.text('Evento Pasado'), findsNothing);
    });

    testWidgets('Filtra eventos por Past Events', (WidgetTester tester) async {
      await tester.pumpWidget(GetMaterialApp(home: AllEventsPage()));
      await tester.tap(find.text('Past Events'));
      await tester.pumpAndSettle();
      expect(find.text('Evento Futuro'), findsNothing);
      expect(find.text('Evento Pasado'), findsOneWidget);
    });

    testWidgets('Busca eventos por texto', (WidgetTester tester) async {
      await tester.pumpWidget(GetMaterialApp(home: AllEventsPage()));
      await tester.enterText(find.byType(TextField), 'Futuro');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();
      expect(find.text('Evento Futuro'), findsOneWidget);
      expect(find.text('Evento Pasado'), findsNothing);
    });
  });
}
