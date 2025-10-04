import 'package:flutter/material.dart';
import '../../controllers/profile_controller.dart';
import '../../models/student_model.dart';
import '../widgets/glass_appbar.dart';
import '../widgets/glass_card.dart';
import 'personal_info_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ProfileController();
    final Student student = controller.getStudent();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const GlassAppBar(title: "Profile"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(student.profileImage),
            ),
            const SizedBox(height: 12),
            Text(
              student.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              "${student.university},\n${student.department}",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 28),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Basic Information",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 12),

            GlassCard(
                title: "Payment Number",
                value: student.paymentNumber,
                isRectangular: true),
            GlassCard(
                title: "University Email",
                value: student.email,
                isRectangular: true),
            GlassCard(
                title: "Academic Advisor",
                value: student.advisor,
                isRectangular: true),
            GlassCard(
                title: "Location / DOB",
                value: student.locationDob,
                isRectangular: true),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const PersonalInfoPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 6,
                  shadowColor: Colors.black26,
                ),
                child: const Text(
                  "Student’s Personal Information",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
