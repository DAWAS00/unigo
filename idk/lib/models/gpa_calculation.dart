import 'course_grade.dart';

/// Model class that represents a complete GPA calculation result
/// Contains all the data needed to display GPA calculation results
class GPACalculation {
  /// The current GPA before adding new courses
  final double currentGPA;
  
  /// The calculated GPA after including all courses
  final double newGPA;
  
  /// List of all courses included in the calculation
  final List<CourseGrade> courses;
  
  /// Total credit hours from all courses
  final double totalCreditHours;
  
  /// Total grade points earned from all courses
  final double totalGradePoints;

  /// Constructor that creates a GPA calculation with all required data
  /// @param currentGPA The existing GPA before new courses
  /// @param newGPA The calculated GPA including all courses
  /// @param courses List of all courses in the calculation
  /// @param totalCreditHours Sum of all credit hours
  /// @param totalGradePoints Sum of all grade points
  GPACalculation({
    required this.currentGPA,
    required this.newGPA,
    required this.courses,
    required this.totalCreditHours,
    required this.totalGradePoints,
  });

  /// Factory constructor that creates an empty GPA calculation
  /// Used as a default or initial state when no calculation has been performed
  /// @return GPACalculation with all values set to 0 or empty
  factory GPACalculation.empty() {
    return GPACalculation(
      currentGPA: 0.0,
      newGPA: 0.0,
      courses: [],
      totalCreditHours: 0.0,
      totalGradePoints: 0.0,
    );
  }
}
