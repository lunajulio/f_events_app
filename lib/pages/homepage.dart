import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/event_controller.dart';
import '../widget/eventcard.dart';
import '../controllers/navigation_controller.dart';

class HomePage extends StatelessWidget {
  final EventController controller = Get.find();
  final NavigationController navigationController = Get.find();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Find your next event.',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple[800],
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.search, color: Colors.grey),
                          hintText: 'Search event..',
                          border: InputBorder.none,
                          suffixIcon: Icon(Icons.tune, color: Colors.grey),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          FilterChip(
                            label: Text('All Event'),
                            selected: true,
                            onSelected: (_) {},
                            backgroundColor: Colors.black,
                            selectedColor: Colors.black,
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          SizedBox(width: 8),
                          FilterChip(
                            label: Text('Theater'),
                            selected: false,
                            onSelected: (_) {},
                            backgroundColor: Colors.grey[200],
                          ),
                          SizedBox(width: 8),
                          FilterChip(
                            label: Text('Music'),
                            selected: false,
                            onSelected: (_) {},
                            backgroundColor: Colors.grey[200],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Eventos destacados
            SliverToBoxAdapter(
              child: SizedBox(
                height: 200,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: ClampingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  children: controller.featuredEvents.map((event) => 
                    Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: EventCard(
                          event: event,
                          isMainCard: true,
                        ),
                      ),
                    ),
                  ).toList(),
                ),
              ),
            ),
            // Events For You
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Events For You',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Get.toNamed('/all-events'),
                      child: Text('See all'),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 160,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: ClampingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  children: controller.recommendedEvents.map((event) => 
                    Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: EventCard(
                          event: event,
                        ),
                      ),
                    ),
                  ).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: GetX<NavigationController>(
        builder: (controller) => BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeIndex,
          selectedItemColor: Colors.purple,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'My Events',
            ),
          ],
        ),
      ),
    );
  }
}