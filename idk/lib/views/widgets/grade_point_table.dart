import 'package:flutter/material.dart';

class GradePointTable extends StatelessWidget {
  const GradePointTable({super.key});

  @override
  Widget build(BuildContext context) {
    final gradePoints = [
      {'grade': 'A+', 'points': '4.0', 'color': Colors.green[600]!},
      {'grade': 'A', 'points': '4.0', 'color': Colors.green[500]!},
      {'grade': 'A-', 'points': '3.7', 'color': Colors.green[400]!},
      {'grade': 'B+', 'points': '3.3', 'color': Colors.blue[500]!},
      {'grade': 'B', 'points': '3.0', 'color': Colors.blue[400]!},
      {'grade': 'B-', 'points': '2.7', 'color': Colors.blue[300]!},
      {'grade': 'C+', 'points': '2.3', 'color': Colors.orange[500]!},
      {'grade': 'C', 'points': '2.0', 'color': Colors.orange[400]!},
      {'grade': 'C-', 'points': '1.7', 'color': Colors.orange[300]!},
      {'grade': 'D+', 'points': '1.3', 'color': Colors.red[400]!},
      {'grade': 'D', 'points': '1.0', 'color': Colors.red[500]!},
      {'grade': 'F', 'points': '0.0', 'color': Colors.red[600]!},
    ];
    
    return Column(
      children: gradePoints.map((gradeInfo) {
        return Container(
          margin: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 30,
                decoration: BoxDecoration(
                  color: gradeInfo['color'] as Color,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    gradeInfo['grade'] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '= ${gradeInfo['points']} points',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
