# CLAUDE.md — University IT Student App

## Project Overview

**App Name:** University IT Student (internal bundle: `idk`)
**Type:** Flutter cross-platform mobile application
**Version:** 1.0.0+1
**Purpose:** A student information and academic management system for university students — covering courses, grades, GPA calculation, calendar, notifications, and profile management.

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter 3.x (Dart SDK ^3.9.2) |
| State Management | Provider ^6.1.2 |
| Notifications | flutter_local_notifications ^17.2.3 |
| Scheduling | timezone ^0.9.2 |
| Permissions | permission_handler ^11.3.1 |
| Toast UI | toastification ^2.0.0 |
| Icons | cupertino_icons ^1.0.8 |
| Linting | flutter_lints ^5.0.0 |

---

## Architecture

MVC-like pattern with Provider for state management.

```
lib/
├── main.dart                    # Entry point, named routes, global navigator key
├── controllers/                 # Business logic & state (ChangeNotifier)
├── models/                      # Data classes
├── services/                    # Low-level logic (notifications, GPA math)
└── views/
    ├── pages/                   # Full screen pages (17 screens)
    └── widgets/                 # Reusable UI components (31 widgets)
```

### Controllers (15 total)
| Controller | Responsibility |
|-----------|---------------|
| `home_controller.dart` | Dashboard state |
| `courses_controller.dart` | Enrolled courses list |
| `register_courses_controller.dart` | Course registration flow |
| `withdraw_courses_controller.dart` | Course withdrawal flow |
| `completed_courses_controller.dart` | Completed courses history |
| `gpa_controller.dart` | GPA calculation state (max 7 subjects) |
| `grades_controller.dart` | Grades display |
| `absences_controller.dart` | Attendance/absences tracking |
| `calendar_controller.dart` | Calendar events |
| `notification_controller.dart` | Notification scheduling |
| `profile_controller.dart` | Student profile |
| `personal_info_controller.dart` | Personal info form |
| `academic_plan_controller.dart` | Academic plan view |
| `inquiry_subjects_controller.dart` | Subject inquiry/search |
| `reserve_time_controller.dart` | Time slot reservations |

### Services (4 total)
| Service | Responsibility |
|---------|---------------|
| `notification_service.dart` | Low-level notification API wrapper |
| `enhanced_notification_service.dart` | Extended notification features |
| `gpa_service.dart` | GPA calculation math |
| `reminder_service.dart` | Calendar event reminder logic |

---

## Features

### Core Screens (17 pages)
1. **Home** (`home_page.dart`) — Dashboard with student stats and current semester courses
2. **Courses** (`courses_page.dart`) — View enrolled courses
3. **Register Courses** (`register_courses_page.dart`) — Register for new courses
4. **Withdraw Courses** (`withdraw_courses_page.dart`) — Drop courses
5. **Completed Courses** (`completed_courses_page.dart`) — Transcript/history
6. **GPA Calculator** (`gpa_calculator_page.dart`, `gpa_calc_page.dart`) — Interactive GPA tool
7. **Grades** (`grades_page.dart`) — View grade records
8. **Absences** (`absences_page.dart`) — Attendance monitoring
9. **Calendar** (`calendar_page.dart`) — Schedule and events with reminders
10. **Profile** (`profile_page.dart`) — Student profile view
11. **Personal Info** (`personal_info_page.dart`) — Contact and biographical details
12. **Academic Plan** (`academic_plan_page.dart`) — Degree plan overview
13. **Course Inquiry** (`inquiry_subjects_page.dart`) — Search available subjects
14. **Reserve Time** (`reserve_time_page.dart`) — Book time slots
15. **Print Schedule** (`print_schedule_page.dart`) — Generate printable schedule
16. **Add Subjects** (`add_subjects_page.dart`) — Add subjects to GPA calculator

