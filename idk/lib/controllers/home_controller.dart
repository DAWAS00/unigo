import 'package:flutter/material.dart';

class HomeController extends ChangeNotifier {
  double completionRate = 82.0;
  int completedHours = 120;
  double gpa = 3.8;

  List<Map<String, String>> currentSemesterCourses = [
    {"title": "Digital Logic", "asset": "assets/DarkBlue.png", "route": ""},
    {"title": "Computer Graphics", "asset": "assets/DarkGreen.png", "route": ""},
    {"title": "Software Engineering", "asset": "assets/DarkYellow.png", "route": ""},
    {"title": "Simulation and Modeling", "asset": "assets/DarkRed.png", "route": ""},
    {"title": "GPA Calculator", "asset": "assets/DarkPurple.png", "route": "/gpa-calculator"},
  ];
}
