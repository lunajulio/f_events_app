import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/event.dart';
import '../data/eventlist.dart';
import '../models/review.dart';
import '../services/storage_service.dart';
import '../services/sync_service.dart'; // Importar el servicio de sincronización

class EventController extends GetxController {
  // Variables observables
  final RxList<Event> _allEvents = <Event>[].obs;
  final RxList<Event> _featuredEvents = <Event>[].obs;
  final RxList<Event> _recommendedEvents = <Event>[].obs;
  final RxList<Event> _subscribedEvents = <Event>[].obs;
  final RxSet<String> _subscribedEventIds = <String>{}.obs;
  final RxString _currentFilter = 'All'.obs;
  final RxList<Event> _searchResults = <Event>[].obs;
  final RxString _searchQuery = ''.obs;
  final RxString _selectedCategory = 'All Event'.obs;

  // Servicio de sincronización
  late SyncService _syncService;

  // Getters
  List<Event> get allEvents => _allEvents;
  List<Event> get featuredEvents => _featuredEvents;
  List<Event> get recommendedEvents => _recommendedEvents;
  List<Event> get subscribedEvents => _subscribedEvents;
  String get currentFilter => _currentFilter.value;
  List<Event> get searchResults => _searchResults;
  String get searchQuery => _searchQuery.value;
  String get selectedCategory => _selectedCategory.value;

  // Getters para eventos filtrados
  List<Event> get filteredAllEvents {
    switch (_currentFilter.value) {
      case 'Upcoming':
        return _allEvents.where((event) => !event.isPastEvent).toList();
      case 'Past Events':
        return _allEvents.where((event) => event.isPastEvent).toList();
      default:
        return _allEvents;
    }
  }

  List<Event> get filteredSubscribedEvents {
    switch (_currentFilter.value) {
      case 'Upcoming':
        return _subscribedEvents.where((event) => !event.isPastEvent).toList();
      case 'Past Events':
        return _subscribedEvents.where((event) => event.isPastEvent).toList();
      default:
        return _subscribedEvents;
    }
  }

  get searchTerm => null;

  List<dynamic> getPastEvents(List<dynamic> events) {
    final now = DateTime.now();
    return events.where((event) => event.dateTime.isBefore(now)).toList();
  }

  @override
  void onInit() {
    super.onInit();
    _syncService = Get.find<SyncService>();
    loadEvents();
    loadFeaturedEvents();
    loadRecommendedEvents();
    _loadSubscribedEvents();
  }

  void loadEvents() {
    // Intentar obtener eventos de Hive primero
    final storedEvents = StorageService.getAllEvents();
    
    if (storedEvents.isNotEmpty) {
      _allEvents.value = storedEvents;
      print('🔵 Eventos cargados desde HIVE: ${storedEvents.length} eventos');
    } else {
      // Si no hay eventos almacenados, usar la lista predefinida
      _allEvents.value = EventsList;
      // Y guardarlos en Hive para uso futuro
      StorageService.saveAllEvents(EventsList);
      print('🔴 Eventos cargados desde LISTA PREDEFINIDA: ${EventsList.length} eventos');
    }
  }

  void _loadSubscribedEvents() {
    // Cargar eventos suscritos de Hive
    final subscribedEvents = StorageService.getAllSubscribedEvents();
    _subscribedEvents.value = subscribedEvents;
    
    // Cargar IDs de eventos suscritos
    _subscribedEventIds.value = StorageService.getAllSubscribedEventIds().toSet();
    update();
  }

  bool isSubscribed(Event event) {
    return _subscribedEventIds.contains(event.id);
  }

  void toggleSubscription(Event event) {
    if (isSubscribed(event)) {
      _unsubscribeFromEvent(event);
    } else {
      _subscribeToEvent(event);
    }
  }

