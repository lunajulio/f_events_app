import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/app_routes.dart';
import 'controllers/event_controller.dart';
import 'pages/homepage.dart';
import 'controllers/navigation_controller.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();  
  await initializeDateFormatting('es');  
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {

    Get.put(EventController());
    Get.put(NavigationController());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Event App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/',
      getPages: AppRoutes.pages,
    );
  }
}