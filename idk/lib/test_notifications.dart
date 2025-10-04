import 'package:flutter/material.dart';
import 'services/notification_service.dart';
import 'controllers/calendar_controller.dart';
import 'models/calendar_event.dart';
import 'models/notification_model.dart';

/// Comprehensive test class for notification functionality
class NotificationTester {
  final NotificationService _notificationService = NotificationService();
  final CalendarController _calendarController = CalendarController();

  /// Test 1: Initialize notification service
  Future<bool> testInitialization() async {
    print('🧪 Testing notification initialization...');
    
    try {
      final initialized = await _notificationService.initialize();
      if (initialized) {
        print('✅ Notification service initialized successfully');
        return true;
      } else {
        print('❌ Failed to initialize notification service');
        return false;
      }
    } catch (e) {
      print('❌ Error during initialization: $e');
      return false;
    }
  }

  /// Test 2: Request and check permissions
  Future<bool> testPermissions() async {
    print('🧪 Testing notification permissions...');
    
    try {
      // Check current permission status
      final hasPermissions = await _notificationService.hasPermissions();
      print('Current permission status: ${hasPermissions ? "Granted" : "Not granted"}');
      
      if (!hasPermissions) {
        print('Requesting notification permissions...');
        final granted = await _notificationService.requestPermissions();
        if (granted) {
          print('✅ Notification permissions granted');
          return true;
        } else {
          print('❌ Notification permissions denied');
          return false;
        }
      } else {
        print('✅ Notification permissions already granted');
        return true;
      }
    } catch (e) {
      print('❌ Error checking permissions: $e');
      return false;
    }
  }

  /// Test 3: Show instant notification
  Future<bool> testInstantNotification() async {
    print('🧪 Testing instant notification...');
    
    try {
      await _notificationService.showInstantNotification(
        '🧪 Test Notification',
        'This is a test notification to verify the system is working!',
      );
      print('✅ Instant notification sent');
      return true;
    } catch (e) {
      print('❌ Error sending instant notification: $e');
      return false;
    }
  }

  /// Test 4: Schedule a notification for 10 seconds from now
  Future<bool> testScheduledNotification() async {
    print('🧪 Testing scheduled notification (10 seconds)...');
    
    try {
      final scheduledTime = DateTime.now().add(const Duration(seconds: 10));
      final notification = NotificationModel(
        id: 'test_${DateTime.now().millisecondsSinceEpoch}',
        eventId: 'test_event',
        scheduledTime: scheduledTime,
        title: '⏰ Scheduled Test',
        body: 'This notification was scheduled 10 seconds ago!',
        payload: 'test_payload',
      );

      final notificationId = await _notificationService.scheduleNotification(notification);
      if (notificationId != null) {
        print('✅ Notification scheduled for ${scheduledTime.toString()}');
        print('   Notification ID: $notificationId');
        return true;
      } else {
        print('❌ Failed to schedule notification');
        return false;
      }
    } catch (e) {
      print('❌ Error scheduling notification: $e');
      return false;
    }
  }

  /// Test 5: Schedule a notification for 1 minute from now
  Future<bool> testMinuteNotification() async {
    print('🧪 Testing 1-minute notification...');
    
    try {
      final scheduledTime = DateTime.now().add(const Duration(minutes: 1));
      final notification = NotificationModel(
        id: 'minute_test_${DateTime.now().millisecondsSinceEpoch}',
        eventId: 'minute_test_event',
        scheduledTime: scheduledTime,
        title: '⏱️ 1-Minute Test',
        body: 'This notification was scheduled 1 minute ago!',
        payload: 'minute_test_payload',
      );

      final notificationId = await _notificationService.scheduleNotification(notification);
      if (notificationId != null) {
        print('✅ 1-minute notification scheduled for ${scheduledTime.toString()}');
        print('   Notification ID: $notificationId');
        return true;
      } else {
        print('❌ Failed to schedule 1-minute notification');
        return false;
      }
    } catch (e) {
      print('❌ Error scheduling 1-minute notification: $e');
      return false;
    }
  }

  /// Test 6: Test calendar event with reminder
  Future<bool> testCalendarEventReminder() async {
    print('🧪 Testing calendar event with reminder...');
    
    try {
      // Create a test event that triggers in 30 seconds
      final testEvent = CalendarEvent(
        id: 'calendar_test_${DateTime.now().millisecondsSinceEpoch}',
        title: '📅 Calendar Test Event',
        date: DateTime.now().add(const Duration(seconds: 30)),
        type: 'Event',
        reminderEnabled: true,
        reminderDays: 1,
        reminderTime: DateTime.now().add(const Duration(seconds: 15)).toString().substring(11, 16),
      );

      // Add event to calendar controller
      await _calendarController.addEventWithReminder(
        title: testEvent.title,
        date: testEvent.date,
        type: testEvent.type,
        reminderEnabled: testEvent.reminderEnabled,
        reminderDays: testEvent.reminderDays,
        reminderTime: testEvent.reminderTime,
      );

      print('✅ Calendar event with reminder created');
      print('   Event: ${testEvent.title}');
      print('   Date: ${testEvent.date}');
      print('   Reminder: ${testEvent.reminderDays} day(s) before at ${testEvent.reminderTime}');
      return true;
    } catch (e) {
      print('❌ Error creating calendar event: $e');
      return false;
    }
  }

