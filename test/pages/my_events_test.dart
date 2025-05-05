import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:event_app/pages/my_events.dart';
import 'package:event_app/controllers/event_controller.dart';
import 'package:event_app/controllers/navigation_controller.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('en_US', null);
  });

  setUp(() {
    Get.put(EventController());
    Get.put(NavigationController());
  });

  testWidgets('should display My Events title and search bar', (WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        home: MyEventsPage(),
      ),
    );

    // Verificar que el título principal se muestra utilizando un Key
    final titleFinder = find.byKey(const Key('myEventsTitle'));
    expect(titleFinder, findsOneWidget);

    // Verificar que la barra de búsqueda se muestra utilizando un Key
    final searchBarFinder = find.byKey(const Key('searchBar'));
    expect(searchBarFinder, findsOneWidget);
  });

  testWidgets('should display no events message when no events are available', (WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        home: MyEventsPage(),
      ),
    );

    // Verificar que se muestra el mensaje de no eventos utilizando un Key
    final noEventsMessageFinder = find.byKey(const Key('noEventsMessage'));
    expect(noEventsMessageFinder, findsOneWidget);
  });

  testWidgets('should scroll to see more events', (WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        home: MyEventsPage(),
      ),
    );

    // Desplazarse hacia abajo en el primer Scrollable
    final scrollableFinder = find.byType(Scrollable).first;
    await tester.drag(scrollableFinder, const Offset(0, -300));
    await tester.pumpAndSettle();

    // Verificar que el título principal sigue visible después del scroll
    final titleFinder = find.byKey(const Key('myEventsTitle'));
    expect(titleFinder, findsOneWidget);
  });
}