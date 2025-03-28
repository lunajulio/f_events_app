import 'package:get/get.dart';
import '../models/events.dart';

class SubsController extends GetxController {
  var events = <Event>[].obs;
  var subscribedEvents = <Event>[].obs;

  /// Suscribirse a un evento
  void subscribeToEvent(Event event) {
    final index = events.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      final updated = event.copyWith(
        subscribed: true,
        
      );
      events[index] = updated;
      subscribedEvents.add(updated);
    }
  }

  /// Cancelar la suscripción a un evento
  void unsubscribeFromEvent(Event event) {
    final index = events.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      final updated = event.copyWith(
        subscribed: false,
        
      );
      events[index] = updated;
      subscribedEvents.removeWhere((e) => e.id == updated.id);
    }
  }

  /// Alternar suscripción
  void toggleSubscription(Event event) {
    if (event.subscribed) {
      unsubscribeFromEvent(event);
    } else {
      subscribeToEvent(event);
    }
  }

  /// Cargar lista inicial de eventos (si los tienes en otro archivo)
  void loadDummyEvents(List<Event> dummy) {
    events.assignAll(dummy);
    subscribedEvents.assignAll(dummy.where((e) => e.subscribed));
  }
}