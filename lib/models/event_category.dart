import 'package:hive/hive.dart';

part 'event_category.g.dart'; // Este archivo será generado automáticamente

@HiveType(typeId: 2)
enum EventCategory {
  @HiveField(0)
  conference,
  
  @HiveField(1)
  workshop,
  
  @HiveField(2)
  course,
  
  @HiveField(3)
  investigation
}