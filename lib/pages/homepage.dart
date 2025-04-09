import 'package:event_app/models/event_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/event_controller.dart';
import '../widget/eventcard.dart';
import '../controllers/navigation_controller.dart';

class HomePage extends StatelessWidget {
  final EventController controller = Get.find();
  final NavigationController navigationController = Get.find();
  
  // Variable reactiva para la categoría seleccionada
  final Rx<String> selectedCategory = 'All Event'.obs;
  final TextEditingController searchController = TextEditingController();
  final RxString searchTerm = ''.obs;
  final RxBool isSearchActive = false.obs;

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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth;
            final maxHeight = constraints.maxHeight;
            
            // Tamaños responsivos
            final sectionSpacing = (maxHeight * 0.025).clamp(15.0, 25.0);
            final featuredEventHeight = (maxHeight * 0.28).clamp(180.0, 220.0);
            final recommendedEventHeight = (maxHeight * 0.22).clamp(140.0, 180.0);

            return CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                // Cabecera con título y búsqueda
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(
                      maxWidth * 0.05, 
                      maxHeight * 0.02, 
                      maxWidth * 0.05, 
                      maxHeight * 0.01
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Título principal 
                        Text(
                          'Your event journey starts here!',
                          style: TextStyle(
                            fontSize: (maxWidth * 0.075).clamp(24.0, 34.0),
                            fontWeight: FontWeight.bold,
                            color: Colors.purple[800],
                            letterSpacing: -0.5,
                          ),
                        ),
                        
                        SizedBox(height: maxHeight * 0.01),
                        
                        Text(
                          'Discover events that match your interests',
                          style: TextStyle(
                            fontSize: (maxWidth * 0.04).clamp(14.0, 18.0),
                            color: Colors.grey[600],
                          ),
                        ),
                        
                        SizedBox(height: sectionSpacing * 0.7),
                      ],
                    ),
                  ),
                ),
                
                // Categorías centradas
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: maxWidth * 0.05),
                        child: Text(
                          'Categories',
                          style: TextStyle(
                            fontSize: (maxWidth * 0.045).clamp(16.0, 22.0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: maxHeight * 0.015),
                      Container(
                        height: (maxHeight * 0.055).clamp(35.0, 50.0),
                        alignment: Alignment.center,
                        child: Center(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.symmetric(horizontal: maxWidth * 0.05),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: _buildFilterChips(maxWidth, maxHeight),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: sectionSpacing * 0.6),
                    ],
                  ),
                ),

                
                // Featured Events 
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: maxWidth * 0.05,
                          right: maxWidth * 0.05,
                          bottom: maxHeight * 0.015,
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Featured Events',
                              style: TextStyle(
                                fontSize: (maxWidth * 0.055).clamp(18.0, 26.0),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8, 
                                vertical: 4
                              ),
                              decoration: BoxDecoration(
                                color: Colors.purple.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Popular',
                                style: TextStyle(
                                  fontSize: maxWidth * 0.03,
                                  color: Colors.purple,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Centrado con padding para el carrusel
                      Center(
                        child: SizedBox(
                          height: featuredEventHeight,
                          child: Obx(() {
                            final filteredEvents = _getFilteredEvents(controller.featuredEvents);
                            
                            if (filteredEvents.isEmpty) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.event_busy,
                                      size: maxWidth * 0.15,
                                      color: Colors.grey[300],
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'No featured events for this category',
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: maxWidth * 0.035,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            
                            return ListView(
                              scrollDirection: Axis.horizontal,
                              physics: BouncingScrollPhysics(),
                              padding: EdgeInsets.symmetric(horizontal: maxWidth * 0.05),
                              children: filteredEvents.map((event) => 
                                Padding(
                                  padding: EdgeInsets.only(right: maxWidth * 0.04),
                                  child: SizedBox(
                                    width: maxWidth * 0.75,
                                    child: EventCard(
                                      event: event,
                                      isMainCard: true,
                                    ),
                                  ),
                                ),
                              ).toList(),
                            );
                          }),
                        ),
                      ),
                      
                      SizedBox(height: sectionSpacing),
                    ],
                  ),
                ),
                
                // Events For You con título y "See all"
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: maxWidth * 0.05),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Events For You',
                              style: TextStyle(
                                fontSize: (maxWidth * 0.055).clamp(18.0, 26.0),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () => Get.toNamed('/all-events'),
                              child: Text(
                                'See all',
                                style: TextStyle(
                                  fontSize: (maxWidth * 0.04).clamp(14.0, 18.0),
                                  color: Colors.purple,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: maxHeight * 0.01),
                      
                      // Centrado con padding para el carrusel
                      Center(
                        child: SizedBox(
                          height: recommendedEventHeight,
                          child: Obx(() {
                            final filteredEvents = _getFilteredEvents(controller.recommendedEvents);
                            
                            if (filteredEvents.isEmpty) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.event_busy,
                                      size: maxWidth * 0.12,
                                      color: Colors.grey[300],
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'No recommended events for this category',
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: maxWidth * 0.035,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            
                            return ListView(
                              scrollDirection: Axis.horizontal,
                              physics: BouncingScrollPhysics(),
                              padding: EdgeInsets.symmetric(horizontal: maxWidth * 0.05),
                              children: filteredEvents.map((event) => 
                                Padding(
                                  padding: EdgeInsets.only(right: maxWidth * 0.04),
                                  child: SizedBox(
                                    width: maxWidth * 0.6,
                                    child: EventCard(
                                      event: event,
                                    ),
                                  ),
                                ),
                              ).toList(),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Padding final
                SliverPadding(
                  padding: EdgeInsets.only(bottom: maxHeight * 0.08),
                ),
              ],
            );
          },
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

  // Método para filtrar eventos según la categoría seleccionada
  List<dynamic> _getFilteredEvents(List<dynamic> events) {
    if (selectedCategory.value == 'All Event') {
      return events;
    }
    
    // Convertir string de categoría a EventCategory enum
    EventCategory? categoryFilter;
    switch (selectedCategory.value) {
      case 'Conference':
        categoryFilter = EventCategory.conference;
        break;
      case 'Workshop':
        categoryFilter = EventCategory.workshop;
        break;
      case 'Course':
        categoryFilter = EventCategory.course;
        break;
      case 'Investigation':
        categoryFilter = EventCategory.investigation;
        break;
    }
    
    // Filtrar eventos por categoría
    return events.where((event) => event.category == categoryFilter).toList();
  }

  List<Widget> _buildFilterChips(double maxWidth, double maxHeight) {
    final categories = [
      'All Event', 'Conference', 'Workshop', 'Course', 'Investigation'];
    
    return categories.map((category) {
      return Obx(() => Padding(
        padding: EdgeInsets.symmetric(horizontal: maxWidth * 0.015),
        child: FilterChip(
          label: Text(
            category,
            style: TextStyle(
              color: selectedCategory.value == category ? Colors.white : Colors.black,
              fontSize: (maxWidth * 0.035).clamp(12.0, 16.0),
              fontWeight: selectedCategory.value == category ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
          selected: selectedCategory.value == category,
          onSelected: (_) {
            selectedCategory.value = category;
          },
          backgroundColor: Colors.grey[200],
          selectedColor: Colors.purple,
          padding: EdgeInsets.symmetric(
            horizontal: (maxWidth * 0.025).clamp(8.0, 15.0),
            vertical: (maxHeight * 0.007).clamp(5.0, 10.0),
          ),
          elevation: 0,
          pressElevation: 2,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular((maxWidth * 0.05).clamp(15.0, 25.0)),
          ),
        ),
      ));
    }).toList();
  }
}