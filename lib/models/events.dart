class Event {
  final String id;
  final String title;
  final String location;
  final String date;
  final String time;
  final String description;
  bool subscribed;
  final String? image;

  Event({
    required this.id,
    required this.title,
    required this.location,
    required this.date,
    required this.time,
    required this.description,
    this.subscribed = false,
    required this.image
  });

  Event copyWith({
    String? id,
    String? title,
    String? location,
    String? date,
    String? time,
    String? description,
    bool? subscribed,
    String? image,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      location: location ?? this.location,
      date: date ?? this.date,
      time: time ?? this.time,
      description: description ?? this.description,
      subscribed: subscribed ?? this.subscribed,
      image: image ?? this.image,
    );
  }
}


