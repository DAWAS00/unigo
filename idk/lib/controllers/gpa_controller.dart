import 'package:flutter/material.dart';
import '../services/gpa_service.dart';
import '../models/course_grade.dart';

/// Controller class that manages GPA calculation state and business logic
/// Extends ChangeNotifier to provide reactive state management for the UI
class GPAController extends ChangeNotifier {
  final GPAService _gpaService = GPAService();
  final List<CourseInput> _courses = [CourseInput()];
  bool _showExplanation = false;

  /// Constructor that initializes the GPA controller
  /// Starts with one empty course input for user to begin entering data
  GPAController() {
    // Start with one empty course input
    // No sample courses added by default
  }

  /// Getter that provides access to the GPA service instance
  /// Returns the private _gpaService for external access
  GPAService get gpaService => _gpaService;
  
  /// Getter that returns an unmodifiable list of course inputs
  /// Prevents external modification of the courses list
  List<CourseInput> get courses => List.unmodifiable(_courses);
  
  /// Getter that returns the current state of the explanation visibility
  /// Used to control whether the GPA explanation section is expanded
  bool get showExplanation => _showExplanation;
  
  /// Getter that checks if the maximum course limit has been reached
  /// Returns true when 7 courses have been added (maximum allowed)
  bool get isMaxCoursesReached => _courses.length >= 7;

  /// Toggles the visibility of the GPA explanation section
  /// Changes the _showExplanation state and notifies listeners for UI updates
  void toggleExplanation() {
    _showExplanation = !_showExplanation;
    notifyListeners();
  }

  /// Adds a new empty course input to the courses list
  /// Creates a new CourseInput object and notifies listeners for UI updates
  /// Maximum limit of 7 courses to prevent excessive calculations
  void addCourse() {
    if (_courses.length < 7) {
      _courses.add(CourseInput());
      notifyListeners();
    }
  }

  /// Removes a course input from the courses list at the specified index
  /// Ensures at least one course remains and properly disposes of the removed course
  /// @param index The index of the course to remove
  void removeCourse(int index) {
    if (_courses.length > 1 && index >= 0 && index < _courses.length) {
      _courses[index].dispose();
      _courses.removeAt(index);
      notifyListeners();
    }
  }

  /// Calculates the GPA based on all course inputs
  /// Clears existing courses, processes all valid course inputs, and calculates new GPA
  /// Only processes courses with valid grades and credit hours
  void calculateGPA() {
    // Clear existing courses
    _gpaService.clearCourses();
    
    // Add new courses to the service
    for (CourseInput course in _courses) {
      String grade = course.gradeController.text.trim().toUpperCase();
      String creditHoursText = course.creditHoursController.text.trim();
      
      if (grade.isNotEmpty && creditHoursText.isNotEmpty) {
        double gradePoint = _gpaService.getGradePoint(grade);
        double creditHours = double.tryParse(creditHoursText) ?? 0;
        
        if (gradePoint >= 0 && creditHours > 0) {
          _gpaService.addCourse(CourseGrade.fromInput(grade, creditHours, gradePoint));
        }
      }
    }
    
    // Calculate GPA using the service
    _gpaService.calculateGPA();
    notifyListeners();
  }

  /// Sets the current GPA value in the GPA service
  /// Used to input an existing GPA before calculating with new courses
  /// @param gpa The GPA value to set
  void setCurrentGPA(double gpa) {
    _gpaService.setCurrentGPA(gpa);
    notifyListeners();
  }

  /// Override of dispose method to clean up resources
  /// Disposes of all course input controllers to prevent memory leaks
  @override
  void dispose() {
    for (CourseInput course in _courses) {
      course.dispose();
    }
    super.dispose();
  }
}

/// Helper class that manages individual course input data
/// Contains text controllers for grade and credit hours input
class CourseInput {
  /// Text controller for managing grade input field
  final TextEditingController gradeController = TextEditingController();
  
  /// Text controller for managing credit hours input field
  final TextEditingController creditHoursController = TextEditingController();
  
  /// Disposes of the text controllers to free up memory
  /// Should be called when the course input is no longer needed
  void dispose() {
    gradeController.dispose();
    creditHoursController.dispose();
  }
}
