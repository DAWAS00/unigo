import 'package:flutter/material.dart';
import '../models/calendar_event.dart';
import '../services/reminder_service.dart';
import '../controllers/notification_controller.dart';

class CalendarController extends ChangeNotifier {
  final DateTime today = DateTime.now();
  late DateTime currentMonth;
  late int selectedDay;

  String selectedTab = "Events";
  String selectedFilter = "All";
  bool showFilterMenu = false;

  final ReminderService _reminderService = ReminderService();
  final NotificationController _notificationController = NotificationController();

  List<CalendarEvent> _events = [];
  List<CalendarEvent> get events => _events;

  static const months = [
    'January','February','March','April','May','June',
    'July','August','September','October','November','December',
  ];
  static const weekdays = [
    'Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday',
  ];

  CalendarController() {
    currentMonth = DateTime(today.year, today.month, 1);
    selectedDay = today.day;
    _createTestEvent();
  }

  void _createTestEvent() {
    // Create a test event that will trigger a notification in 2 minutes
    final testEvent = CalendarEvent(
      id: "test_${DateTime.now().millisecondsSinceEpoch}",
      title: "🔥 TEST NOTIFICATION - 2 minutes",
      date: DateTime.now().add(const Duration(minutes: 2)),
      type: "Event",
      reminderEnabled: true,
      reminderDays: 1,
      reminderTime: DateTime.now().add(const Duration(minutes: 1)).toString().substring(11, 16), // 1 minute from now
    );
    
    // Add to local list immediately for testing
    _events.add(testEvent);
    notifyListeners();
    
    // Schedule the notification
    _reminderService.scheduleEventReminder(testEvent);
    
    print("🧪 Test event created! Notification should appear in 1 minute.");
  }


  int daysInMonth(DateTime m) => DateUtils.getDaysInMonth(m.year, m.month);
  int mondayBasedWeekday(DateTime d) => d.weekday % 7;
  DateTime dateFor(int day) => DateTime(currentMonth.year, currentMonth.month, day);

  List<CalendarEvent> eventsForDate(DateTime date) {
    return events.where((e) =>
      e.date.year == date.year &&
      e.date.month == date.month &&
      e.date.day == date.day
    ).toList();
  }

  Color dotColor(String type) {
    switch (type) {
      case "Event": return Colors.greenAccent.shade400;
      case "Deadline": return Colors.redAccent.shade200;
      case "Reminder": return Colors.amber.shade400;
      default: return Colors.grey;
    }
  }

  void selectDay(int day) {
    selectedDay = day;
    notifyListeners();
  }

  void changeMonth(int delta) {
    currentMonth = DateTime(currentMonth.year, currentMonth.month + delta, 1);
    notifyListeners();
  }
  void toggleTab(String tab) {
    selectedTab = tab;
    notifyListeners();
  }

  void toggleFilterMenu() {
    showFilterMenu = !showFilterMenu;
    notifyListeners();
  }

  void selectFilter(String filter) {
    selectedFilter = filter;
    showFilterMenu = false;
    notifyListeners();
  }

  Future<void> addReminder(String title, DateTime date) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final event = CalendarEvent(
      id: id,
      title: title, 
      date: date, 
      type: "Reminder",
      reminderEnabled: false,
    );
    _events.add(event);
    notifyListeners();
  }

  Future<void> addEventWithReminder({
    required String title,
    required DateTime date,
    required String type,
    bool reminderEnabled = false,
    int reminderDays = 1,
    String reminderTime = "09:00",
  }) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final event = CalendarEvent(
      id: id,
      title: title,
      date: date,
      type: type,
      reminderEnabled: reminderEnabled,
      reminderDays: reminderDays,
      reminderTime: reminderTime,
    );

    _events.add(event);
    notifyListeners();
    
    if (reminderEnabled) {
      await _reminderService.scheduleEventReminder(event);
    }
  }

  Future<void> updateEventReminder(CalendarEvent oldEvent, CalendarEvent newEvent) async {
    final index = _events.indexWhere((e) => e.id == oldEvent.id);
    if (index != -1) {
      _events[index] = newEvent;
      notifyListeners();
    }
    await _reminderService.updateEventReminder(oldEvent, newEvent);
  }

  Future<void> toggleEventReminder(CalendarEvent event) async {
    final updatedEvent = event.copyWith(
      reminderEnabled: !event.reminderEnabled,
    );
    await updateEventReminder(event, updatedEvent);
  }

  Future<void> deleteEvent(CalendarEvent event) async {
    if (event.reminderId != null) {
      await _reminderService.cancelEventReminder(event);
    }
    _events.removeWhere((e) => e.id == event.id);
    notifyListeners();
  }

  Future<void> initializeReminders() async {
    await _notificationController.initialize();
    
    // Schedule reminders for existing events
    for (final event in events) {
      if (event.reminderEnabled) {
        await _reminderService.scheduleEventReminder(event);
      }
    }
  }

  List<String> getAvailableReminderTimes() {
    return _reminderService.getAvailableReminderTimes();
  }

  List<int> getAvailableReminderDays() {
    return _reminderService.getAvailableReminderDays();
  }

  Future<bool> validateReminderSettings({
    required DateTime eventDate,
    required int reminderDays,
    required String reminderTime,
  }) async {
    return await _reminderService.validateReminderSettings(
      eventDate: eventDate,
      reminderDays: reminderDays,
      reminderTime: reminderTime,
    );
  }

  // Test method to show immediate notification
  Future<void> testNotification() async {
    await _notificationController.showInstantNotification(
      "🧪 IMMEDIATE TEST",
      "This notification appeared instantly! Your notification system is working! 🎉",
    );
  }

  // Test method to create a quick test event
  Future<void> createQuickTestEvent() async {
    final quickTestEvent = CalendarEvent(
      id: "quick_test_${DateTime.now().millisecondsSinceEpoch}",
      title: "⚡ QUICK TEST - 30 seconds",
      date: DateTime.now().add(const Duration(seconds: 30)),
      type: "Event",
      reminderEnabled: true,
      reminderDays: 1,
      reminderTime: DateTime.now().add(const Duration(seconds: 10)).toString().substring(11, 16), // 10 seconds from now
    );
    
    _events.add(quickTestEvent);
    notifyListeners();
    
    await _reminderService.scheduleEventReminder(quickTestEvent);
    
    print("⚡ Quick test event created! Notification should appear in 10 seconds.");
  }
}
