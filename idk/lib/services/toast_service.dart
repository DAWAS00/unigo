import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

/// Service class for managing toast notifications throughout the app
/// Provides easy-to-use methods for different types of notifications
class ToastService {
  /// Shows a success toast notification
  /// @param context The build context
  /// @param title The main title of the notification
  /// @param description Optional description text
  /// @param duration How long the toast should be displayed
  static void showSuccess(
    BuildContext context, {
    required String title,
    String? description,
    Duration duration = const Duration(seconds: 4),
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.fillColored,
      title: Text(title),
      description: description != null ? Text(description) : null,
      alignment: Alignment.topRight,
      direction: TextDirection.ltr,
      autoCloseDuration: duration,
      animationDuration: const Duration(milliseconds: 300),
      icon: const Icon(Icons.check_circle, color: Colors.white),
      primaryColor: Colors.green,
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        )
      ],
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
      callbacks: ToastificationCallbacks(
        onTap: (toastItem) => print('Toast clicked'),
        onCloseButtonTap: (toastItem) => print('Toast close button tapped'),
        onAutoCompleteCompleted: (toastItem) => print('Toast auto complete completed'),
        onDismissed: (toastItem) => print('Toast dismissed'),
      ),
    );
  }

  /// Shows an info toast notification
  /// @param context The build context
  /// @param title The main title of the notification
  /// @param description Optional description text
  /// @param duration How long the toast should be displayed
  static void showInfo(
    BuildContext context, {
    required String title,
    String? description,
    Duration duration = const Duration(seconds: 4),
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.info,
      style: ToastificationStyle.fillColored,
      title: Text(title),
      description: description != null ? Text(description) : null,
      alignment: Alignment.topRight,
      direction: TextDirection.ltr,
      autoCloseDuration: duration,
      animationDuration: const Duration(milliseconds: 300),
      icon: const Icon(Icons.info, color: Colors.white),
      primaryColor: Colors.blue,
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        )
      ],
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
    );
  }

  /// Shows a warning toast notification
  /// @param context The build context
  /// @param title The main title of the notification
  /// @param description Optional description text
  /// @param duration How long the toast should be displayed
  static void showWarning(
    BuildContext context, {
    required String title,
    String? description,
    Duration duration = const Duration(seconds: 4),
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.warning,
      style: ToastificationStyle.fillColored,
      title: Text(title),
      description: description != null ? Text(description) : null,
      alignment: Alignment.topRight,
      direction: TextDirection.ltr,
      autoCloseDuration: duration,
      animationDuration: const Duration(milliseconds: 300),
      icon: const Icon(Icons.warning, color: Colors.white),
      primaryColor: Colors.orange,
      backgroundColor: Colors.orange,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        )
      ],
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
    );
  }

  /// Shows an error toast notification
  /// @param context The build context
  /// @param title The main title of the notification
  /// @param description Optional description text
  /// @param duration How long the toast should be displayed
  static void showError(
    BuildContext context, {
    required String title,
    String? description,
    Duration duration = const Duration(seconds: 4),
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.fillColored,
      title: Text(title),
      description: description != null ? Text(description) : null,
      alignment: Alignment.topRight,
      direction: TextDirection.ltr,
      autoCloseDuration: duration,
      animationDuration: const Duration(milliseconds: 300),
      icon: const Icon(Icons.error, color: Colors.white),
      primaryColor: Colors.red,
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        )
      ],
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
    );
  }

  /// Shows a class reminder notification
  /// @param context The build context
  /// @param className The name of the class
  /// @param time The time of the class
  /// @param location Optional location of the class
  static void showClassReminder(
    BuildContext context, {
    required String className,
    required String time,
    String? location,
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.info,
      style: ToastificationStyle.fillColored,
      title: Text('Next Class: $className'),
      description: Text(
        'Time: $time${location != null ? '\nLocation: $location' : ''}',
      ),
      alignment: Alignment.topRight,
      direction: TextDirection.ltr,
      autoCloseDuration: const Duration(seconds: 6),
      animationDuration: const Duration(milliseconds: 300),
      icon: const Icon(Icons.school, color: Colors.white),
      primaryColor: Colors.purple,
      backgroundColor: Colors.purple,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        )
      ],
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
    );
  }

  /// Shows a reminder notification
  /// @param context The build context
  /// @param title The reminder title
  /// @param description The reminder description
  /// @param isCompleted Whether the reminder is completed
  static void showReminder(
    BuildContext context, {
    required String title,
    required String description,
    bool isCompleted = false,
  }) {
    if (isCompleted) {
      showSuccess(
        context,
        title: 'Reminder Completed!',
        description: title,
        duration: const Duration(seconds: 3),
      );
    } else {
      toastification.show(
        context: context,
        type: ToastificationType.warning,
        style: ToastificationStyle.fillColored,
        title: Text('Reminder: $title'),
        description: Text(description),
        alignment: Alignment.topRight,
        direction: TextDirection.ltr,
        autoCloseDuration: const Duration(seconds: 5),
        animationDuration: const Duration(milliseconds: 300),
        icon: const Icon(Icons.notifications, color: Colors.white),
        primaryColor: Colors.amber,
        backgroundColor: Colors.amber,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x07000000),
            blurRadius: 16,
            offset: Offset(0, 16),
            spreadRadius: 0,
          )
        ],
        showProgressBar: true,
        closeButtonShowType: CloseButtonShowType.onHover,
        closeOnClick: false,
        pauseOnHover: true,
        dragToClose: true,
        applyBlurEffect: true,
      );
    }
  }

  /// Shows a GPA calculation success notification
  /// @param context The build context
  /// @param gpa The calculated GPA
  static void showGPACalculation(
    BuildContext context, {
    required double gpa,
  }) {
    String grade = _getGPAGrade(gpa);
    Color color = _getGPAColor(gpa);
    
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.fillColored,
      title: Text('GPA Calculated: ${gpa.toStringAsFixed(2)}'),
      description: Text('Grade: $grade'),
      alignment: Alignment.topRight,
      direction: TextDirection.ltr,
      autoCloseDuration: const Duration(seconds: 4),
      animationDuration: const Duration(milliseconds: 300),
      icon: const Icon(Icons.calculate, color: Colors.white),
      primaryColor: color,
      backgroundColor: color,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        )
      ],
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
    );
  }

  /// Gets the appropriate color for the GPA value
  /// @param gpa The GPA value
  /// @return Color based on GPA range
  static Color _getGPAColor(double gpa) {
    if (gpa >= 3.7) return Colors.green;
    if (gpa >= 3.0) return Colors.blue;
    if (gpa >= 2.0) return Colors.orange;
    return Colors.red;
  }

  /// Gets the letter grade equivalent for the GPA
  /// @param gpa The GPA value
  /// @return String representing the letter grade
  static String _getGPAGrade(double gpa) {
    if (gpa >= 3.7) return 'Excellent';
    if (gpa >= 3.0) return 'Good';
    if (gpa >= 2.0) return 'Satisfactory';
    return 'Needs Improvement';
  }

  /// Dismisses all currently visible toasts
  /// @param context The build context
  static void dismissAll(BuildContext context) {
    toastification.dismissAll();
  }
}
