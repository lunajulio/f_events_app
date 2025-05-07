import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/event.dart';
import '../../models/event_category.dart';
import '../../models/review.dart';
import 'i_remote_event_source.dart';

/// Implementación del servicio remoto para la gestión de eventos
class RemoteEventSource implements IRemoteEventSource {
  final http.Client httpClient;

  // Clave de contrato y URL base para la API
  final String contractKey = 'lab_uninorte';
  final String baseUrl = 'https://unidb.openlab.uninorte.edu.co';
  final String eventsTable = 'events';
  final String reviewsTable = 'reviews';

  RemoteEventSource({http.Client? client})
      : httpClient = client ?? http.Client();

  @override
  Future<List<Event>> getEvents() async {
    List<Event> events = [];
    
    try {
      var request = Uri.parse("$baseUrl/$contractKey/data/$eventsTable/all")
          .resolveUri(Uri(queryParameters: {
        "format": 'json',
      }));

      var response = await httpClient.get(request);

      if (response.statusCode == 200) {
        Map<String, dynamic> decodedJson = jsonDecode(response.body);
        final apiData = decodedJson['data'];
        
        print('Eventos obtenidos desde API: $apiData');
        
        if (apiData != null && apiData is List) {
          for (var item in apiData) {
            // Verificar si el elemento tiene la estructura esperada con entry_id y data
            if (item is Map<String, dynamic> && item.containsKey('data')) {
              // Extraer el objeto data que contiene la información real del evento
              final eventData = item['data'];

              // Caso especial: si data es una lista (array) de eventos
              if (eventData is List) {
                print('📝 Detectada lista de eventos en un solo item. Procesando ${eventData.length} eventos...');
                for (var subEvent in eventData) {
                  if (subEvent is Map<String, dynamic>) {
                    try {
                      // Si no tiene ID, usar entry_id del contenedor
                      if (!subEvent.containsKey('id') && item.containsKey('entry_id')) {
                        subEvent['id'] = '${item['entry_id']}_${events.length}';
                      }
                      Event event = _convertJsonToEvent(subEvent);
                      events.add(event);
                    } catch (e) {
                      print('Error al convertir evento en una lista: $e');
                    }
                  }
                }
              } 
              // Caso normal: data es un objeto individual (Map)
              else if (eventData is Map<String, dynamic>) {
                // Usar un ID predeterminado si no viene en los datos
                if (!eventData.containsKey('id') && item.containsKey('entry_id')) {
                  eventData['id'] = item['entry_id'].toString();
                }
                try {
                  Event event = _convertJsonToEvent(eventData);
                  events.add(event);
                } catch (e) {
                  print('Error al convertir evento individual: $e');
                }
              }
            }
          }
        }
        
        print('Procesados ${events.length} eventos del servidor.');
      } else {
        print('Error al obtener eventos: ${response.statusCode}');
        return Future.error('Error code ${response.statusCode}');
      }
    } catch (e) {
      print('Excepción al obtener eventos: $e');
      return Future.error('Error: $e');
    }

    return Future.value(events);
  }

