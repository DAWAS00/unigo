import 'package:flutter/material.dart';
import '../services/gpa_service.dart';
import '../models/course_grade.dart';

class GPAController extends ChangeNotifier {
  final GPAService _gpaService = GPAService();
  final List<CourseInput> _courses = [CourseInput()];
  bool _showExplanation = false;

  GPAController() {
    // Add some sample courses for demonstration
    _addSampleCourses();
    // Calculate initial GPA with sample data
    _calculateInitialGPA();
  }

  void _addSampleCourses() {
    // Add a few sample courses to make the calculator more useful
    final sampleCourses = [
      {"grade": "A", "credits": "3"},
      {"grade": "B+", "credits": "4"},
      {"grade": "A-", "credits": "3"},
    ];
    
    for (var course in sampleCourses) {
      final courseInput = CourseInput();
      courseInput.gradeController.text = course["grade"]!;
      courseInput.creditHoursController.text = course["credits"]!;
      _courses.add(courseInput);
    }
  }

  void _calculateInitialGPA() {
    // Calculate GPA with the sample courses
    _gpaService.clearCourses();
    
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
    
    _gpaService.calculateGPA();
    notifyListeners(); // Ensure UI updates
  }

  GPAService get gpaService => _gpaService;
  List<CourseInput> get courses => List.unmodifiable(_courses);
  bool get showExplanation => _showExplanation;

  void toggleExplanation() {
    _showExplanation = !_showExplanation;
    notifyListeners();
  }

  void addCourse() {
    _courses.add(CourseInput());
    notifyListeners();
  }

  void removeCourse(int index) {
    if (_courses.length > 1 && index >= 0 && index < _courses.length) {
      _courses[index].dispose();
      _courses.removeAt(index);
      notifyListeners();
    }
  }

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

  void setCurrentGPA(double gpa) {
    _gpaService.setCurrentGPA(gpa);
    notifyListeners();
  }

  @override
  void dispose() {
    for (CourseInput course in _courses) {
      course.dispose();
    }
    super.dispose();
  }
}

class CourseInput {
  final TextEditingController gradeController = TextEditingController();
  final TextEditingController creditHoursController = TextEditingController();
  
  void dispose() {
    gradeController.dispose();
    creditHoursController.dispose();
  }
}
