// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventAdapter extends TypeAdapter<Event> {
  @override
  final int typeId = 0;

  @override
  Event read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Event(
      id: fields[0] as String,
      title: fields[1] as String,
      location: fields[2] as String,
      dateTime: fields[3] as DateTime,
      description: fields[4] as String,
      maxParticipants: fields[5] as int,
      category: fields[7] as EventCategory,
      isPastEvent: fields[8] as bool,
      imageUrl: fields[9] as String,
      totalRatings: fields[11] as int,
      reviews: (fields[12] as List?)?.cast<Review>(),
    )
      .._currentParticipantsValue = fields[6] as int
      .._ratingValue = fields[10] as double;
  }

  @override
  void write(BinaryWriter writer, Event obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.location)
      ..writeByte(3)
      ..write(obj.dateTime)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.maxParticipants)
      ..writeByte(6)
      ..write(obj._currentParticipantsValue)
      ..writeByte(7)
      ..write(obj.category)
      ..writeByte(8)
      ..write(obj.isPastEvent)
      ..writeByte(9)
      ..write(obj.imageUrl)
      ..writeByte(10)
      ..write(obj._ratingValue)
      ..writeByte(11)
      ..write(obj.totalRatings)
      ..writeByte(12)
      ..write(obj.reviews);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
