import 'package:event_app/controllers/event_controller.dart';
import 'package:event_app/controllers/navigation_controller.dart';
import 'package:event_app/routes/app_routes.dart';
import 'package:event_app/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Hive
  await StorageService.init();
  
  // Inicializar formateo de fechas
  await initializeDateFormatting('es', null);
  
  // Configurar preferencias de UI
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  
  // Registrar controladores globales
  Get.put(NavigationController());
  Get.put(EventController());
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Event App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Poppins',
      ),
      initialRoute: AppRoutes.HOME,
      getPages: AppRoutes.pages
    );
  }
}