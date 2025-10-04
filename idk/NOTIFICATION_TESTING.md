# Notification Testing Guide

This guide explains how to test the notification system in your Flutter app.

## 🧪 Test Options

### Option 1: In-App Testing (Recommended)
1. Run your Flutter app: `flutter run`
2. Navigate to the Calendar page (3rd tab)
3. Scroll down to the "Reminders" section
4. You'll see several test buttons:
   - **Instant Test**: Shows a notification immediately
   - **10s Test**: Creates an event that triggers a notification in 10 seconds
   - **🧪 Full Notification Tests**: Opens a comprehensive test page

### Option 2: Comprehensive Test Page
1. In the Calendar page, tap the "🧪 Full Notification Tests" button
2. This opens a dedicated test page with individual test buttons:
   - Test Initialization
   - Test Permissions
   - Test Instant Notification
   - Test 10-Second Notification
   - Test 1-Minute Notification
   - Test Calendar Event
   - Check Pending Notifications
   - **Run All Tests** (runs everything at once)

### Option 3: Console Testing
1. Run the console test script:
   ```bash
   dart run lib/run_notification_tests.dart
   ```
2. This will run all tests and show results in the console

## 🔧 What Each Test Does

### Instant Test
- Shows a notification immediately
- Tests basic notification display functionality
- Good for quick verification

### 10-Second Test
- Creates a calendar event
- Schedules a notification for 10 seconds later
- Tests scheduled notification functionality

### 1-Minute Test
- Schedules a notification for 1 minute later
- Tests longer-term scheduling
- Good for testing while doing other things

### Calendar Event Test
- Creates a calendar event with reminder enabled
- Tests the full calendar integration
- Verifies reminder scheduling works with events

### Permission Test
- Checks if notification permissions are granted
- Requests permissions if needed
- Essential for notifications to work

## 📱 Expected Behavior

When tests run successfully, you should see:
1. **Console output** with ✅ or ❌ indicators
2. **Notifications appearing** on your device
3. **Test results** showing which tests passed/failed

## 🚨 Troubleshooting

### No Notifications Appearing?
1. Check if notification permissions are granted
2. Make sure your device isn't in "Do Not Disturb" mode
3. Verify the app is running in the foreground/background
4. Check console output for error messages

### Permission Issues?
- The app will automatically request permissions
- On Android, you might need to manually enable notifications in Settings
- On iOS, check Settings > Notifications > [Your App]

### Test Failures?
- Check the console output for specific error messages
- Ensure all dependencies are properly installed
- Make sure the notification service is initialized

## 🎯 Quick Start

**Fastest way to test:**
1. Run `flutter run`
2. Go to Calendar page
3. Tap "Instant Test" button
4. You should see a notification immediately!

**Comprehensive testing:**
1. Run `flutter run`
2. Go to Calendar page
3. Tap "🧪 Full Notification Tests"
4. Tap "Run All Tests"
5. Wait and watch for notifications!

## 📋 Test Checklist

- [ ] Instant notification appears
- [ ] 10-second notification appears after 10 seconds
- [ ] 1-minute notification appears after 1 minute
- [ ] Calendar events show reminder icons
- [ ] Permission requests work properly
- [ ] Console shows all tests passing

## 🎉 Success!

If you see notifications appearing and tests passing, your notification system is working perfectly! The calendar reminders, event notifications, and all notification features should work as expected.
