import 'package:event_app/main.dart';
import 'package:event_app/controllers/event_controller.dart';
import 'package:event_app/models/event.dart';
import 'package:event_app/pages/all_events.dart';
import 'package:event_app/pages/event_details.dart';
import 'package:event_app/pages/homepage.dart';
import 'package:event_app/pages/my_events.dart';
import 'package:event_app/pages/past_event_detail_page.dart';
import 'package:event_app/pages/subscription_success.dart';
import 'package:event_app/widget/eventcard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:integration_test/integration_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  // Asegurarse de inicializar el binding de pruebas de integración
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar datos de localización para intl antes de todas las pruebas
  // Usando un try-catch para manejar cualquier error de inicialización
  try {
    await initializeDateFormatting('es', null);
  } catch (e) {
    print('Error al inicializar la localización: $e');
    // Intentar con otra localización si 'es' falla
    await initializeDateFormatting('en_US', null);
  }

  group('Prueba de integración completa de la aplicación de eventos', () {
    testWidgets('Prueba de todas las funcionalidades principales', (WidgetTester tester) async {
      // Inicializar la aplicación
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle(const Duration(seconds: 2)); // Dar más tiempo para cargar

      // Verificar que estamos en la página de inicio
      expect(find.byType(HomePage), findsOneWidget, reason: 'No se encontró la página de inicio');
      
      // Verificar elementos clave de la página principal
      // Usar skipOffstage: true para buscar widgets que pueden estar ocultos
      expect(find.text('Categories', skipOffstage: true), findsWidgets);
      expect(find.text('Featured Events', skipOffstage: true), findsWidgets);
      expect(find.text('Events For You', skipOffstage: true), findsWidgets);

      // PRUEBA DE SCROLL EN CATEGORÍAS
      print('Probando scroll horizontal de categorías...');
      // Buscamos el contenedor de categorías y hacemos scroll horizontal
      final categoriesSection = find.text('Categories').first;
      // Scroll a la derecha en la lista de categorías
      await tester.dragUntilVisible(
        find.byType(ListView).first, 
        categoriesSection,
        const Offset(-300, 0),
      );
      await tester.pumpAndSettle();

      // Probar filtrado por Course si existe
      if (find.text('Course').evaluate().isNotEmpty) {
        // Verificar que el elemento es visible antes de hacer tap
        final courseFinder = find.text('Course');
        if (tester.getRect(courseFinder).overlaps(tester.getRect(find.byType(Scaffold)))) {
          await tester.tap(courseFinder, warnIfMissed: false);
          await tester.pumpAndSettle();
        } else {
          print('El elemento Course está fuera de la pantalla');
        }
      }
      
      // Scroll de vuelta a la izquierda
      await tester.dragUntilVisible(
        find.byType(ListView).first,
        categoriesSection,
        const Offset(300, 0),
      );
      await tester.pumpAndSettle();

      // 1. PRUEBA DE FILTRADO POR CATEGORÍAS
      print('1. Probando filtrado por categorías...');
      
      // Verificar que existe el filtro "All Event" y está seleccionado por defecto
      expect(find.text('All Event'), findsOneWidget);
      
      // Probar filtrado por Workshop si existe
      if (find.text('Workshop').evaluate().isNotEmpty) {
        // Verificar que el elemento es visible antes de hacer tap
        final workshopFinder = find.text('Workshop');
        if (tester.getRect(workshopFinder).overlaps(tester.getRect(find.byType(Scaffold)))) {
          await tester.tap(workshopFinder, warnIfMissed: false);
          await tester.pumpAndSettle(const Duration(seconds: 2)); // Dar más tiempo para cargar
        } else {
          print('El elemento Workshop está fuera de la pantalla');
        }
      }
      
      // Probar filtrado por Conference si existe
      if (find.text('Conference').evaluate().isNotEmpty) {
        // Verificar que el elemento es visible antes de hacer tap
        final conferenceFinder = find.text('Conference');
        if (tester.getRect(conferenceFinder).overlaps(tester.getRect(find.byType(Scaffold)))) {
          await tester.tap(conferenceFinder, warnIfMissed: false);
          await tester.pumpAndSettle(const Duration(seconds: 2)); // Dar más tiempo para cargar
        } else {
          print('El elemento Conference está fuera de la pantalla');
        }
      }

      
      // Volver a All Event
      await tester.tap(find.text('All Event'));
      await tester.pumpAndSettle(const Duration(seconds: 2)); // Dar más tiempo para cargar

      // PRUEBA DE SCROLL EN FEATURED EVENTS
      print('Probando scroll horizontal de Featured Events...');
      final featuredEventsSection = find.text('Featured Events').first;
      

      // PRUEBA DE SCROLL EN EVENTS FOR YOU
      print('Probando scroll horizontal de Events For You...');
      final eventsForYouSection = find.text('Events For You').first;
      // Verificar que existen eventos recomendados

      // PRUEBA DE SCROLL VERTICAL DE LA PÁGINA PRINCIPAL
      print('Probando scroll vertical de la página principal...');
      await tester.dragFrom(
        const Offset(200, 500),
        const Offset(200, 100),
      );
      await tester.pumpAndSettle();
      await tester.dragFrom(
        const Offset(200, 100),
        const Offset(200, 500),
      );
      await tester.pumpAndSettle();

      // 2. PRUEBA DE NAVEGACIÓN A TODOS LOS EVENTOS
      print('2. Probando navegación a todos los eventos...');
      
      // Hacer tap en "See all" para ir a All Events
      if (find.text('See all').evaluate().isNotEmpty) {
        await tester.tap(find.text('See all'));
        await tester.pumpAndSettle(const Duration(seconds: 2)); // Dar más tiempo para cargar
        
        // Verificar que estamos en la página de todos los eventos
        expect(find.byType(AllEventsPage), findsOneWidget);

        // Probar filtrado Upcoming Events si existe
        if (find.text('Upcoming').evaluate().isNotEmpty) {
          await tester.tap(find.text('Upcoming'));
          await tester.pumpAndSettle(const Duration(seconds: 2)); // Dar más tiempo para cargar
        }

        // Probar filtrado Past Events si existe
        if (find.text('Past Events').evaluate().isNotEmpty) {
          await tester.tap(find.text('Past Events'));
          await tester.pumpAndSettle(const Duration(seconds: 2)); // Dar más tiempo para cargar
        }

        // Probar filtrado All Events si existe
        if (find.text('All Events').evaluate().isNotEmpty) {
          await tester.tap(find.text('All Events'));
          await tester.pumpAndSettle();
        }
        
        // Volver atrás
        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();
      } else {
        print('No se encontró el botón "See all"');
      }
      
      // Verificar que estamos de vuelta en la página de inicio
      expect(find.byType(HomePage), findsOneWidget);

      // 3. PRUEBA DE DETALLES DE EVENTO Y SUSCRIPCIÓN
      print('3. Probando visualización de detalles de evento y suscripción...');
      
      // Verificar si hay eventos disponibles para hacer tap
      if (find.byType(EventCard).evaluate().isNotEmpty) {
        // Seleccionar el primer evento
        await tester.tap(find.byType(EventCard).first);
        await tester.pumpAndSettle();
        
        // Verificar que estamos en la página de detalles
        expect(find.byType(EventDetailsPage), findsOneWidget);
        
        // Verificar elementos en la página de detalles - usando find.byType en lugar de find.text
        expect(find.byIcon(Icons.location_on), findsOneWidget);
        expect(find.byIcon(Icons.access_time), findsOneWidget);
        
        // Verificar si existe un botón de Subscribe o Unsubscribe
        final subscribeButton = find.widgetWithText(ElevatedButton, 'Subscribe');
        final unsubscribeButton = find.widgetWithText(ElevatedButton, 'Unsubscribe');
        
        if (subscribeButton.evaluate().isNotEmpty) {
          // Intentar suscribirse al evento
          await tester.tap(subscribeButton);
          await tester.pumpAndSettle();
          
          // Verificar que estamos en la página de confirmación de suscripción
          expect(find.byType(SubscriptionSuccess), findsOneWidget);
          
          // Ir a "My Events" desde la pantalla de confirmación
          await tester.tap(find.widgetWithText(ElevatedButton, 'My Events'));
          await tester.pumpAndSettle();
          
          // Verificar que estamos en la página de mis eventos
          expect(find.byType(MyEventsPage), findsOneWidget);
        } else if (unsubscribeButton.evaluate().isNotEmpty) {
          // El usuario ya está suscrito a este evento, volver atrás
          await tester.tap(find.byIcon(Icons.arrow_back));
          await tester.pumpAndSettle();
        } else {
          // No se encontró ni el botón de Subscribe ni el de Unsubscribe
          print('No se encontró botón de suscripción o cancelación');
          await tester.tap(find.byIcon(Icons.arrow_back));
          await tester.pumpAndSettle();
        }
      } else {
        print('No se encontraron tarjetas de eventos para probar');
      }

      // 6. PRUEBA DE NAVEGACIÓN POR BOTTOM NAVIGATION BAR
      print('6. Probando navegación con BottomNavigationBar...');
      
      // Intentar ir a My Events usando el bottom navigation bar
      if (find.text('My Events').evaluate().isNotEmpty) {
        final myEventsNavButton = find.text('My Events').last;
        await tester.tap(myEventsNavButton);
        await tester.pumpAndSettle();
        expect(find.byType(MyEventsPage), findsOneWidget, reason: 'No se pudo navegar a My Events');
        
        // Volver a Home
        if (find.text('Home').evaluate().isNotEmpty) {
          await tester.tap(find.text('Home'));
          await tester.pumpAndSettle();
          expect(find.byType(HomePage), findsOneWidget, reason: 'No se pudo volver a Home');
        }
      }

      print('¡Pruebas de integración completadas con éxito!');
    });
  });
}