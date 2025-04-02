import 'package:event_app/pages/eventlist.dart';
import 'package:get/get.dart';

class Event {
  final String id;
  final String title;
  final String location;
  final String dateTime;
  final int maxParticipants;
  int currentParticipants;
  bool get isFull => currentParticipants >= maxParticipants;
  final String description;

  Event({
    required this.id,
    required this.title,
    required this.location,
    required this.dateTime,
    required this.maxParticipants,
    this.currentParticipants = 0,
    required this.description,
  });
}

class EventController extends GetxController {
  var allEvents = <Event>[].obs;
  var subscribedEvents = <Event>[].obs;
  var subscribedEventIds = <String>{}.obs;  

  @override
  void onInit() {
    super.onInit();
    loadEvents();
  }

    bool isSubscribed(Event event) {
    return subscribedEventIds.contains(event.id);
  }

  void loadEvents() {
    allEvents.value = EventsList;
  }
  void toggleSubscription(Event event) {
  if (isSubscribed(event)) {
    event.currentParticipants--;
    subscribedEvents.removeWhere((e) => e.id == event.id);
    subscribedEventIds.remove(event.id); 
  } else {
    if (event.currentParticipants < event.maxParticipants) {
      event.currentParticipants++;
      subscribedEvents.add(event);
      subscribedEventIds.add(event.id);
    }
  }
  update();
}



  void _updateParticipantCount(String eventId, int change) {
    Event? event = allEvents.firstWhereOrNull((e) => e.id == eventId);
    if (event != null) {
      event.currentParticipants += change;
      update();
    }
  }
}
