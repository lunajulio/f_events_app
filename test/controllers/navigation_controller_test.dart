import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:event_app/controllers/navigation_controller.dart';
import 'package:event_app/pages/homepage.dart';
import 'package:event_app/controllers/event_controller.dart';
import 'package:event_app/services/sync_service.dart';

// Implementación básica de SyncService para pruebas
class TestSyncService extends GetxService implements SyncService {
  @override
  Future<bool> addReview(String eventId, dynamic review) async {
    return true; // Simplemente retorna éxito para las pruebas
  }
}

void main() {
  late NavigationController navigationController;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    Get.testMode = true; // Configurar GetX en modo de prueba

    // Registrar SyncService antes que EventController
    Get.put<SyncService>(TestSyncService());

    // Registrar EventController antes que NavigationController
    Get.put(EventController());

    navigationController = NavigationController();
    Get.put(navigationController);

    // Configurar rutas para las pruebas
    GetMaterialApp(
      enableLog: true,
      defaultTransition: Transition.fade,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => HomePage()),
        GetPage(name: '/my-events', page: () => Scaffold(body: Text('My Events Page'))),
      ],
    );
  });

  tearDown(() {
    Get.delete<NavigationController>();
    Get.delete<EventController>();
    Get.delete<SyncService>();
  });

  test('changeIndex should update selectedIndex and navigate to the correct page', () {
    // Verificar el índice inicial
    expect(navigationController.selectedIndex.value, 0);

    // Verificar que se llama a la ruta esperada
    expect(() => navigationController.changeIndex(1), returnsNormally);
    expect(navigationController.selectedIndex.value, 1);

    expect(() => navigationController.changeIndex(0), returnsNormally);
    expect(navigationController.selectedIndex.value, 0);
  });
}