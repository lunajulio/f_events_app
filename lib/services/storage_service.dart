import 'package:hive_flutter/hive_flutter.dart';
import 'package:event_app/models/event.dart';
import 'package:event_app/models/event_category.dart';
import 'package:event_app/models/review.dart';

class StorageService {
  static const String subscribedEventsBox = 'subscribed_events';
  static const String eventsBox = 'events';
  
  // Inicializar Hive
  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Registrar adaptadores - Nota: estos adaptadores son generados automáticamente
    if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(EventAdapter());
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(ReviewAdapter());
    if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(EventCategoryAdapter());
    
    // Abrir boxes
    await Hive.openBox<Event>(eventsBox);
    await Hive.openBox<String>(subscribedEventsBox); // Almacenamos solo los IDs
  }
  
  // Guardar todos los eventos
  static Future<void> saveAllEvents(List<Event> events) async {
    final box = Hive.box<Event>(eventsBox);
    
    // Limpia los eventos existentes y añade los nuevos
    await box.clear();
    for (var event in events) {
      // Preparar el evento para guardar
      event.beforeSave();
      await box.put(event.id, event);
    }
  }
  
  // Obtener todos los eventos
  static List<Event> getAllEvents() {
    final box = Hive.box<Event>(eventsBox);
    final events = box.values.toList();
    
    // Restaurar las propiedades reactivas después de cargar
    for (var event in events) {
      event.afterLoad();
    }
    
    return events;
  }
  
  // Guardar un evento individual
  static Future<void> saveEvent(Event event) async {
    final box = Hive.box<Event>(eventsBox);
    // Preparar el evento para guardar
    event.beforeSave();
    await box.put(event.id, event);
  }
  
  // Obtener un evento por id
  static Event? getEvent(String id) {
    final box = Hive.box<Event>(eventsBox);
    final event = box.get(id);
    
    if (event != null) {
      // Restaurar las propiedades reactivas después de cargar
      event.afterLoad();
    }
    
    return event;
  }
  
  // Guardar ID de evento como suscrito
  static Future<void> saveSubscription(String eventId) async {
    final box = Hive.box<String>(subscribedEventsBox);
    await box.add(eventId);
  }
  
  // Eliminar suscripción
  static Future<void> removeSubscription(String eventId) async {
    final box = Hive.box<String>(subscribedEventsBox);
    
    // Encontrar todas las entradas que coincidan con el eventId
    final entries = box.values.toList();
    final keys = box.keys.toList();
    
    // Iterar en orden inverso para evitar problemas con índices cambiantes
    for (int i = entries.length - 1; i >= 0; i--) {
      if (entries[i] == eventId) {
        await box.delete(keys[i]);
      }
    }
  }
  
  // Verificar si un evento está suscrito
  static bool isEventSubscribed(String eventId) {
    try {
      final box = Hive.box<String>(subscribedEventsBox);
      final ids = box.values.toList();
      return ids.any((id) => id == eventId);
    } catch (e) {
      print('Error al verificar suscripción: $e');
      return false;
    }
  }
  
  // Obtener todos los IDs de eventos suscritos
  static List<String> getAllSubscribedEventIds() {
    final box = Hive.box<String>(subscribedEventsBox);
    return box.values.toList();
  }
  
  // Obtener todos los eventos suscritos
  static List<Event> getAllSubscribedEvents() {
    final subscribedIds = getAllSubscribedEventIds();
    final eventBox = Hive.box<Event>(eventsBox);
    
    List<Event> subscribedEvents = [];
    for (var id in subscribedIds) {
      final event = eventBox.get(id);
      if (event != null) {
        // Restaurar las propiedades reactivas después de cargar
        event.afterLoad();
        subscribedEvents.add(event);
      }
    }
    
    return subscribedEvents;
  }
  
  // Añadir reseña a un evento
  static Future<void> addReviewToEvent(String eventId, Review review) async {
    final box = Hive.box<Event>(eventsBox);
    final event = box.get(eventId);
    
    if (event != null) {
      // Restaurar las propiedades reactivas
      event.afterLoad();
      
      // Añadir reseña y actualizar calificación
      event.reviews.add(review);
      
      // Actualizar calificación
      double totalRating = 0;
      for (var r in event.reviews) {
        totalRating += r.rating;
      }
      
      event.rating.value = event.reviews.isEmpty ? 0 : totalRating / event.reviews.length;
      event.totalRatings = event.reviews.length;
      
      // Preparar para guardar
      event.beforeSave();
      await box.put(eventId, event);
    }
  }
}