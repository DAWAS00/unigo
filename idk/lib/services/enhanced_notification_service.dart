import 'package:flutter/material.dart';
import 'notification_service.dart';
import 'toast_service.dart';
import '../models/calendar_event.dart';
import '../models/notification_model.dart';

/// Enhanced notification service that combines system push notifications with in-app toasts
/// Provides both immediate system notifications and beautiful in-app feedback
class EnhancedNotificationService {
  static final EnhancedNotificationService _instance = EnhancedNotificationService._internal();
  factory EnhancedNotificationService() => _instance;
  EnhancedNotificationService._internal();

  final NotificationService _notificationService = NotificationService();

  /// Shows a reminder notification both as system notification and in-app toast
  /// @param context The build context for showing toasts
  /// @param event The calendar event that triggered the reminder
  Future<void> showReminderNotification(BuildContext context, CalendarEvent event) async {
    try {
      // Show system push notification
      await _notificationService.showInstantNotification(
        '🔔 Reminder: ${event.title}',
        'Time for your reminder!',
      );

      // Show in-app toast notification
      ToastService.showReminder(
        context,
        title: event.title,
        description: 'Time for your reminder!',
      );

      print('Reminder notification shown for: ${event.title}');
    } catch (e) {
      print('Error showing reminder notification: $e');
    }
  }

  /// Shows a class reminder notification
  /// @param context The build context for showing toasts
  /// @param event The calendar event that triggered the reminder
  Future<void> showClassReminderNotification(BuildContext context, CalendarEvent event) async {
    try {
      final timeStr = "${event.date.hour.toString().padLeft(2, '0')}:${event.date.minute.toString().padLeft(2, '0')}";
      
      // Show system push notification
      await _notificationService.showInstantNotification(
        '📚 Class Reminder: ${event.title}',
        'Your class starts at $timeStr',
      );

      // Show in-app toast notification
      ToastService.showClassReminder(
        context,
        className: event.title,
        time: timeStr,
        location: 'Check your schedule',
      );

      print('Class reminder notification shown for: ${event.title}');
    } catch (e) {
      print('Error showing class reminder notification: $e');
    }
  }

  /// Shows a success notification when reminder is added
  /// @param context The build context for showing toasts
  /// @param title The reminder title
  /// @param scheduledTime The time when the reminder will trigger
  Future<void> showReminderAddedNotification(BuildContext context, String title, DateTime scheduledTime) async {
    try {
      final timeStr = "${scheduledTime.hour.toString().padLeft(2, '0')}:${scheduledTime.minute.toString().padLeft(2, '0')}";
      
      // Show system push notification
      await _notificationService.showInstantNotification(
        '✅ Reminder Added',
        '$title scheduled for $timeStr',
      );

      // Show in-app toast notification
      ToastService.showSuccess(
        context,
        title: 'Reminder Added!',
        description: 'You will be notified at $timeStr',
      );

      print('Reminder added notification shown for: $title');
    } catch (e) {
      print('Error showing reminder added notification: $e');
    }
  }

  /// Shows a test notification to verify the system works
  /// @param context The build context for showing toasts
  Future<void> showTestNotification(BuildContext context) async {
    try {
      // Show system push notification
      await _notificationService.showInstantNotification(
        '🧪 Test Notification',
        'Your notification system is working perfectly!',
      );

      // Show in-app toast notification
      ToastService.showInfo(
        context,
        title: 'Test Notification',
        description: 'System notifications are working!',
      );

      print('Test notification shown');
    } catch (e) {
      print('Error showing test notification: $e');
    }
  }

  /// Shows a notification when reminder is updated
  /// @param context The build context for showing toasts
  /// @param title The reminder title
  Future<void> showReminderUpdatedNotification(BuildContext context, String title) async {
    try {
      // Show system push notification
      await _notificationService.showInstantNotification(
        '✏️ Reminder Updated',
        '$title has been updated',
      );

      // Show in-app toast notification
      ToastService.showSuccess(
        context,
        title: 'Reminder Updated!',
        description: title,
      );

      print('Reminder updated notification shown for: $title');
    } catch (e) {
      print('Error showing reminder updated notification: $e');
    }
  }

  /// Shows a notification when reminder is deleted
  /// @param context The build context for showing toasts
  /// @param title The reminder title
  Future<void> showReminderDeletedNotification(BuildContext context, String title) async {
    try {
      // Show system push notification
      await _notificationService.showInstantNotification(
        '🗑️ Reminder Deleted',
        '$title has been removed',
      );

      // Show in-app toast notification
      ToastService.showWarning(
        context,
        title: 'Reminder Deleted',
        description: title,
      );

      print('Reminder deleted notification shown for: $title');
    } catch (e) {
      print('Error showing reminder deleted notification: $e');
    }
  }

  /// Schedules a future reminder notification
  /// @param event The calendar event to schedule
  /// @return True if successfully scheduled
  Future<bool> scheduleReminderNotification(CalendarEvent event) async {
    try {
      if (!event.reminderEnabled) {
        print('Reminder not enabled for event: ${event.title}');
        return false;
      }

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
        title: '🔔 Reminder: ${event.title}',
        body: 'Time for your reminder!',
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
      print('Error scheduling reminder notification: $e');
      return false;
    }
  }

  /// Calculates the reminder time based on event settings
  /// @param event The calendar event
  /// @return The calculated reminder time or null if invalid
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

  /// Cancels a scheduled reminder notification
  /// @param event The calendar event
  /// @return True if successfully cancelled
  Future<bool> cancelReminderNotification(CalendarEvent event) async {
    try {
      if (event.reminderId == null) return true;

      await _notificationService.cancelNotification(event.reminderId!);
      print('Reminder cancelled for event: ${event.title}');
      return true;
    } catch (e) {
      print('Error cancelling reminder for event ${event.title}: $e');
      return false;
    }
  }

  /// Checks if notification permissions are granted
  /// @return True if permissions are granted
  Future<bool> hasPermissions() async {
    return await _notificationService.hasPermissions();
  }

  /// Requests notification permissions
  /// @return True if permissions were granted
  Future<bool> requestPermissions() async {
    return await _notificationService.requestPermissions();
  }

  /// Initializes the notification service
  /// @return True if successfully initialized
  Future<bool> initialize() async {
    return await _notificationService.initialize();
  }
}
