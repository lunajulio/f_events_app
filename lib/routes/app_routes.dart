import 'package:get/get.dart';
import '../pages/homepage.dart';
import '../pages/my_events.dart';
import '../pages/event_details.dart';
import '../pages/all_events.dart';
import '../pages/subscription_success.dart';
import '../pages/sync_status_page.dart';

class AppRoutes {
  // Define las rutas como constantes estáticas
  static const HOME = '/';
  static const MY_EVENTS = '/my-events';
  static const EVENT_DETAILS = '/event-details';
  static const ALL_EVENTS = '/all-events';
  static const SUBSCRIPTION = '/subscription-success';
  static const API_TEST = '/api-test';
  static const SYNC_STATUS = '/sync-status';

  static final pages = [
    GetPage(
      name: HOME,
      page: () => HomePage(),
    ),
    GetPage(
      name: MY_EVENTS,
      page: () => MyEventsPage(),
    ),
    GetPage(
      name: EVENT_DETAILS,
      page: () => EventDetailsPage(event: Get.arguments),
    ),
    GetPage(
      name: ALL_EVENTS,
      page: () => AllEventsPage(),
    ),
    GetPage(
      name: SUBSCRIPTION,
      page: () => SubscriptionSuccess(),
    ),
    GetPage(
      name: SYNC_STATUS,
      page: () => const SyncStatusPage(),
    ),
  ];
}