import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/gpa_controller.dart';
import '../widgets/gpa_card.dart';
import '../widgets/grade_point_table.dart';
import '../widgets/course_input_row.dart';

class GPACalculatorPage extends StatelessWidget {
  const GPACalculatorPage({super.key});

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
  
  Widget _buildCourseDetailsSection(GPAController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Course Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
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
  
  Widget _buildAddNewSubjectButton(GPAController controller) {
    return Center(
      child: TextButton(
        onPressed: () => controller.addCourse(),
        child: const Text(
          'Add New Subject',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
  
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
  
  void _calculateGPA(GPAController controller, BuildContext context) {
    controller.calculateGPA();
    
    // Show result dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('GPA Calculation Result'),
          content: Text(
            'New GPA: ${controller.gpaService.currentGPA.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
