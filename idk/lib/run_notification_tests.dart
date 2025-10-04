import 'dart:io';
import 'test_notifications.dart';

/// Simple console script to run notification tests
/// Run this with: dart run lib/run_notification_tests.dart
void main() async {
  print('🚀 Starting Notification System Tests...\n');
  
  final tester = NotificationTester();
  await tester.runAllTests();
  
  print('\n✨ Test execution completed!');
  print('Check your device for notifications that should have appeared.');
  print('If you see the notifications, your system is working correctly! 🎉');
  
  // Keep the process alive for a moment to see results
  await Future.delayed(const Duration(seconds: 2));
  exit(0);
}
