import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'homepage.dart';
import 'all_events.dart';
import 'my_events.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainPageController>(
      init: MainPageController(),
      builder: (controller) {
        return Scaffold(
          body: IndexedStack(
            index: controller.currentIndex,
            children: [
              HomePage(),
              AllEventsPage(),
              MyEventsPage(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: controller.currentIndex,
            onTap: controller.changePage,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.event),
                label: 'All Events',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.star),
                label: 'My Events',
              ),
            ],
          ),
        );
      },
    );
  }
}

class MainPageController extends GetxController {
  var currentIndex = 0;

  void changePage(int index) {
    currentIndex = index;
    update();
  }
}