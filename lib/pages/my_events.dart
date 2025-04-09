import 'package:event_app/controllers/navigation_controller.dart';
import 'package:event_app/widget/eventcard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/event_controller.dart';

class MyEventsPage extends StatelessWidget {
  final EventController controller = Get.find();
  final NavigationController navigationController = Get.find();
  
  // Controlador para el texto de búsqueda
  final TextEditingController searchController = TextEditingController();
  
  // Variable reactiva para el término de búsqueda
  final RxString searchTerm = ''.obs;

  MyEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth;
            final maxHeight = constraints.maxHeight;
            
            return Padding(
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

                  SizedBox(height: maxHeight * 0.02),

                  // Título
                  Text(
                    'My Events',
                    style: TextStyle(
                      fontSize: maxWidth * 0.07,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),

                  SizedBox(height: maxHeight * 0.02),

                  // Barra de búsqueda 
                  Container(
                    height: (maxHeight * 0.065).clamp(45.0, 60.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(maxWidth * 0.03),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            style: TextStyle(
                              fontSize: maxWidth * 0.04,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search events...',
                              hintStyle: TextStyle(
                                color: Colors.grey[400],
                                fontSize: maxWidth * 0.04,
                              ),
                              prefixIcon: Icon(
                                Icons.search, 
                                color: Colors.purple,
                                size: maxWidth * 0.05,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: maxWidth * 0.04, 
                                vertical: maxHeight * 0.02
                              ),
                              suffixIcon: Obx(() => searchTerm.value.isNotEmpty 
                                ? IconButton(
                                    icon: Icon(
                                      Icons.clear, 
                                      size: maxWidth * 0.05,
                                      color: Colors.grey[500],
                                    ),
                                    onPressed: () {
                                      searchController.clear();
                                      searchTerm.value = '';
                                    },
                                  )
                                : SizedBox.shrink(),
                              ),
                            ),
                            onSubmitted: (value) {
                              searchTerm.value = value.trim();
                            },
                            textInputAction: TextInputAction.search,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: maxHeight * 0.02),

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

                  // Muestra el término de búsqueda actual si existe
                  Obx(() => searchTerm.value.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.symmetric(vertical: maxHeight * 0.01),
                        child: Row(
                          children: [
                            Text(
                              'Searching for: ',
                              style: TextStyle(
                                fontSize: maxWidth * 0.035,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '"${searchTerm.value}"',
                              style: TextStyle(
                                fontSize: maxWidth * 0.035,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(height: maxHeight * 0.02),
                  ),

                  // Lista de eventos con búsqueda
                  Expanded(
                    child: Obx(() {
                      // Combinar filtros con búsqueda
                      final filteredEvents = _getFilteredEvents();
                      
                      if (filteredEvents.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.event_busy,
                                size: maxWidth * 0.15,
                                color: Colors.grey[400],
                              ),
                              SizedBox(height: maxHeight * 0.02),
                              Text(
                                searchTerm.value.isNotEmpty
                                    ? 'No events match your search'
                                    : 'You haven\'t subscribed to any events yet',
                                style: TextStyle(
                                  fontSize: maxWidth * 0.04,
                                  color: Colors.grey[600],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      }
                      
                      return ListView.builder(
                        itemCount: filteredEvents.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: maxHeight * 0.02),
                            child: SizedBox(
                              height: maxHeight * 0.25,
                              child: EventCard(
                                event: filteredEvents[index],
                                isMainCard: true,
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            );
          }
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

  // Método para filtrar eventos según la búsqueda y filtros actuales
  List<dynamic> _getFilteredEvents() {
    var events = controller.filteredSubscribedEvents;
    
    // Si no hay término de búsqueda, devolver los eventos filtrados normalmente
    if (searchTerm.value.isEmpty) {
      return events;
    }
    
    // Filtrar por coincidencia en título o descripción
    return events.where((event) {
      final title = event.title.toString().toLowerCase();
      final description = event.description.toString().toLowerCase();
      final search = searchTerm.value.toLowerCase();
      
      return title.contains(search) || description.contains(search);
    }).toList();
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
            searchController.clear();
            searchTerm.value = '';
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