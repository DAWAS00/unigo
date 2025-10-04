import 'package:flutter/material.dart';
import '../../controllers/gpa_controller.dart';

class CourseInputRow extends StatelessWidget {
  final CourseInput course;
  final int index;
  final VoidCallback? onDelete;

  const CourseInputRow({
    super.key,
    required this.course,
    required this.index,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          // Grade Input
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextFormField(
                controller: course.gradeController,
                decoration: const InputDecoration(
                  hintText: 'A, B+, C-...',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Credit Hours Input
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextFormField(
                controller: course.creditHoursController,
                decoration: const InputDecoration(
                  hintText: '3, 4, 2...',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ),
          
          // Delete button (only show if more than one course)
          if (onDelete != null) ...[
            const SizedBox(width: 8),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete, color: Colors.red),
            ),
          ],
        ],
      ),
    );
  }
}
