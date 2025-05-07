import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/sync_service.dart';
import '../services/remote/remote_event_source.dart';
import '../controllers/event_controller.dart';
import '../models/event.dart';

class SyncStatusPage extends StatefulWidget {
  const SyncStatusPage({super.key});

  @override
  State<SyncStatusPage> createState() => _SyncStatusPageState();
}

class _SyncStatusPageState extends State<SyncStatusPage> {
  final SyncService _syncService = Get.find<SyncService>();
  final EventController _eventController = Get.find<EventController>();
  final RemoteEventSource _remoteSource = RemoteEventSource();
  
  List<Event> _localEvents = [];
  List<Event> _remoteEvents = [];
  bool _isLoading = false;
  String _errorMessage = '';
  String _successMessage = '';

  @override
  void initState() {
    super.initState();
    _checkSyncStatus();
  }

  Future<void> _checkSyncStatus() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _successMessage = '';
    });

    try {
      // Obtener eventos locales (asegurarse de obtener la lista completa y actualizada)
      _localEvents = List<Event>.from(_eventController.allEvents);
      print('Eventos locales cargados: ${_localEvents.length}');
      
      // Obtener eventos remotos
      _remoteEvents = await _remoteSource.getEvents();
      print('Eventos remotos cargados: ${_remoteEvents.length}');
      
      setState(() {
        _isLoading = false;
        _successMessage = 'Datos recuperados correctamente. Local: ${_localEvents.length}, Remoto: ${_remoteEvents.length}';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error al obtener datos: $e';
      });
      print('Error en _checkSyncStatus: $e');
    }
  }

  Future<void> _forceSyncToServer() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _successMessage = '';
    });

    try {
      await _syncService.syncData();
      await _checkSyncStatus(); // Refrescar datos después de sincronizar
      
      setState(() {
        _successMessage = 'Sincronización forzada completada';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error al sincronizar: $e';
      });
    }
  }

  Future<void> _clearAllLocalEvents() async {
    // Mostrar diálogo de confirmación
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar todos los eventos'),
          content: const Text(
            '¿Estás seguro que deseas eliminar todos los eventos almacenados localmente? '
            'Esta acción no se puede deshacer.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    ) ?? false;
    
    if (!confirm) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _successMessage = '';
    });
    
    try {
      // Limpiar eventos usando el controlador
      await _eventController.clearAllEvents();
      
      setState(() {
        _isLoading = false;
        _localEvents = [];
        _successMessage = 'Todos los eventos locales han sido eliminados';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error al eliminar eventos: $e';
      });
    }
  }

  Future<void> _deleteAllServerEvents() async {
    // Mostrar diálogo de confirmación
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar todos los eventos del servidor'),
          content: const Text(
            '¿Estás seguro que deseas eliminar todos los eventos almacenados en el servidor? '
            'Esta acción no se puede deshacer y afectará a todos los usuarios.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    ) ?? false;
    
    if (!confirm) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _successMessage = '';
    });
    
    try {
      // Eliminar eventos del servidor
      bool success = await _syncService.deleteAllRemoteEvents();
      
      if (success) {
        await _checkSyncStatus(); // Refrescar datos después de eliminar
        
        setState(() {
          _isLoading = false;
          _successMessage = 'Todos los eventos del servidor han sido eliminados';
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Hubo errores al eliminar algunos eventos del servidor';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error al eliminar eventos: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estado de Sincronización'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Estado actual
                  _buildStatusCard(),
                  
                  const SizedBox(height: 20),
                  
                  // Secciones de eventos
                  _buildEventsComparison(),
                  
                  // Mensajes de error o éxito
                  if (_errorMessage.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  
                  if (_successMessage.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _successMessage,
                        style: const TextStyle(color: Colors.green),
                      ),
                    ),
                ],
              ),
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: _forceSyncToServer,
            icon: const Icon(Icons.sync),
            label: const Text('Forzar sincronización'),
            backgroundColor: Colors.purple,
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            onPressed: _clearAllLocalEvents,
            icon: const Icon(Icons.delete),
            label: const Text('Eliminar eventos'),
            backgroundColor: Colors.red,
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            onPressed: _deleteAllServerEvents,
            icon: const Icon(Icons.cloud_off),
            label: const Text('Eliminar eventos del servidor'),
            backgroundColor: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Estado de la conexión',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  _syncService.isOnline ? Icons.wifi : Icons.wifi_off,
                  color: _syncService.isOnline ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  _syncService.isOnline ? 'Conectado' : 'Desconectado',
                  style: TextStyle(
                    color: _syncService.isOnline ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Eventos locales:'),
                Text(
                  '${_localEvents.length}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Eventos en servidor:'),
                Text(
                  '${_remoteEvents.length}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('¿Están sincronizados?'),
                _getIsSyncedWidget(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _getIsSyncedWidget() {
    // Verificar si están sincronizados (mismo número de eventos y eventos con los mismos IDs)
    bool hasSameCount = _localEvents.length == _remoteEvents.length;
    
    // Verificar si todos los eventos locales están en el servidor
    List<String> localIds = _localEvents.map((e) => e.id).toList();
    List<String> remoteIds = _remoteEvents.map((e) => e.id).toList();
    bool allLocalInRemote = localIds.every((id) => remoteIds.contains(id));
    
    // Sincronizado si tienen la misma cantidad y todos los eventos locales están en remoto
    bool isSynced = hasSameCount && allLocalInRemote;
    
    return Row(
      children: [
        Icon(
          isSynced ? Icons.check_circle : Icons.warning,
          color: isSynced ? Colors.green : Colors.orange,
        ),
        const SizedBox(width: 4),
        Text(
          isSynced ? 'Sí' : 'No',
          style: TextStyle(
            color: isSynced ? Colors.green : Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildEventsComparison() {
    return ExpansionTile(
      title: const Text(
        'Comparación detallada',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      children: [
        for (var localEvent in _localEvents)
          _buildEventSyncStatusItem(localEvent),
      ],
    );
  }

  Widget _buildEventSyncStatusItem(Event localEvent) {
    // Buscar el mismo evento en la lista de eventos remotos
    Event? remoteEvent = _remoteEvents
        .firstWhereOrNull((e) => e.id == localEvent.id);
    
    bool isInServer = remoteEvent != null;
    bool hasSameReviewCount = isInServer 
        ? localEvent.reviews.length == remoteEvent.reviews.length
        : false;
    
    // Usamos un widget SafeArea para evitar problemas de layout
    return SafeArea(
      child: ListTile(
        leading: Icon(
          isInServer ? 
            (hasSameReviewCount ? Icons.check_circle : Icons.sync_problem) :
            Icons.cloud_off,
          color: isInServer ? 
            (hasSameReviewCount ? Colors.green : Colors.orange) :
            Colors.red,
        ),
        title: Text(
          localEvent.title,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        subtitle: Text(
          isInServer
              ? 'Reseñas local: ${localEvent.reviews.length}, Servidor: ${remoteEvent?.reviews.length ?? 0}'
              : 'No encontrado en el servidor',
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        trailing: Text(
          isInServer
              ? (hasSameReviewCount ? 'Sincronizado' : 'Parcial')
              : 'No sincronizado',
          style: TextStyle(
            color: isInServer
                ? (hasSameReviewCount ? Colors.green : Colors.orange)
                : Colors.red,
          ),
        ),
      ),
    );
  }
}