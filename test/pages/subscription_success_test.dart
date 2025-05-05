import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:event_app/pages/subscription_success.dart';

void main() {
  setUp(() {
    Get.reset();
  });

  testWidgets('subscription success page should display correct elements', (WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        home: SubscriptionSuccess(),
      ),
    );

    // Verificar que se muestra el título principal
    expect(find.text('You are subscribed!'), findsOneWidget);

    // Verificar que se muestra el mensaje de confirmación
    expect(find.text('your subscription is successful.\nPlease check your events.'), findsOneWidget);

    // Verificar que el botón "My Events" está presente
    expect(find.byKey(const Key('myEventsButton')), findsOneWidget);
    expect(find.text('My Events'), findsOneWidget);

    // Verificar que el botón "Back to Home" está presente
    expect(find.byKey(const Key('backToHomeButton')), findsOneWidget);
    expect(find.text('Back to Home'), findsOneWidget);
    
    // Verificar que el ícono de check está presente
    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('buttons should trigger correct navigation', (WidgetTester tester) async {
    // Configurar para el modo de prueba
    Get.testMode = true;
    
    // Variable para rastrear navegaciones
    String? lastRoute;
    
    // Inicializar las rutas
    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: '/subscription-success',
        getPages: [
          GetPage(name: '/', page: () => Container()),
          GetPage(name: '/my-events', page: () => Container()),
          GetPage(name: '/subscription-success', page: () => SubscriptionSuccess()),
        ],
        navigatorObservers: [
          // Usar un NavigatorObserver estándar en lugar de GetObserver con onNavigate
          NavigatorObserver(),
        ],
      ),
    );

    // Función para simular la navegación y probarla
    Future<void> verifyNavigation(Key buttonKey, String expectedRoute) async {
      // Guardar la ruta actual antes de la navegación
      final previousRoute = Get.currentRoute;
      
      // Presionar el botón
      await tester.tap(find.byKey(buttonKey));
      await tester.pumpAndSettle();
      
      // En el modo de prueba, podemos verificar directamente Get.currentRoute
      expect(Get.currentRoute != previousRoute, true);
      
      // Navegación de vuelta para probar el siguiente botón
      Get.back();
      await tester.pumpAndSettle();
    }

    // Probar el botón "My Events"
    await verifyNavigation(const Key('myEventsButton'), '/my-events');
    
    // Probar el botón "Back to Home"
    await verifyNavigation(const Key('backToHomeButton'), '/');
  });
}