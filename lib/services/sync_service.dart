import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:event_app/controllers/event_controller.dart';
import 'package:get/get.dart';
import '../models/event.dart';
import '../models/review.dart';
import 'remote/remote_event_source.dart';
import 'storage_service.dart';

/// Servicio que gestiona la sincronización entre el almacenamiento local (Hive) y el remoto (API)
class SyncService {
  final RemoteEventSource _remoteSource;
  final RxBool _isSyncing = false.obs;
  final RxBool _isOnline = false.obs;
  Timer? _syncTimer;

  bool get isSyncing => _isSyncing.value;
  bool get isOnline => _isOnline.value;

  // Constructor con inyección de dependencias
  SyncService({RemoteEventSource? remoteSource}) 
      : _remoteSource = remoteSource ?? RemoteEventSource();

  /// Inicializa el servicio de sincronización y configura la monitorización de la conectividad
  Future<void> init() async {
    // Monitorizar cambios en la conectividad
    Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
    
    // Verificar la conectividad inicial
    await _checkConnectivity();
    
    // Iniciar sincronización automática periódica
    _startPeriodicSync();
  }

  /// Actualiza el estado de la conexión
  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    bool wasOnline = _isOnline.value;
    _isOnline.value = result != ConnectivityResult.none;
    
    // Si recuperamos conexión, intentar sincronizar
    if (!wasOnline && _isOnline.value) {
      print('🔄 Conexión restaurada, iniciando sincronización...');
      syncData();
    }
  }

  /// Comprueba el estado actual de la conectividad
  Future<void> _checkConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    _isOnline.value = result != ConnectivityResult.none;
    print('🌐 Estado de conexión: ${_isOnline.value ? "En línea" : "Sin conexión"}');
  }

  /// Inicia la sincronización periódica
  void _startPeriodicSync() {
    // Sincronizar cada 15 minutos
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(const Duration(minutes: 15), (timer) {
      syncData();
    });
  }

  /// Sincroniza datos entre el almacenamiento local y remoto
  Future<void> syncData() async {
    if (_isSyncing.value) {
      print('⚠️ Ya hay una sincronización en curso.');
      return;
    }
    
    if (!_isOnline.value) {
      print('⚠️ No hay conexión a internet. La sincronización se realizará cuando haya conexión.');
      return;
    }
    
    _isSyncing.value = true;
    print('🔄 Iniciando sincronización...');
    
    try {
      await _syncEvents();
      
      // Actualizar el controlador de eventos con la lista actualizada
      final eventController = Get.find<EventController>();
      if (eventController != null) {
        eventController.refreshEvents();
        print('🔄 Eventos actualizados en el controlador.');
      }
      
      print('✅ Sincronización completada exitosamente.');
    } catch (e) {
      print('❌ Error durante la sincronización: $e');
    } finally {
      _isSyncing.value = false;
    }
  }

  /// Verifica si hay eventos con el mismo título para evitar duplicados
  Future<void> _syncEvents() async {
    // 1. Obtener eventos del servidor
    print('📥 Obteniendo eventos del servidor...');
    List<Event> remoteEvents;
    try {
      remoteEvents = await _remoteSource.getEvents();
      print('📥 ${remoteEvents.length} eventos obtenidos del servidor.');
    } catch (e) {
      print('❌ Error al obtener eventos del servidor: $e');
      return;
    }
    
    // 2. Obtener eventos locales
    final localEvents = StorageService.getAllEvents();
    print('💾 ${localEvents.length} eventos encontrados localmente.');
    
    // 3. Crear mapas para detectar duplicados por título
    final Map<String, Event> remoteEventsByTitle = {};
    for (var event in remoteEvents) {
      remoteEventsByTitle[event.title] = event;
    }
    
    final Map<String, Event> localEventsByTitle = {};
    for (var event in localEvents) {
      localEventsByTitle[event.title] = event;
    }
    
    // 4. Detectar duplicados por ID
    final localEventIds = localEvents.map((e) => e.id).toSet();
    
    // 5. Detectar eventos de servidor que no están en local (por ID o título)
    final newRemoteEvents = remoteEvents.where((remoteEvent) => 
      !localEventIds.contains(remoteEvent.id) && 
      !localEventsByTitle.containsKey(remoteEvent.title)
    ).toList();
    
    // 6. Guardar nuevos eventos del servidor que no sean duplicados
    if (newRemoteEvents.isNotEmpty) {
      print('➕ Guardando ${newRemoteEvents.length} nuevos eventos del servidor localmente:');
      for (var event in newRemoteEvents) {
        print('   - ${event.id}: ${event.title}');
        await StorageService.saveEvent(event);
      }
    }
    
    // 7. Actualizar eventos existentes que coinciden por ID
    final commonEvents = remoteEvents.where((e) => localEventIds.contains(e.id)).toList();
    for (var remoteEvent in commonEvents) {
      final localEvent = localEvents.firstWhere((e) => e.id == remoteEvent.id);
      
      // Criterios para actualizar: más participantes, más reseñas, o calificación diferente
      if (remoteEvent.currentParticipants.value != localEvent.currentParticipants.value ||
          remoteEvent.reviews.length > localEvent.reviews.length ||
          remoteEvent.rating.value != localEvent.rating.value) {
        print('🔄 Actualizando evento local con datos del servidor: ${remoteEvent.id} - ${remoteEvent.title}');
        await StorageService.saveEvent(remoteEvent);
      }
    }
    
    // 8. Detectar eventos locales que no están en el servidor (por ID o título)
    final remoteEventIds = remoteEvents.map((e) => e.id).toSet();
    final newLocalEvents = localEvents.where((localEvent) => 
      !remoteEventIds.contains(localEvent.id) && 
      !remoteEventsByTitle.containsKey(localEvent.title)
    ).toList();
    
    // 9. Enviar nuevos eventos locales al servidor (que no tengan duplicados)
    if (newLocalEvents.isNotEmpty) {
      print('➕ Enviando ${newLocalEvents.length} eventos locales al servidor:');
      for (var event in newLocalEvents) {
        print('   - ${event.id}: ${event.title}');
        try {
          await _remoteSource.addEvent(event);
        } catch (e) {
          print('❌ Error al enviar evento local al servidor: $e');
        }
      }
    }
    
    // 10. Actualizar la lista local con todos los eventos sincronizados
    final updatedLocalEvents = StorageService.getAllEvents();
    print('✅ Sincronización completada. Total eventos locales: ${updatedLocalEvents.length}');
  }

  /// Añade un nuevo evento tanto localmente como en remoto
  Future<bool> addEvent(Event event) async {
    // Primero guardar localmente
    await StorageService.saveEvent(event);
    
    // Si hay conexión, enviar al servidor
    if (_isOnline.value) {
      try {
        bool success = await _remoteSource.addEvent(event);
        return success;
      } catch (e) {
        print('❌ Error al agregar evento al servidor: $e');
        return false;
      }
    }
    
    return true; // Éxito local
  }

  /// Actualiza un evento tanto localmente como en remoto
  Future<bool> updateEvent(Event event) async {
    // Primero actualizar localmente
    await StorageService.saveEvent(event);
    
    // Si hay conexión, actualizar en el servidor
    if (_isOnline.value) {
      try {
        bool success = await _remoteSource.updateEvent(event);
        return success;
      } catch (e) {
        print('❌ Error al actualizar evento en el servidor: $e');
        return false;
      }
    }
    
    return true; // Éxito local
  }

  /// Elimina un evento tanto localmente como en remoto
  Future<bool> deleteEvent(Event event) async {
    // Primero eliminar localmente
    // Nota: Implementar método para eliminar en StorageService si es necesario
    
    // Si hay conexión, eliminar en el servidor
    if (_isOnline.value) {
      try {
        bool success = await _remoteSource.deleteEvent(event);
        return success;
      } catch (e) {
        print('❌ Error al eliminar evento en el servidor: $e');
        return false;
      }
    }
    
    return true; // Éxito local
  }

  /// Elimina todos los eventos del servidor
  Future<bool> deleteAllRemoteEvents() async {
    if (!_isOnline.value) {
      print('⚠️ No hay conexión a internet. No se pueden eliminar los eventos.');
      return false;
    }
    
    try {
      return await _remoteSource.deleteAllEvents();
    } catch (e) {
      print('❌ Error al eliminar eventos del servidor: $e');
      return false;
    }
  }

  /// Añade una reseña a un evento tanto localmente como en remoto
  Future<bool> addReview(String eventId, Review review) async {
    // Primero añadir localmente
    await StorageService.addReviewToEvent(eventId, review);
    
    // Si hay conexión, añadir en el servidor
    if (_isOnline.value) {
      try {
        bool success = await _remoteSource.addReview(eventId, review);
        return success;
      } catch (e) {
        print('❌ Error al añadir reseña en el servidor: $e');
        return false;
      }
    }
    
    return true; // Éxito local
  }

  /// Libera recursos al cerrar la aplicación
  void dispose() {
    _syncTimer?.cancel();
  }
}