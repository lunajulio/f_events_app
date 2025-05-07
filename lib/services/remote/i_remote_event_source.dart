import '../../models/event.dart';
import '../../models/event_category.dart';
import '../../models/review.dart';

/// Interfaz para gestionar las operaciones del servicio remoto de eventos
abstract class IRemoteEventSource {
  /// Obtiene todos los eventos desde el servidor
  Future<List<Event>> getEvents();

  /// Añade un evento al servidor
  Future<bool> addEvent(Event event);

  /// Actualiza un evento en el servidor
  Future<bool> updateEvent(Event event);

  /// Elimina un evento del servidor
  Future<bool> deleteEvent(Event event);

  /// Añade una reseña a un evento
  Future<bool> addReview(String eventId, Review review);

  /// Obtiene eventos por categoría
  Future<List<Event>> getEventsByCategory(EventCategory category);

  /// Obtiene eventos pasados
  Future<List<Event>> getPastEvents();

  /// Obtiene eventos próximos
  Future<List<Event>> getUpcomingEvents();
}