  void _subscribeToEvent(Event event) {
    if (event.currentParticipants.value < event.maxParticipants) {
      event.currentParticipants.value++;
      _subscribedEvents.add(event);
      _subscribedEventIds.add(event.id);
      
      // Guardar en Hive
      StorageService.saveSubscription(event.id);
      StorageService.saveEvent(event);
      
      update();
    } else {
      Get.snackbar(
        'Evento lleno',
        'Lo sentimos, este evento ya no tiene cupos disponibles',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _unsubscribeFromEvent(Event event) {
    event.currentParticipants.value--;
    _subscribedEvents.removeWhere((e) => e.id == event.id);
    _subscribedEventIds.remove(event.id);
    
    // Actualizar en Hive
    StorageService.removeSubscription(event.id);
    StorageService.saveEvent(event);
    
    update();
  }

  void loadFeaturedEvents() {
    // Usar los eventos ya cargados en memoria en lugar de EventsList directamente
    _featuredEvents.assignAll(
      _allEvents.where((event) => !event.isPastEvent).toList()
    );
  }

  void loadRecommendedEvents() {
    // Usar los eventos ya cargados en memoria en lugar de EventsList directamente
    _recommendedEvents.assignAll(
      _allEvents.where((event) => event.rating >= 4.5).toList()
    );
  }

  // Método para cambiar el filtro
  void setFilter(String filter) {
    _currentFilter.value = filter;
    update();
  }

  void addReview(Event event, double rating, String comment, {bool showSnackbar = true}) {
    final review = Review(
      rating: rating,
      comment: comment,
      createdAt: DateTime.now(),
    );

    try {
      // Añadir la reseña directamente al evento usando el nuevo método
      event.addReview(review);
      
      // Guardar en storage local
      StorageService.saveEvent(event);
      
      // Sincronizar con el servidor
      _syncService.addReview(event.id, review)
          .then((success) {
            if (!success) {
              print('⚠️ La reseña se guardó localmente pero falló la sincronización con el servidor');
            } else {
              print('✅ Reseña sincronizada correctamente con el servidor');
            }
          });
      
      // Actualizar la UI
      update();

      // Mostrar un snackbar de confirmación si está habilitado
      if (showSnackbar) {
        Get.snackbar(
          'Éxito',
          'Tu reseña ha sido agregada',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error al añadir reseña: $e');
      if (showSnackbar) {
        Get.snackbar(
          'Error',
          'No se pudo agregar tu reseña',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  void searchEvents(String query) {
    _searchQuery.value = query.trim();
    
    if (query.isEmpty) {
      _searchResults.clear();
      return;
    }

    try {
      final searchLower = query.toLowerCase();
      
      // Combinar eventos de ambas fuentes para la búsqueda
      final allSearchableEvents = <Event>[];
      allSearchableEvents.addAll(_featuredEvents);
      allSearchableEvents.addAll(_recommendedEvents);
      
      // Eliminar duplicados (si un evento está en ambas listas)
      final uniqueEvents = allSearchableEvents.toSet().toList();
      
      // Filtrar por término de búsqueda
      final filtered = uniqueEvents.where((event) {
        final title = event.title.toLowerCase();
        final description = event.description.toLowerCase();
        final location = event.location.toLowerCase();
        
        return title.contains(searchLower) || 
              description.contains(searchLower) ||
              location.contains(searchLower);
      }).toList();
      
      _searchResults.assignAll(filtered);
    } catch (e) {
      print('Error en la búsqueda: $e');
      _searchResults.clear();
    }
    update();
  }
  
  // Método para limpiar la búsqueda
  void clearSearch() {
    _searchQuery.value = '';
    _searchResults.clear();
    update();
  }

  // Método para recargar eventos desde el almacenamiento después de sincronización
  void refreshEvents() {
    // Cargar eventos actualizados desde Hive
    final storedEvents = StorageService.getAllEvents();
    
    // Actualizar la lista principal de eventos
    _allEvents.clear();
    _allEvents.addAll(storedEvents);
    
    // Actualizar listas derivadas
    loadFeaturedEvents();
    loadRecommendedEvents();
    _loadSubscribedEvents();
    
    // Notificar a las vistas que deben actualizarse
    update();
    
    print('♻️ Eventos recargados desde almacenamiento: ${_allEvents.length} eventos');
  }

  // Método para limpiar todos los eventos de Hive y actualizar las listas
  Future<void> clearAllEvents() async {
    // Limpiar eventos en Hive
    await StorageService.clearAllEvents();
    
    // Limpiar listas en memoria
    _allEvents.clear();
    _featuredEvents.clear();
    _recommendedEvents.clear();
    _subscribedEvents.clear();
    _subscribedEventIds.clear();
    
    // Notificar a todas las vistas
    update();
    
    print('🧹 Todos los eventos han sido eliminados.');
  }
}