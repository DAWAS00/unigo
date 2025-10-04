class CalendarEvent {
  final String id;
  final String title;
  final DateTime date;
  final String type;
  final bool reminderEnabled;
  final int reminderDays;
  final String reminderTime;
  final String? reminderId;

  CalendarEvent({
    required this.id,
    required this.title,
    required this.date,
    required this.type,
    this.reminderEnabled = false,
    this.reminderDays = 1,
    this.reminderTime = "09:00",
    this.reminderId,
  });

  CalendarEvent copyWith({
    String? id,
    String? title,
    DateTime? date,
    String? type,
    bool? reminderEnabled,
    int? reminderDays,
    String? reminderTime,
    String? reminderId,
  }) {
    return CalendarEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      type: type ?? this.type,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderDays: reminderDays ?? this.reminderDays,
      reminderTime: reminderTime ?? this.reminderTime,
      reminderId: reminderId ?? this.reminderId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'type': type,
      'reminderEnabled': reminderEnabled,
      'reminderDays': reminderDays,
      'reminderTime': reminderTime,
      'reminderId': reminderId,
    };
  }

  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    return CalendarEvent(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      date: DateTime.parse(json['date']),
      type: json['type'] ?? 'Event',
      reminderEnabled: json['reminderEnabled'] ?? false,
      reminderDays: json['reminderDays'] ?? 1,
      reminderTime: json['reminderTime'] ?? '09:00',
      reminderId: json['reminderId'],
    );
  }
}
