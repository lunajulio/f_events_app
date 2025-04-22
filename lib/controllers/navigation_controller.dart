// controllers/navigation_controller.dart
import 'package:event_app/pages/homepage.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
    
    // Navegar a la página correspondiente
    if (index == 0) {
      Get.to(HomePage());  // Home
    } else {
      Get.toNamed('/my-events');  // My Events
    }
  }
}