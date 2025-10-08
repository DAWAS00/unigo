import 'package:flutter/material.dart';
import '../models/calendar_event.dart';
import '../models/notification_model.dart';
import 'notification_service.dart';
import 'toast_service.dart';
import 'enhanced_notification_service.dart';

class ReminderService {
  static final ReminderService _instance = ReminderService._internal();
  factory ReminderService() => _instance;
  ReminderService._internal();

  final NotificationService _notificationService = NotificationService();
  final EnhancedNotificationService _enhancedService = EnhancedNotificationService();

  Future<bool> scheduleEventReminder(CalendarEvent event) async {
    if (!event.reminderEnabled) {
      print('Reminder not enabled for event: ${event.title}');
      return false;
    }

    try {
      // Calculate reminder time
      final reminderTime = _calculateReminderTime(event);
      if (reminderTime == null) {
        print('Invalid reminder time for event: ${event.title}');
        return false;
      }

      // Create notification model
      final notification = NotificationModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        eventId: event.id,
        scheduledTime: reminderTime,
        title: 'Event Reminder',
        body: '${event.title} is coming up in ${event.reminderDays} day${event.reminderDays > 1 ? 's' : ''}!',
        payload: event.id,
      );

      // Schedule notification
      final notificationId = await _notificationService.scheduleNotification(notification);
      if (notificationId != null) {
        print('Reminder scheduled for event: ${event.title} at $reminderTime');
        return true;
      } else {
        print('Failed to schedule reminder for event: ${event.title}');
        return false;
      }
    } catch (e) {
      print('Error scheduling reminder for event ${event.title}: $e');
      return false;
    }
  }

  Future<bool> updateEventReminder(CalendarEvent oldEvent, CalendarEvent newEvent) async {
    // Cancel old reminder if it exists
    if (oldEvent.reminderId != null) {
      await _notificationService.cancelNotification(oldEvent.reminderId!);
    }

    // Schedule new reminder if enabled
    if (newEvent.reminderEnabled) {
      return await scheduleEventReminder(newEvent);
    }

    return true;
  }

  Future<bool> cancelEventReminder(CalendarEvent event) async {
    if (event.reminderId == null) return true;

    try {
      await _notificationService.cancelNotification(event.reminderId!);
      print('Reminder cancelled for event: ${event.title}');
      return true;
    } catch (e) {
      print('Error cancelling reminder for event ${event.title}: $e');
      return false;
    }
  }

  DateTime? _calculateReminderTime(CalendarEvent event) {
    try {
      // Parse reminder time (format: "HH:mm")
      final timeParts = event.reminderTime.split(':');
      if (timeParts.length != 2) {
        print('Invalid time format: ${event.reminderTime}');
        return null;
      }

      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
        print('Invalid time values: ${event.reminderTime}');
        return null;
      }

      // Calculate reminder date (event date minus reminder days)
      final reminderDate = event.date.subtract(Duration(days: event.reminderDays));
      
      // Create reminder datetime
      final reminderDateTime = DateTime(
        reminderDate.year,
        reminderDate.month,
        reminderDate.day,
        hour,
        minute,
      );

      // Check if reminder time is in the past
      if (reminderDateTime.isBefore(DateTime.now())) {
        print('Reminder time is in the past for event: ${event.title}');
        return null;
      }

      return reminderDateTime;
    } catch (e) {
      print('Error calculating reminder time: $e');
      return null;
    }
  }

  Future<bool> validateReminderSettings({
    required DateTime eventDate,
    required int reminderDays,
    required String reminderTime,
  }) async {
    try {
      // Parse reminder time
      final timeParts = reminderTime.split(':');
      if (timeParts.length != 2) return false;

      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return false;

      // Calculate reminder date
      final reminderDate = eventDate.subtract(Duration(days: reminderDays));
      final reminderDateTime = DateTime(
        reminderDate.year,
        reminderDate.month,
        reminderDate.day,
        hour,
        minute,
      );

      // Check if reminder time is in the past
      return reminderDateTime.isAfter(DateTime.now());
    } catch (e) {
      print('Error validating reminder settings: $e');
      return false;
    }
  }

  List<String> getAvailableReminderTimes() {
    return [
      "08:00", "09:00", "10:00", "11:00", "12:00",
      "13:00", "14:00", "15:00", "16:00", "17:00",
      "18:00", "19:00", "20:00", "21:00", "22:00"
    ];
  }

  List<int> getAvailableReminderDays() {
    return [1, 2, 3, 7, 14, 30]; // 1 day, 2 days, 3 days, 1 week, 2 weeks, 1 month
  }

  /// Shows a toast notification for a reminder
  /// This method should be called when a reminder is triggered
  /// @param context The build context
  /// @param event The calendar event that triggered the reminder
  void showReminderToast(BuildContext context, CalendarEvent event) {
    if (event.type == "Reminder") {
      ToastService.showReminder(
        context,
        title: event.title,
        description: "Time for your reminder!",
      );
    } else {
      ToastService.showClassReminder(
        context,
        className: event.title,
        time: "${event.date.hour.toString().padLeft(2, '0')}:${event.date.minute.toString().padLeft(2, '0')}",
        location: "Check your schedule",
      );
    }
  }

  /// Creates a test reminder that triggers immediately
  /// @param context The build context
  /// @param title The reminder title
  /// @param description The reminder description
  void showTestReminder(BuildContext context, String title, String description) {
    ToastService.showReminder(
      context,
      title: title,
      description: description,
    );
  }
}