  /// Test 7: Get pending notifications
  Future<bool> testPendingNotifications() async {
    print('🧪 Testing pending notifications...');
    
    try {
      final pending = await _notificationService.getPendingNotifications();
      print('✅ Found ${pending.length} pending notifications');
      
      for (int i = 0; i < pending.length; i++) {
        final notification = pending[i];
        print('   ${i + 1}. ID: ${notification.id}, Title: ${notification.title}');
      }
      
      return true;
    } catch (e) {
      print('❌ Error getting pending notifications: $e');
      return false;
    }
  }

  /// Test 8: Cancel all notifications
  Future<bool> testCancelAllNotifications() async {
    print('🧪 Testing cancel all notifications...');
    
    try {
      await _notificationService.cancelAllNotifications();
      print('✅ All notifications cancelled');
      return true;
    } catch (e) {
      print('❌ Error cancelling notifications: $e');
      return false;
    }
  }

  /// Run all tests
  Future<void> runAllTests() async {
    print('🚀 Starting comprehensive notification tests...\n');
    
    final results = <String, bool>{};
    
    // Test 1: Initialization
    results['Initialization'] = await testInitialization();
    print('');
    
    // Test 2: Permissions
    results['Permissions'] = await testPermissions();
    print('');
    
    // Test 3: Instant notification
    results['Instant Notification'] = await testInstantNotification();
    print('');
    
    // Test 4: Scheduled notification (10 seconds)
    results['10-Second Notification'] = await testScheduledNotification();
    print('');
    
    // Test 5: 1-minute notification
    results['1-Minute Notification'] = await testMinuteNotification();
    print('');
    
    // Test 6: Calendar event reminder
    results['Calendar Event Reminder'] = await testCalendarEventReminder();
    print('');
    
    // Test 7: Pending notifications
    results['Pending Notifications'] = await testPendingNotifications();
    print('');
    
    // Test 8: Cancel all (optional - comment out if you want to keep notifications)
    // results['Cancel All'] = await testCancelAllNotifications();
    // print('');
    
    // Print summary
    print('📊 Test Results Summary:');
    print('=' * 40);
    results.forEach((test, passed) {
      print('${passed ? '✅' : '❌'} $test: ${passed ? 'PASSED' : 'FAILED'}');
    });
    
    final passedCount = results.values.where((passed) => passed).length;
    final totalCount = results.length;
    print('=' * 40);
    print('Total: $passedCount/$totalCount tests passed');
    
    if (passedCount == totalCount) {
      print('🎉 All tests passed! Your notification system is working perfectly!');
    } else {
      print('⚠️  Some tests failed. Check the error messages above.');
    }
  }
}

/// Simple test UI widget for manual testing
class NotificationTestWidget extends StatefulWidget {
  const NotificationTestWidget({super.key});

  @override
  State<NotificationTestWidget> createState() => _NotificationTestWidgetState();
}

class _NotificationTestWidgetState extends State<NotificationTestWidget> {
  final NotificationTester _tester = NotificationTester();
  final List<String> _testResults = [];

  void _addResult(String test, bool passed) {
    setState(() {
      _testResults.add('${passed ? '✅' : '❌'} $test: ${passed ? 'PASSED' : 'FAILED'}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Tests'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Notification System Tests',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            // Test buttons
            ElevatedButton(
              onPressed: () async {
                _addResult('Initialization', await _tester.testInitialization());
              },
              child: const Text('Test Initialization'),
            ),
            const SizedBox(height: 10),
            
            ElevatedButton(
              onPressed: () async {
                _addResult('Permissions', await _tester.testPermissions());
              },
              child: const Text('Test Permissions'),
            ),
            const SizedBox(height: 10),
            
            ElevatedButton(
              onPressed: () async {
                _addResult('Instant Notification', await _tester.testInstantNotification());
              },
              child: const Text('Test Instant Notification'),
            ),
            const SizedBox(height: 10),
            
            ElevatedButton(
              onPressed: () async {
                _addResult('10-Second Notification', await _tester.testScheduledNotification());
              },
              child: const Text('Test 10-Second Notification'),
            ),
            const SizedBox(height: 10),
            
            ElevatedButton(
              onPressed: () async {
                _addResult('1-Minute Notification', await _tester.testMinuteNotification());
              },
              child: const Text('Test 1-Minute Notification'),
            ),
            const SizedBox(height: 10),
            
            ElevatedButton(
              onPressed: () async {
                _addResult('Calendar Event', await _tester.testCalendarEventReminder());
              },
              child: const Text('Test Calendar Event'),
            ),
            const SizedBox(height: 10),
            
            ElevatedButton(
              onPressed: () async {
                _addResult('Pending Notifications', await _tester.testPendingNotifications());
              },
              child: const Text('Check Pending Notifications'),
            ),
            const SizedBox(height: 20),
            
            // Run all tests button
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  _testResults.clear();
                });
                await _tester.runAllTests();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Run All Tests'),
            ),
            const SizedBox(height: 20),
            
            // Results
            const Text(
              'Test Results:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            
            Expanded(
              child: ListView.builder(
                itemCount: _testResults.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      _testResults[index],
                      style: const TextStyle(fontSize: 14),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
