import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:event_app/pages/homepage.dart';
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

  testWidgets('should display header and categories', (WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        home: HomePage(),
      ),
    );

    // Verificar que el encabezado se muestra
    expect(find.text('Your event journey starts here!'), findsOneWidget);
    expect(find.text('Discover events that match your interests'), findsOneWidget);

    // Verificar que las categorías se muestran
    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('All Event'), findsOneWidget);
    expect(find.text('Conference'), findsOneWidget);
    expect(find.text('Workshop'), findsOneWidget);
  });

  testWidgets('should scroll to see more content', (WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        home: HomePage(),
      ),
    );

    // Desplazarse hacia abajo en el primer Scrollable
    final scrollableFinder = find.byType(Scrollable).first;
    await tester.drag(scrollableFinder, const Offset(0, -300));
    await tester.pumpAndSettle();

    // Verificar que los eventos recomendados se muestran después del scroll
    expect(find.text('Events For You'), findsOneWidget);
    expect(find.text('Past Events'), findsOneWidget);
  });
}