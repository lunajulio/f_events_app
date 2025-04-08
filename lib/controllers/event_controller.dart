import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/event.dart';
import '../data/eventlist.dart';
import '../models/review.dart';

class EventController extends GetxController {
  // Variables observables
  final _allEvents = <Event>[].obs;
  final _subscribedEvents = <Event>[].obs;
  final _subscribedEventIds = <String>{}.obs;
  final _featuredEvents = <Event>[].obs;
  final _recommendedEvents = <Event>[].obs;
  final _currentFilter = 'All'.obs;
  final _searchResults = <Event>[].obs;
  final _searchQuery = ''.obs;

  // Getters
  List<Event> get allEvents => _allEvents;
  List<Event> get subscribedEvents => _subscribedEvents;
  Set<String> get subscribedEventIds => _subscribedEventIds;
  List<Event> get featuredEvents => _featuredEvents;
  List<Event> get recommendedEvents => _recommendedEvents;
  String get currentFilter => _currentFilter.value;
  List<Event> get searchResults => _searchResults;
  String get searchQuery => _searchQuery.value;

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

  @override
  void onInit() {
    super.onInit();
    loadEvents();
    loadFeaturedEvents();
    loadRecommendedEvents();
  }

  void loadEvents() {
    _allEvents.value = EventsList;
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
    if (!event.isFull) {
      event.currentParticipants++;
      _subscribedEvents.add(event);
      _subscribedEventIds.add(event.id);
      update();
    }
  }

  void _unsubscribeFromEvent(Event event) {
    event.currentParticipants--;
    _subscribedEvents.removeWhere((e) => e.id == event.id);
    _subscribedEventIds.remove(event.id);
    update();
  }

  void loadFeaturedEvents() {
    _featuredEvents.assignAll(
      EventsList.where((event) => !event.isPastEvent).toList()
    );
  }

  void loadRecommendedEvents() {
    _recommendedEvents.assignAll(
      EventsList.where((event) => event.rating >= 4.5).toList()
    );
  }

  // Método para cambiar el filtro
  void setFilter(String filter) {
    _currentFilter.value = filter;
    update();
  }

  // Método para filtrar eventos
  void filterEvents(String filter) {
    switch(filter) {
      case 'All Event':
        loadFeaturedEvents();
        loadRecommendedEvents();
        break;
      case 'Theater':
        // Implementar filtrado por teatro si se agrega la categoría
        break;
      case 'Music':
        // Implementar filtrado por música si se agrega la categoría
        break;
      default:
        loadFeaturedEvents();
        loadRecommendedEvents();
    }
  }

  void addReview(Event event, double rating, String comment) {
    final review = Review(
      rating: rating,
      comment: comment,
      createdAt: DateTime.now()
    );
    
    event.reviews.add(review);
    
    double totalRating = event.reviews.fold(0.0, (sum, review) => sum + review.rating);
    event.rating.value = (totalRating / event.reviews.length);
    
    event.totalRatings++;
    
    // Actualizar la UI
    update();
    
    // Mostrar un snackbar de confirmación
    Get.snackbar(
      'Éxito',
      'Tu reseña ha sido agregada',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
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
}