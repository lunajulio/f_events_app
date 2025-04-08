import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/event_controller.dart';
import '../widget/eventcard.dart';

class AllEventsPage extends StatelessWidget {
  final EventController controller = Get.find();
  
  // Controlador para el texto de búsqueda
  final TextEditingController searchController = TextEditingController();
  
  // Variable reactiva para el término de búsqueda
  final RxString searchTerm = ''.obs;

  AllEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtener las dimensiones de la pantalla
    final screenSize = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Calcular dimensiones responsive
            final maxWidth = constraints.maxWidth;
            final maxHeight = constraints.maxHeight;
            
            return Padding(
              padding: EdgeInsets.all(maxWidth * 0.04), // Padding responsivo
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Barra superior
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                        iconSize: maxWidth * 0.06, // Tamaño de icono responsivo
                      ),
                      Text(
                        'All Events',
                        style: TextStyle(
                          fontSize: maxWidth * 0.06, // Texto responsivo
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: maxHeight * 0.02),

                  // Barra de búsqueda mejorada
                  Container(
                    height: maxHeight * 0.06,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(maxWidth * 0.03),
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
                              hintText: 'Search event..',
                              hintStyle: TextStyle(
                                color: Colors.grey[600],
                                fontSize: maxWidth * 0.04,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                size: maxWidth * 0.05,
                                color: Colors.grey[600],
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: maxWidth * 0.02,
                                vertical: maxHeight * 0.015,
                              ),
                              isDense: true,
                              alignLabelWithHint: true,
                              suffixIcon: Obx(() => searchTerm.value.isNotEmpty 
                                ? IconButton(
                                    icon: Icon(Icons.clear, 
                                      size: maxWidth * 0.05,
                                      color: Colors.grey[600],
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
                  Container(
                    height: maxHeight * 0.05,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip('All', controller.currentFilter == 'All', maxWidth, maxHeight),
                          _buildFilterChip('Upcoming', controller.currentFilter == 'Upcoming', maxWidth, maxHeight),
                          _buildFilterChip('Past Events', controller.currentFilter == 'Past Events', maxWidth, maxHeight),
                        ],
                      ),
                    ),
                  ),

                  // Muestra el término de búsqueda si existe
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
                    : SizedBox(height: maxHeight * 0.01),
                  ),

                  // Lista de eventos filtrados por búsqueda
                  Expanded(
                    child: Obx(() {
                      final allEvents = controller.filteredAllEvents;
                      final filteredEvents = _searchFilterEvents(allEvents);
                      
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
                                    : 'No events found',
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
                              height: maxHeight * 0.25, // Altura responsiva para las tarjetas
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
          },
        ),
      ),
    );
  }

  // Método para filtrar eventos por término de búsqueda
  List<dynamic> _searchFilterEvents(List<dynamic> events) {
    // Si no hay término de búsqueda, devolver todos los eventos
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

  Widget _buildFilterChip(String label, bool isSelected, double maxWidth, double maxHeight) {
    return Obx(() => Padding(
      padding: EdgeInsets.only(right: maxWidth * 0.02),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            color: controller.currentFilter == label ? Colors.white : Colors.black,
            fontSize: maxWidth * 0.035, // Texto responsivo
          ),
        ),
        selected: controller.currentFilter == label,
        onSelected: (bool selected) {
          if (selected) {
            controller.setFilter(label);
            // Limpiamos la búsqueda al cambiar filtros para evitar confusión
            searchController.clear();
            searchTerm.value = '';
          }
        },
        backgroundColor: Colors.grey[200],
        selectedColor: Colors.purple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(maxWidth * 0.05),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: maxWidth * 0.03,
          vertical: maxHeight * 0.01,
        ),
      ),
    ));
  }
}