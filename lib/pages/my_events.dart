import 'package:event_app/controllers/navigation_controller.dart';
import 'package:event_app/widget/eventcard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/event_controller.dart';

class MyEventsPage extends StatelessWidget {

  final EventController controller = Get.find();
  final NavigationController navigationController = Get.find();

  MyEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Barra superior
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.notifications_outlined),
                    onPressed: () {},
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Título
              Text(
                'My Events',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),

              const SizedBox(height: 20),

              // Barra de búsqueda
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search event..',
                          prefixIcon: Icon(Icons.search),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.filter_list),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Filtros
              // Filtros
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('All', controller.currentFilter == 'All'),
                    _buildFilterChip('Upcoming', controller.currentFilter == 'Upcoming'),
                    _buildFilterChip('Past Events', controller.currentFilter == 'Past Events'),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Lista de eventos
              Expanded(
                child: Obx(() {
                  final filteredEvents = controller.filteredSubscribedEvents;
                  if (filteredEvents.isEmpty) {
                    return Center(
                      child: Text('No events found'),
                    );
                  }
                  return ListView.builder(
                    itemCount: filteredEvents.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: EventCard(
                          event: filteredEvents[index],
                          isMainCard: true,
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
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

  Widget _buildFilterChip(String label, bool isSelected) {
    return Obx(() => Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            color: controller.currentFilter == label ? Colors.white : Colors.black,
          ),
        ),
        selected: controller.currentFilter == label,
        onSelected: (bool selected) {
          if (selected) {
            controller.setFilter(label);
          }
        },
        backgroundColor: Colors.grey[200],
        selectedColor: Colors.purple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    ));
  }
}