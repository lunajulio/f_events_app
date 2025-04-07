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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('All', true),
                    _buildFilterChip('Upcoming', false),
                    _buildFilterChip('Past Events', false),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Lista de eventos
              Expanded(
                child: Obx(() {
                  if (controller.subscribedEvents.isEmpty) {
                    return Center(
                      child: Text('No events found'),
                    );
                  }
                  return ListView.builder(
                    itemCount: controller.subscribedEvents.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: EventCard(
                          event: controller.subscribedEvents[index],
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
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
        selected: isSelected,
        onSelected: (bool selected) {
          // Implementar la lógica de filtrado
        },
        backgroundColor: Colors.grey[200],
        selectedColor: Colors.purple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}