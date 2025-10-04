class NotificationModel {
  final String id;
  final String eventId;
  final DateTime scheduledTime;
  final bool isDelivered;
  final String title;
  final String body;
  final String? payload;

  NotificationModel({
    required this.id,
    required this.eventId,
    required this.scheduledTime,
    this.isDelivered = false,
    required this.title,
    required this.body,
    this.payload,
  });

  NotificationModel copyWith({
    String? id,
    String? eventId,
    DateTime? scheduledTime,
    bool? isDelivered,
    String? title,
    String? body,
    String? payload,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      isDelivered: isDelivered ?? this.isDelivered,
      title: title ?? this.title,
      body: body ?? this.body,
      payload: payload ?? this.payload,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventId': eventId,
      'scheduledTime': scheduledTime.toIso8601String(),
      'isDelivered': isDelivered,
      'title': title,
      'body': body,
      'payload': payload,
    };
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      eventId: json['eventId'],
      scheduledTime: DateTime.parse(json['scheduledTime']),
      isDelivered: json['isDelivered'] ?? false,
      title: json['title'],
      body: json['body'],
      payload: json['payload'],
    );
  }
}

