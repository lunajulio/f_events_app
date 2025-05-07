// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_category.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventCategoryAdapter extends TypeAdapter<EventCategory> {
  @override
  final int typeId = 2;

  @override
  EventCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return EventCategory.conference;
      case 1:
        return EventCategory.workshop;
      case 2:
        return EventCategory.course;
      case 3:
        return EventCategory.investigation;
      default:
        return EventCategory.conference;
    }
  }

  @override
  void write(BinaryWriter writer, EventCategory obj) {
    switch (obj) {
      case EventCategory.conference:
        writer.writeByte(0);
        break;
      case EventCategory.workshop:
        writer.writeByte(1);
        break;
      case EventCategory.course:
        writer.writeByte(2);
        break;
      case EventCategory.investigation:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