  @override
  Future<bool> addEvent(Event event) async {
    print('Agregando evento a API: ${event.title}');
    
    try {
      // Prepara el evento para guardar (convierte valores reactivos)
      event.beforeSave();
      
      final response = await httpClient.post(
        Uri.parse("$baseUrl/$contractKey/data/store"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'table_name': eventsTable,
          'data': _convertEventToJson(event),
        }),
      );

      if (response.statusCode == 201) {
        print('Evento agregado correctamente: ${response.body}');
        return Future.value(true);
      } else {
        print('Error al agregar evento: ${response.statusCode}');
        print(response.body);
        return Future.value(false);
      }
    } catch (e) {
      print('Excepción al agregar evento: $e');
      return Future.value(false);
    }
  }

  @override
  Future<bool> updateEvent(Event event) async {
    print('Actualizando evento en API: ${event.id}');
    
    try {
      // Prepara el evento para guardar (convierte valores reactivos)
      event.beforeSave();
      
      final response = await httpClient.put(
        Uri.parse("$baseUrl/$contractKey/data/$eventsTable/update/${event.id}"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'data': _convertEventToJsonNoId(event),
        }),
      );

      if (response.statusCode == 200) {
        print('Evento actualizado correctamente');
        return Future.value(true);
      } else {
        print('Error al actualizar evento: ${response.statusCode}');
        return Future.value(false);
      }
    } catch (e) {
      print('Excepción al actualizar evento: $e');
      return Future.value(false);
    }
  }

  @override
  Future<bool> deleteEvent(Event event) async {
    print('Eliminando evento de API: ${event.id}');
    
    try {
      final response = await httpClient.delete(
        Uri.parse("$baseUrl/$contractKey/data/$eventsTable/delete/${event.id}"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      
      if (response.statusCode == 200) {
        print('Evento eliminado correctamente');
        return Future.value(true);
      } else {
        print('Error al eliminar evento: ${response.statusCode}');
        return Future.value(false);
      }
    } catch (e) {
      print('Excepción al eliminar evento: $e');
      return Future.value(false);
    }
  }

  @override
  Future<bool> addReview(String eventId, Review review) async {
    print('Añadiendo reseña al evento $eventId');
    
    try {
      // Convertir la reseña a formato JSON
      Map<String, dynamic> reviewJson = {
        'eventId': eventId,
        'rating': review.rating,
        'comment': review.comment,
        'createdAt': review.createdAt.toIso8601String(),
      };
      
      final response = await httpClient.post(
        Uri.parse("$baseUrl/$contractKey/data/store"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'table_name': reviewsTable,
          'data': reviewJson,
        }),
      );

      if (response.statusCode == 201) {
        print('Reseña añadida correctamente');
        
        // Actualizar el evento con la nueva reseña
        await _updateEventWithReview(eventId, review);
        
        return Future.value(true);
      } else {
        print('Error al añadir reseña: ${response.statusCode}');
        print(response.body);
        return Future.value(false);
      }
    } catch (e) {
      print('Excepción al añadir reseña: $e');
      return Future.value(false);
    }
  }

  // Método auxiliar para actualizar un evento con una nueva reseña
  Future<void> _updateEventWithReview(String eventId, Review review) async {
    // Obtener el evento actual
    var request = Uri.parse("$baseUrl/$contractKey/data/$eventsTable/find/$eventId")
        .resolveUri(Uri(queryParameters: {
      "format": 'json',
    }));

    var response = await httpClient.get(request);

    if (response.statusCode == 200) {
      Map<String, dynamic> decodedJson = jsonDecode(response.body);
      final eventJson = decodedJson['data'];
      if (eventJson != null) {
        Event event = _convertJsonToEvent(eventJson);
        
        // Añadir la reseña y actualizar rating
        event.reviews.add(review);
        double totalRating = 0;
        for (var r in event.reviews) {
          totalRating += r.rating;
        }
        event.rating.value = event.reviews.isEmpty ? 0 : totalRating / event.reviews.length;
        event.totalRatings = event.reviews.length;
        
        // Actualizar el evento en el servidor
        await updateEvent(event);
      }
    }
  }

  @override
  Future<List<Event>> getEventsByCategory(EventCategory category) async {
    try {
      List<Event> allEvents = await getEvents();
      return allEvents.where((event) => event.category == category).toList();
    } catch (e) {
      print('Error al filtrar eventos por categoría: $e');
      return [];
    }
  }

  @override
  Future<List<Event>> getPastEvents() async {
    try {
      List<Event> allEvents = await getEvents();
      DateTime now = DateTime.now();
      return allEvents.where((event) => event.dateTime.isBefore(now)).toList();
    } catch (e) {
      print('Error al obtener eventos pasados: $e');
      return [];
    }
  }

  @override
  Future<List<Event>> getUpcomingEvents() async {
    try {
      List<Event> allEvents = await getEvents();
      DateTime now = DateTime.now();
      return allEvents.where((event) => event.dateTime.isAfter(now)).toList();
    } catch (e) {
      print('Error al obtener eventos futuros: $e');
      return [];
    }
  }

  /// Elimina todos los eventos del servidor
  Future<bool> deleteAllEvents() async {
    print('🗑️ Eliminando todos los eventos del servidor...');
    bool success = true;
    
    try {
      // 1. Obtener todos los eventos
      var request = Uri.parse("$baseUrl/$contractKey/data/$eventsTable/all")
          .resolveUri(Uri(queryParameters: {
        "format": 'json',
      }));
      
      var response = await httpClient.get(request);
      
      if (response.statusCode == 200) {
        Map<String, dynamic> decodedJson = jsonDecode(response.body);
        final apiData = decodedJson['data'];
        
        if (apiData != null && apiData is List) {
          print('📋 Encontrados ${apiData.length} registros para eliminar.');
          
          // 2. Eliminar cada registro usando su entry_id directamente
          for (var item in apiData) {
            if (item is Map<String, dynamic> && item.containsKey('entry_id')) {
              final entryId = item['entry_id'].toString();
              String title = "desconocido";
              
              if (item.containsKey('data') && item['data'] is Map<String, dynamic> && 
                  item['data'].containsKey('title')) {
                title = item['data']['title'];
              }
              
              // URL correcta para la API - incluyendo el nombre de la tabla
              final deleteUrl = Uri.parse("$baseUrl/$contractKey/data/$eventsTable/delete/$entryId");
              print('🔄 Intentando eliminar: $title (entry_id: $entryId)');
              print('🔗 URL: $deleteUrl');
              
              final deleteResponse = await httpClient.delete(
                deleteUrl,
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
              );
              
              if (deleteResponse.statusCode == 200) {
                print('✅ Registro eliminado: $title (entry_id: $entryId)');
              } else {
                print('❌ Error al eliminar: $title (entry_id: $entryId) - Código: ${deleteResponse.statusCode}');
                print('📄 Respuesta: ${deleteResponse.body}');
                success = false;
              }
              
              // Pequeña pausa para no sobrecargar el servidor
              await Future.delayed(const Duration(milliseconds: 200));
            }
          }
        } else {
          print('❓ No se encontraron datos para eliminar o formato inesperado.');
          return false;
        }
      } else {
        print('❌ Error al obtener registros: ${response.statusCode}');
        return false;
      }
      
      print('🧹 Proceso de eliminación completo. ${success ? "Éxito" : "Con errores"}');
      return success;
    } catch (e) {
      print('❌ Error general al eliminar registros: $e');
      return false;
    }
  }

  // Métodos auxiliares para conversión entre Event y JSON

  /// Convierte un objeto JSON a un objeto Event
  Event _convertJsonToEvent(Map<String, dynamic> json) {
    try {
      // Convertir reviews de JSON a objetos Review
      List<Review> reviews = [];
      if (json['reviews'] != null) {
        // Verificar que reviews sea una lista
        if (json['reviews'] is List) {
          reviews = List<Review>.from((json['reviews'] as List).map(
            (x) => Review(
              rating: (x['rating'] is int) ? x['rating'].toDouble() : x['rating'],
              comment: x['comment'],
              createdAt: DateTime.parse(x['createdAt']),
            )
          ));
        } else {
          print('⚠️ Campo reviews no es una lista: ${json['reviews']}');
        }
      }

      // Crear el evento con los valores del JSON
      Event event = Event(
        id: json['id'] ?? '',
        title: json['title'] ?? '',
        location: json['location'] ?? '',
        dateTime: json['dateTime'] != null ? DateTime.parse(json['dateTime']) : DateTime.now(),
        description: json['description'] ?? '',
        maxParticipants: json['maxParticipants'] ?? 0,
        currentParticipants: json['currentParticipants'] ?? 0,
        category: _parseEventCategory(json['category']),
        isPastEvent: json['isPastEvent'] ?? false,
        imageUrl: json['imageUrl'] ?? 'assets/images/1.jpg',
        rating: json['rating'] != null ? (json['rating'] is int ? json['rating'].toDouble() : json['rating']) : 0.0,
        totalRatings: json['totalRatings'] ?? 0,
        reviews: reviews,
      );

      // Inicializar propiedades reactivas si es necesario
      event.afterLoad();
      return event;
    } catch (e) {
      print('Error al convertir JSON a Event: $e');
      throw Exception('Error parsing Event from JSON: $e');
    }
  }

  /// Convierte un objeto EventCategory a string
  String _eventCategoryToString(EventCategory category) {
    switch (category) {
      case EventCategory.conference:
        return 'conference';
      case EventCategory.workshop:
        return 'workshop';
      case EventCategory.course:
        return 'course';
      case EventCategory.investigation:
        return 'investigation';
      default:
        return 'conference';
    }
  }

  /// Convierte un string a objeto EventCategory
  EventCategory _parseEventCategory(String? categoryStr) {
    if (categoryStr == null) return EventCategory.conference;
    
    switch (categoryStr.toLowerCase()) {
      case 'workshop':
        return EventCategory.workshop;
      case 'course':
        return EventCategory.course;
      case 'investigation':
        return EventCategory.investigation;
      case 'conference':
      default:
        return EventCategory.conference;
    }
  }

  /// Convierte un objeto Event a JSON
  Map<String, dynamic> _convertEventToJson(Event event) {
    List<Map<String, dynamic>> reviewsJson = event.reviews.map((review) => {
      'rating': review.rating,
      'comment': review.comment,
      'createdAt': review.createdAt.toIso8601String(),
    }).toList();

    return {
      'id': event.id,
      'title': event.title,
      'location': event.location,
      'dateTime': event.dateTime.toIso8601String(),
      'description': event.description,
      'maxParticipants': event.maxParticipants,
      'currentParticipants': event.currentParticipants.value,
      'category': _eventCategoryToString(event.category),
      'isPastEvent': event.isPastEvent,
      'imageUrl': event.imageUrl,
      'rating': event.rating.value,
      'totalRatings': event.totalRatings,
      'reviews': reviewsJson,
    };
  }

  /// Convierte un objeto Event a JSON sin incluir el ID
  Map<String, dynamic> _convertEventToJsonNoId(Event event) {
    var json = _convertEventToJson(event);
    json.remove('id');
    return json;
  }
}