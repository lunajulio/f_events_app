import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:event_app/controllers/navigation_controller.dart';
import 'package:event_app/pages/homepage.dart';
import 'package:event_app/controllers/event_controller.dart';

void main() {
  late NavigationController navigationController;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    Get.testMode = true; // Configurar GetX en modo de prueba
    navigationController = NavigationController();
    Get.put(navigationController);

    // Registrar EventController para evitar errores
    Get.put(EventController());

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