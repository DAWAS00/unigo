import 'package:flutter/material.dart';
import '../services/notification_service.dart';
import '../models/notification_model.dart';

class NotificationController extends ChangeNotifier {
  final NotificationService _notificationService = NotificationService();
  
  bool _isInitialized = false;
  bool _hasPermissions = false;
  List<NotificationModel> _scheduledNotifications = [];

  bool get isInitialized => _isInitialized;
  bool get hasPermissions => _hasPermissions;
  List<NotificationModel> get scheduledNotifications => List.unmodifiable(_scheduledNotifications);

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _isInitialized = await _notificationService.initialize();
      if (_isInitialized) {
        _hasPermissions = await _notificationService.hasPermissions();
        await _loadScheduledNotifications();
      }
      notifyListeners();
    } catch (e) {
      print('Error initializing notification controller: $e');
    }
  }

  Future<bool> requestPermissions() async {
    try {
      _hasPermissions = await _notificationService.requestPermissions();
      notifyListeners();
      return _hasPermissions;
    } catch (e) {
      print('Error requesting notification permissions: $e');
      return false;
    }
  }

  Future<void> _loadScheduledNotifications() async {
    try {
      final pending = await _notificationService.getPendingNotifications();
      _scheduledNotifications = pending.map((notification) {
        return NotificationModel(
          id: notification.id.toString(),
          eventId: '', // This would need to be stored separately
          scheduledTime: DateTime.now(), // This would need to be calculated
          title: notification.title ?? '',
          body: notification.body ?? '',
          payload: notification.payload,
        );
      }).toList();
    } catch (e) {
      print('Error loading scheduled notifications: $e');
    }
  }

  Future<bool> scheduleNotification(NotificationModel notification) async {
    if (!_hasPermissions) {
      final granted = await requestPermissions();
      if (!granted) return false;
    }

    try {
      final notificationId = await _notificationService.scheduleNotification(notification);
      if (notificationId != null) {
        _scheduledNotifications.add(notification.copyWith(id: notificationId));
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Error scheduling notification: $e');
      return false;
    }
  }

  Future<bool> cancelNotification(String notificationId) async {
    try {
      await _notificationService.cancelNotification(notificationId);
      _scheduledNotifications.removeWhere((n) => n.id == notificationId);
      notifyListeners();
      return true;
    } catch (e) {
      print('Error cancelling notification: $e');
      return false;
    }
  }

  Future<void> cancelAllNotifications() async {
    try {
      await _notificationService.cancelAllNotifications();
      _scheduledNotifications.clear();
      notifyListeners();
    } catch (e) {
      print('Error cancelling all notifications: $e');
    }
  }

  Future<void> showInstantNotification(String title, String body) async {
    if (!_hasPermissions) {
      final granted = await requestPermissions();
      if (!granted) return;
    }

    try {
      await _notificationService.showInstantNotification(title, body);
    } catch (e) {
      print('Error showing instant notification: $e');
    }
  }

  bool isNotificationScheduled(String eventId) {
    return _scheduledNotifications.any((n) => n.eventId == eventId);
  }

  NotificationModel? getNotificationForEvent(String eventId) {
    try {
      return _scheduledNotifications.firstWhere((n) => n.eventId == eventId);
    } catch (e) {
      return null;
    }
  }
}

