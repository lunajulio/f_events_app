enum EventCategory {
  conference,
  workshop,
  course,
  investigation;


  String get name {
    switch (this) {
      case EventCategory.conference:
        return 'Conference';
      case EventCategory.workshop:
        return 'Workshop';
      case EventCategory.course:
        return 'Course';
      case EventCategory.investigation:
        return 'Investigation';
    }
  }
}