import 'package:flutter/material.dart';
import '../models/course_grade.dart';
import '../models/gpa_calculation.dart';

class GPAService extends ChangeNotifier {
  double _currentGPA = 3.8; // Set a realistic initial GPA
  List<CourseGrade> _courses = [];
  GPACalculation _calculation = GPACalculation.empty();

  double get currentGPA => _currentGPA;
  List<CourseGrade> get courses => List.unmodifiable(_courses);
  GPACalculation get calculation => _calculation;

  void setCurrentGPA(double gpa) {
    _currentGPA = gpa;
    notifyListeners();
  }

  void addCourse(CourseGrade course) {
    _courses.add(course);
    notifyListeners();
  }

  void removeCourse(int index) {
    if (index >= 0 && index < _courses.length) {
      _courses.removeAt(index);
      notifyListeners();
    }
  }

  void clearCourses() {
    _courses.clear();
    notifyListeners();
  }

  void calculateGPA() {
    print('Calculating GPA with ${_courses.length} courses');
    
    if (_courses.isEmpty) {
      _currentGPA = 0.0;
      print('No courses, GPA set to 0.0');
      notifyListeners();
      return;
    }

    double totalGradePoints = 0.0;
    double totalCreditHours = 0.0;

    for (CourseGrade course in _courses) {
      print('Course: ${course.grade} - ${course.creditHours} credits - ${course.gradePoint} points');
      totalGradePoints += course.totalPoints;
      totalCreditHours += course.creditHours;
    }

    _currentGPA = totalCreditHours > 0 ? totalGradePoints / totalCreditHours : 0.0;
    print('Calculated GPA: $_currentGPA (${totalGradePoints} points / ${totalCreditHours} credits)');
    
    _calculation = GPACalculation(
      currentGPA: _currentGPA,
      newGPA: _currentGPA,
      courses: List.from(_courses),
      totalCreditHours: totalCreditHours,
      totalGradePoints: totalGradePoints,
    );

    notifyListeners();
  }

  double getGradePoint(String grade) {
    switch (grade.toUpperCase()) {
      case 'A+':
      case 'A':
        return 4.0;
      case 'A-':
        return 3.7;
      case 'B+':
        return 3.3;
      case 'B':
        return 3.0;
      case 'B-':
        return 2.7;
      case 'C+':
        return 2.3;
      case 'C':
        return 2.0;
      case 'C-':
        return 1.7;
      case 'D+':
        return 1.3;
      case 'D':
        return 1.0;
      case 'F':
        return 0.0;
      default:
        return -1; // Invalid grade
    }
  }

  bool isValidGrade(String grade) {
    return getGradePoint(grade) >= 0;
  }

  Map<String, double> getGradePointMap() {
    return {
      'A+': 4.0,
      'A': 4.0,
      'A-': 3.7,
      'B+': 3.3,
      'B': 3.0,
      'B-': 2.7,
      'C+': 2.3,
      'C': 2.0,
      'C-': 1.7,
      'D+': 1.3,
      'D': 1.0,
      'F': 0.0,
    };
  }
}