### GPA Calculator Rules
- Accepts **up to 7 subjects** maximum
- Grade scale: A+ / A / A- / B+ / B / B- / C+ / C / D+ / D / F
- Computes current GPA vs. projected GPA
- Grade point reference table available in `grade_point_table.dart`

### Notification System
- Instant, 10-second, and 1-minute test notifications
- Calendar event reminders (configurable days before + time of day)
- Permission handling for Android (POST_NOTIFICATIONS) and iOS
- Timezone-aware scheduling via `timezone` package
- Global navigator key in `main.dart` for background notification taps
- Testing guide: `NOTIFICATION_TESTING.md`

---

## Navigation

- **Bottom navigation bar** — 4 tabs using `IndexedStack`:
  - Home
  - Courses
  - Calendar
  - Profile
- **Named routes** for all secondary pages (defined in `main.dart`)
- **Global navigator key** (`GlobalKey<NavigatorState>`) for programmatic navigation from notification handlers

---

## UI Design System

**Theme:** Glassmorphism (frosted glass aesthetic)

### Glass Widgets (in `lib/views/widgets/`)
| Widget | Use |
|--------|-----|
| `glass_appbar.dart` | Frosted glass navigation bar |
| `glass_card.dart` | Standard glass card container |
| `glass_card_custom.dart` | Customizable glass card |
| `glass_info_card.dart` | Info display card |
| `glass_input_box.dart` | Input field with glass style |
| `glass_text_field.dart` | Text field variant |

### Design Principles
- `BackdropFilter` with blur for glass effect
- Semi-transparent backgrounds with gradient overlays
- Rounded corners (`BorderRadius`)
- `BouncingScrollPhysics` for iOS-like scroll feel
- Material Design base with custom glassmorphic overlay

---

## Data Models

| Model | Key Fields |
|-------|-----------|
| `StudentModel` | name, university, department, paymentNumber, email, advisor, dob, profileImage |
| `CourseModel` | title, assetPath |
| `CourseGrade` | grade (letter), creditHours, gradePoint, totalPoints |
| `CourseRegistration` | registration details |
| `Subject` | subject info |
| `GPACalculation` | currentGPA, newGPA, courses, totalCreditHours, totalGradePoints |
| `CalendarEvent` | title, date, type, reminderEnabled, reminderDays, reminderTime |
| `NotificationModel` | id, eventId, scheduledTime, delivered, title, body, payload |
| `PersonalInfo` | contact and biographical data |
| `Reservation` | time slot details |

---

## Key Files Reference

| File | Purpose |
|------|---------|
| `lib/main.dart` | App entry, route table, global nav key, Provider setup |
| `lib/controllers/gpa_controller.dart` | GPA state + 7-subject limit enforcement |
| `lib/controllers/notification_controller.dart` | Notification scheduling controller |
| `lib/services/notification_service.dart` | flutter_local_notifications wrapper |
| `lib/services/gpa_service.dart` | Grade point conversion + GPA math |
| `lib/views/pages/gpa_calculator_page.dart` | GPA calculator UI |
| `lib/views/pages/home_page.dart` | Main dashboard screen |
| `lib/models/calendar_event.dart` | Calendar event with reminder config |
| `lib/models/course_grade.dart` | Course with grade point calculation |
| `NOTIFICATION_TESTING.md` | Notification test procedures and checklist |

---

## Platform Support

| Platform | Status |
|----------|--------|
| Android | Supported |
| iOS | Supported |
| Windows | Supported |
| macOS | Supported |
| Linux | Supported |
| Web | Supported |

---

## Development Notes

- The app bundle/package name is `idk` — this is the internal Flutter project name
- `pubspec.yaml` is located at `idk/pubspec.yaml` (project root is the `idk/` folder)
- All `flutter pub` and `flutter run` commands should be run from inside `idk/`
- Linting rules are in `analysis_options.yaml`
- Dev tools config: `devtools_options.yaml`

---

## Next Steps / Roadmap

> Update this section as new features are planned or completed.

- [ ] TBD — future features to be decided with the user
