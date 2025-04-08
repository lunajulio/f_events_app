import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/event_controller.dart';
import '../widget/eventcard.dart';

class AllEventsPage extends StatelessWidget {
  final EventController controller = Get.find();

  AllEventsPage({super.key});

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
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    'All Events',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Barra de búsqueda
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search event..',
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),

              SizedBox(height: 20),

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

              SizedBox(height: 20),

              // Lista de eventos
              Expanded(
                child: Obx(() {
                  final filteredEvents = controller.filteredAllEvents;
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