class Event {
  final int eventID;
  final String eventName;
  final DateTime eventDate;
  final String location;
  final String description;
  final int shelterID;
  final String? shelterName;

  const Event({
    required this.eventID,
    required this.eventName,
    required this.eventDate,
    required this.location,
    required this.description,
    required this.shelterID,
    this.shelterName, 
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      eventID: json['eventID'] as int,
      eventName: json['eventName'] as String,
      eventDate: DateTime.parse(json['eventDate'] as String),
      location: json['location'] as String,
      description: json['description'] as String,
      shelterID: json['shelterID'] as int,
      shelterName: json['shelterName'] as String?, 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'eventID': eventID,
      'eventName': eventName,
      'eventDate': eventDate.toIso8601String(),
      'location': location,
      'description': description,
      'shelterID': shelterID,
      'shelterName': shelterName, 
    };
  }
}