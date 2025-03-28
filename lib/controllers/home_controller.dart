import 'package:event_app/models/events.dart';
import 'package:get/get.dart';
import '../models/events.dart';
import '../data/dummy_events.dart';

class HomeController extends GetxController {
  RxList<Event> allEvents = <Event>[].obs;
  RxList<Event> subscribedEvents = <Event>[].obs;

  @override
  void onInit() {
    allEvents.addAll(dummyEvents);
    subscribedEvents.addAll(dummyEvents.where((e) => e.subscribed));
    super.onInit();
  }

  void toggleSubscription(Event event) {
    final index = allEvents.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      final updated = event.copyWith(subscribed: !event.subscribed);
      allEvents[index] = updated;

      if (updated.subscribed) {
        subscribedEvents.add(updated);
      } else {
        subscribedEvents.removeWhere((e) => e.id == updated.id);
      }
    }
  }
}