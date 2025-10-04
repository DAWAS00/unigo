import '../models/student_model.dart';

class ProfileController {
  Student getStudent() {
    return Student(
      name: "Student Name",
      university: "University of Jordan, Amman",
      department: "Computer Science",
      paymentNumber: "194526370",
      email: "student123@ju.edu.jo",
      advisor: "Dr. Anas Dhoury",
      locationDob: "Amman, JO | 13-Feb-2003",
      profileImage: "https://i.pravatar.cc/150?img=47",
    );
  }
}
