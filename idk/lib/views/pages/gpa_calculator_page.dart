import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/gpa_controller.dart';
import '../../services/toast_service.dart';
import '../widgets/gpa_card.dart';
import '../widgets/grade_point_table.dart';
import '../widgets/course_input_row.dart';

/// Main page widget for the GPA Calculator functionality
/// Provides a complete interface for calculating GPA with course inputs
class GPACalculatorPage extends StatelessWidget {
  const GPACalculatorPage({super.key});

  /// Builds the main UI for the GPA calculator page
  /// Creates a ChangeNotifierProvider for state management and builds the complete UI
  /// @param context The build context for the widget
  /// @return A Scaffold containing the complete GPA calculator interface
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GPAController(),
      child: Consumer<GPAController>(
        builder: (context, controller, _) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text(
                "GPA Calculator",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.black),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Current GPA Section
                  _buildCurrentGPASection(controller),
                  
                  const SizedBox(height: 30),
                  
                  // GPA Explanation Section
                  _buildGPAExplanationSection(controller),
                  
                  const SizedBox(height: 30),
                  
                  // Course Details Section
                  _buildCourseDetailsSection(controller),
                  
                  const SizedBox(height: 20),
                  
                  // Add New Subject Button
                  _buildAddNewSubjectButton(controller),
                  
                  const SizedBox(height: 30),
                  
                  // Calculate GPA Button
                  _buildCalculateGPAButton(controller, context),
                  
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  
  /// Builds the current GPA display section
  /// Shows the current GPA value in a card format with debug information
  /// @param controller The GPA controller instance for accessing current GPA data
  /// @return A Column widget containing the GPA display and debug info
  Widget _buildCurrentGPASection(GPAController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Current GPA',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        
        const SizedBox(height: 16),
        
        GPACard(
          title: 'GPA',
          value: controller.gpaService.currentGPA.toStringAsFixed(2),
        ),
        
        // Debug information (remove in production)
        const SizedBox(height: 10),
        Text(
          'Debug: ${controller.gpaService.currentGPA}',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
  
  /// Builds the expandable GPA explanation section
  /// Creates a collapsible container with GPA calculation formula and grade point table
  /// @param controller The GPA controller instance for managing explanation visibility
  /// @return A Container widget with expandable GPA explanation content
  Widget _buildGPAExplanationSection(GPAController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blue.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => controller.toggleExplanation(),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: Colors.blue,
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  'How GPA is Calculated',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const Spacer(),
                Icon(
                  controller.showExplanation ? Icons.expand_less : Icons.expand_more,
                  color: Colors.blue,
                ),
              ],
            ),
          ),
          
          if (controller.showExplanation) ...[
            const SizedBox(height: 16),
            
            const Text(
              'GPA (Grade Point Average) is calculated using this formula:',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            
            const SizedBox(height: 12),
            
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
              ),
              child: const Text(
                'GPA = Total Grade Points ÷ Total Credit Hours',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            const Text(
              'Grade Point Values:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Grade point table
            const GradePointTable(),
            
            const SizedBox(height: 16),
            
            const Text(
              'Example: If you get an A (4.0) in a 3-credit course, you earn 12.0 grade points (4.0 × 3).',
              style: TextStyle(
                fontSize: 13,
                color: Colors.black54,
                fontStyle: FontStyle.italic,
              ),
            ),
            
          ],
        ],
      ),
    );
  }
  
  /// Builds the course details input section
  /// Creates a table-like interface for entering grades and credit hours
  /// @param controller The GPA controller instance for accessing course data
  /// @return A Column widget containing course input headers and input rows
  Widget _buildCourseDetailsSection(GPAController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Course Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const Spacer(),
            Text(
              '${controller.courses.length}/7 subjects',
              style: TextStyle(
                fontSize: 14,
                color: controller.isMaxCoursesReached ? Colors.orange : Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Headers
        const Row(
          children: [
            Expanded(
              child: Text(
                'Grade',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                'Credit Hours',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Course Input Fields
        ...controller.courses.asMap().entries.map((entry) {
          int index = entry.key;
          return CourseInputRow(
            course: entry.value,
            index: index,
            onDelete: controller.courses.length > 1 
                ? () => controller.removeCourse(index) 
                : null,
          );
        }),
      ],
    );
  }
  
  /// Builds the "Add New Subject" button
  /// Creates a centered text button that adds a new course input row
  /// Button is disabled when maximum course limit (7) is reached
  /// @param controller The GPA controller instance for adding new courses
  /// @return A Center widget containing a TextButton for adding courses
  Widget _buildAddNewSubjectButton(GPAController controller) {
    return Center(
      child: Column(
        children: [
          TextButton(
            onPressed: controller.isMaxCoursesReached ? null : () => controller.addCourse(),
            child: Text(
              controller.isMaxCoursesReached ? 'Maximum 7 subjects reached' : 'Add New Subject',
              style: TextStyle(
                fontSize: 16,
                color: controller.isMaxCoursesReached ? Colors.grey : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (controller.isMaxCoursesReached)
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                'You can add up to 7 subjects for GPA calculation',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }
  
  /// Builds the "Calculate GPA" button
  /// Creates a styled elevated button that triggers GPA calculation
  /// @param controller The GPA controller instance for calculation
  /// @param context The build context for showing result dialog
  /// @return A Center widget containing an ElevatedButton for GPA calculation
  Widget _buildCalculateGPAButton(GPAController controller, BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => _calculateGPA(controller, context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Calculate GPA',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
  
  /// Handles the GPA calculation process and shows toast notification
  /// Triggers the calculation in the controller and displays the result as a toast
  /// @param controller The GPA controller instance for calculation
  /// @param context The build context for showing the toast notification
  void _calculateGPA(GPAController controller, BuildContext context) {
    controller.calculateGPA();
    
    // Show toast notification with GPA result
    ToastService.showGPACalculation(
      context,
      gpa: controller.gpaService.currentGPA,
    );
  }
}
