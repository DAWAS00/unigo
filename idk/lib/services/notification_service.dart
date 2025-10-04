import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import '../models/notification_model.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  Future<bool> initialize() async {
    if (_isInitialized) return true;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    try {
      await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );
      _isInitialized = true;
      return true;
    } catch (e) {
      print('Failed to initialize notifications: $e');
      return false;
    }
  }

  Future<bool> requestPermissions() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  Future<bool> hasPermissions() async {
    final status = await Permission.notification.status;
    return status.isGranted;
  }

  Future<String?> scheduleNotification(NotificationModel notification) async {
    try {
      if (!await hasPermissions()) {
        print('Notification permissions not granted');
        return null;
      }

      final androidDetails = AndroidNotificationDetails(
        'calendar_reminders',
        'Calendar Reminders',
        channelDescription: 'Notifications for calendar events',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      final details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      final notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      
      await _notifications.zonedSchedule(
        notificationId,
        notification.title,
        notification.body,
        tz.TZDateTime.from(notification.scheduledTime, tz.local),
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        payload: notification.payload,
      );

      print('Notification scheduled for ${notification.scheduledTime}');
      return notificationId.toString();
    } catch (e) {
      print('Failed to schedule notification: $e');
      return null;
    }
  }

  Future<void> cancelNotification(String notificationId) async {
    try {
      await _notifications.cancel(int.parse(notificationId));
      print('Notification $notificationId cancelled');
    } catch (e) {
      print('Failed to cancel notification: $e');
    }
  }

  Future<void> cancelAllNotifications() async {
    try {
      await _notifications.cancelAll();
      print('All notifications cancelled');
    } catch (e) {
      print('Failed to cancel all notifications: $e');
    }
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    try {
      return await _notifications.pendingNotificationRequests();
    } catch (e) {
      print('Failed to get pending notifications: $e');
      return [];
    }
  }

  void _onNotificationTapped(NotificationResponse response) {
    print('Notification tapped: ${response.payload}');
    // Handle notification tap - could navigate to calendar or specific event
    // This would typically involve using a navigator or callback
  }

  Future<void> showInstantNotification(String title, String body) async {
    try {
      if (!await hasPermissions()) return;

      const androidDetails = AndroidNotificationDetails(
        'instant_notifications',
        'Instant Notifications',
        channelDescription: 'Instant notifications',
        importance: Importance.high,
        priority: Priority.high,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        details,
      );
    } catch (e) {
      print('Failed to show instant notification: $e');
    }
  }
}
