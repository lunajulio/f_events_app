import 'package:get/get.dart';
import '../models/event.dart';
import '../data/eventlist.dart';

class EventController extends GetxController {
  // Listas existentes
  final _allEvents = <Event>[].obs;
  final _subscribedEvents = <Event>[].obs;
  final _subscribedEventIds = <String>{}.obs;

  // Nuevas listas para la homepage
  final _featuredEvents = <Event>[].obs;
  final _recommendedEvents = <Event>[].obs;

  // Getters existentes
  List<Event> get allEvents => _allEvents;
  List<Event> get subscribedEvents => _subscribedEvents;
  Set<String> get subscribedEventIds => _subscribedEventIds;

  // Nuevos getters
  List<Event> get featuredEvents => _featuredEvents;
  List<Event> get recommendedEvents => _recommendedEvents;

  @override
  void onInit() {
    super.onInit();
    loadEvents();
    loadFeaturedEvents();
    loadRecommendedEvents();
  }

  // Métodos existentes
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

  // Nuevos métodos para la homepage
  void loadFeaturedEvents() {
    // Carga eventos destacados (no pasados)
    _featuredEvents.assignAll(
      EventsList.where((event) => !event.isPastEvent).toList()
    );
  }

  void loadRecommendedEvents() {
    // Para eventos recomendados podemos usar una lógica diferente
    // Por ejemplo, eventos con mejor rating
    _recommendedEvents.assignAll(
      EventsList.where((event) => event.rating >= 4.5).toList()
    );
  }

  // Método para filtrar eventos
  void filterEvents(String filter) {
    switch(filter) {
      case 'All Event':
        loadFeaturedEvents();
        loadRecommendedEvents();
        break;
      case 'Theater':
        // Aquí puedes agregar lógica específica para filtrar eventos de teatro
        // Por ejemplo, si agregas una propiedad 'category' al modelo Event
        break;
      case 'Music':
        // Aquí puedes agregar lógica específica para filtrar eventos de música
        break;
      default:
        loadFeaturedEvents();
        loadRecommendedEvents();
    }
  }

  // Método para buscar eventos
  void searchEvents(String query) {
    if (query.isEmpty) {
      loadFeaturedEvents();
      loadRecommendedEvents();
      return;
    }

    final searchLower = query.toLowerCase();

    // Filtrar eventos destacados
    final filteredFeatured = EventsList.where((event) =>
      !event.isPastEvent &&
      (event.title.toLowerCase().contains(searchLower) ||
      event.location.toLowerCase().contains(searchLower))
    ).toList();

    // Filtrar eventos recomendados
    final filteredRecommended = EventsList.where((event) =>
      event.rating >= 4.5 &&
      (event.title.toLowerCase().contains(searchLower) ||
      event.location.toLowerCase().contains(searchLower))
    ).toList();

    _featuredEvents.assignAll(filteredFeatured);
    _recommendedEvents.assignAll(filteredRecommended);
  }
}