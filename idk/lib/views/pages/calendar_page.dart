import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/calendar_controller.dart';
import '../../models/calendar_event.dart';
import '../../services/toast_service.dart';
import '../../services/enhanced_notification_service.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final controller = CalendarController();
        // Initialize reminders when controller is created
        controller.initializeReminders();
        return controller;
      },
      child: const _CalendarScaffold(),
    );
  }
}

class _CalendarScaffold extends StatelessWidget {
  const _CalendarScaffold();

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CalendarController>(context);

    final daysCount = controller.daysInMonth(controller.currentMonth);
    final startOffset = controller.mondayBasedWeekday(controller.currentMonth);
    final selectedDate = controller.dateFor(controller.selectedDay);
    final leftDayName = CalendarController.weekdays[selectedDate.weekday % 7];
    final leftMonthName = CalendarController.months[controller.currentMonth.month - 1];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Calendar",
          style: TextStyle(
            fontFamily: "AnekTelugu",
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // ======= Glass Calendar Card =======
            _glass(
              child: SizedBox(
                height: 300,
                child: Row(
                  children: [
                    // LEFT: Day / Date / Month
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              leftDayName,
                              style: const TextStyle(
                                fontFamily: "AnekTelugu",
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "${controller.selectedDay}",
                              style: const TextStyle(
                                fontFamily: "AnekTelugu",
                                fontSize: 38,
                                fontWeight: FontWeight.w800,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              leftMonthName,
                              style: const TextStyle(
                                fontFamily: "AnekTelugu",
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Divider
                    Container(
                      width: 1.5,
                      margin: const EdgeInsets.symmetric(vertical: 44),
                      color: Colors.black.withValues(alpha: 0.08),
                    ),

                    // RIGHT: Calendar
                    Expanded(
                      flex: 7,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 18, 16, 20),
                        child: Column(
                          children: [
                            // Weekday initials
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: GridView.count(
                                shrinkWrap: true,
                                crossAxisCount: 7,
                                physics: const NeverScrollableScrollPhysics(),
                                children: const [
                                  _WD('S'),
                                  _WD('M'),
                                  _WD('T'),
                                  _WD('W'),
                                  _WD('T'),
                                  _WD('F'),
                                  _WD('S'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Calendar grid
                            SizedBox(
                              height: 175,
                              child: GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.only(left: 6),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 7,
                                  mainAxisSpacing: 13,
                                  crossAxisSpacing: 10,
                                ),
                                itemCount: startOffset + daysCount,
                                itemBuilder: (context, i) {
                                  if (i < startOffset) return const SizedBox.shrink();
                                  final day = i - startOffset + 1;
                                  final date = DateTime(
                                    controller.currentMonth.year,
                                    controller.currentMonth.month,
                                    day,
                                  );
                                  final isSelected = day == controller.selectedDay;
                                  final dayEvents = controller.eventsForDate(date);

                                  return GestureDetector(
                                    onTap: () => controller.selectDay(day),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        if (isSelected)
                                          Container(
                                            decoration: const BoxDecoration(
                                              color: Colors.black87,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        Text(
                                          "$day",
                                          style: TextStyle(
                                            fontFamily: "AnekTelugu",
                                            fontSize: 15,
                                            fontWeight: isSelected
                                                ? FontWeight.w800
                                                : FontWeight.w600,
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.black87,
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: dayEvents.take(3).map(
                                              (e) {
                                                return Container(
                                                  width: 4,
                                                  height: 4,
                                                  margin: const EdgeInsets.symmetric(horizontal: 0.5),
                                                  decoration: BoxDecoration(
                                                    color: controller.dotColor(e.type),
                                                    shape: BoxShape.circle,
                                                  ),
                                                );
                                              },
                                            ).toList(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 10),

                            // Month nav
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _glassIconButton(
                                  icon: Icons.chevron_left,
                                  onTap: () => controller.changeMonth(-1),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "${CalendarController.months[controller.currentMonth.month - 1]} ${controller.currentMonth.year}",
                                  style: const TextStyle(
                                    fontFamily: "AnekTelugu",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                _glassIconButton(
                                  icon: Icons.chevron_right,
                                  onTap: () => controller.changeMonth(1),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            _glass(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tabs
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _bigTab("Events", controller),
                        const SizedBox(width: 10),
                        _bigTab("Reminders", controller),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // FILTER
                    Row(
                      children: [
                        _glassIconButton(
                          icon: Icons.filter_list_rounded,
                          onTap: () => controller.toggleFilterMenu(),
                          size: 36,
                        ),
                        Expanded(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            child: controller.showFilterMenu
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: _glass(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            _filterListItem("All", controller),
                                            _filterListItem("Event", controller,
                                                swatch: controller.dotColor("Event")),
                                            _filterListItem("Deadline", controller,
                                                swatch: controller.dotColor("Deadline")),
                                            _filterListItem("Reminder", controller,
                                                swatch: controller.dotColor("Reminder")),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    if (controller.selectedTab == "Events")
                      ..._buildEventCards(controller)
                    else
                      ..._buildReminderCards(controller, context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<Widget> _buildEventCards(CalendarController controller) {
  final today = controller.today;
  final twoWeeksFromNow = today.add(const Duration(days: 14));
  final tappedDate = controller.dateFor(controller.selectedDay);

  final filtered = controller.events.where((e) {
    final date = e.date;

    if (controller.selectedFilter != "All" && e.type != controller.selectedFilter) {
      return false;
    }

    final isFocused = !(tappedDate.year == today.year &&
        tappedDate.month == today.month &&
        tappedDate.day == today.day);

    if (isFocused) {
      return date.year == tappedDate.year &&
          date.month == tappedDate.month &&
          date.day == tappedDate.day;
    }

    return date.isAfter(today.subtract(const Duration(days: 1))) &&
        date.isBefore(twoWeeksFromNow);
  }).toList();

  if (filtered.isEmpty) {
    return [
      const Padding(
        padding: EdgeInsets.only(left: 6),
        child: Text(
          "No events to show.",
          style: TextStyle(
            fontFamily: "AnekTelugu",
            fontSize: 13,
            color: Colors.black54,
          ),
        ),
      ),
    ];
  }

  return filtered.map((e) {
    final color = controller.dotColor(e.type);
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: _glass(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              e.title,
                              style: const TextStyle(
                                fontFamily: "AnekTelugu",
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          if (e.reminderEnabled) ...[
                            const SizedBox(width: 8),
                            Icon(
                              Icons.notifications_active,
                              size: 16,
                              color: Colors.blue,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${CalendarController.months[e.date.month - 1]} ${e.date.day}, ${e.date.year} • ${e.type}",
                        style: TextStyle(
                          fontFamily: "AnekTelugu",
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                      if (e.reminderEnabled) ...[
                        const SizedBox(height: 2),
                        Text(
                          "Reminder: ${e.reminderDays} day${e.reminderDays > 1 ? 's' : ''} before at ${e.reminderTime}",
                          style: const TextStyle(
                            fontFamily: "AnekTelugu",
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }).toList();
}

List<Widget> _buildReminderCards(CalendarController controller, BuildContext context) {
  final reminders = controller.events.where((e) => e.type == "Reminder").toList();

    return [
    // Quick Add Reminder Section
    _glass(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.schedule, color: Colors.blue.shade600, size: 20),
                const SizedBox(width: 8),
                const Text(
                  "Quick Add Reminder",
          style: TextStyle(
            fontFamily: "AnekTelugu",
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showQuickReminderDialog(controller, context),
                    icon: const Icon(Icons.add_circle_outline, size: 18),
                    label: const Text("Add Reminder"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddReminderDialog(controller, context),
                    icon: const Icon(Icons.settings, size: 18),
                    label: const Text("Advanced"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    
    const SizedBox(height: 16),
    
    // Reminders List
    if (reminders.isEmpty) ...[
      _glass(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(Icons.notifications_none, size: 48, color: Colors.grey.shade400),
              const SizedBox(height: 12),
              const Text(
                "No reminders yet",
                style: TextStyle(
                  fontFamily: "AnekTelugu",
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Add your first reminder to get started!",
                style: TextStyle(
                  fontFamily: "AnekTelugu",
                  fontSize: 13,
                  color: Colors.black38,
                ),
              ),
            ],
          ),
        ),
      ),
    ] else ...[
    ...reminders.map((e) {
        final isToday = e.date.day == controller.today.day && 
                       e.date.month == controller.today.month && 
                       e.date.year == controller.today.year;
        final isPast = e.date.isBefore(controller.today);
        
      return Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: _glass(
            child: Padding(
              padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isPast ? Colors.grey : 
                               isToday ? Colors.red : Colors.amber,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e.title,
                            style: TextStyle(
                  fontFamily: "AnekTelugu",
                  fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: isPast ? Colors.grey : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${CalendarController.months[e.date.month - 1]} ${e.date.day}, ${e.date.year}",
                            style: TextStyle(
                              fontFamily: "AnekTelugu",
                              fontSize: 12,
                  fontWeight: FontWeight.w600,
                              color: isPast ? Colors.grey : Colors.black54,
                            ),
                          ),
                          if (e.reminderEnabled) ...[
                            const SizedBox(height: 2),
                            Text(
                              "🔔 Reminder enabled",
                              style: TextStyle(
                                fontFamily: "AnekTelugu",
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) => _handleReminderAction(value, e, controller, context),
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'toggle',
                          child: Row(
                            children: [
                              Icon(Icons.notifications, size: 16),
                              SizedBox(width: 8),
                              Text('Toggle Reminder'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 16),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 16, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Delete', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                      child: Icon(
                        Icons.more_vert,
                        size: 20,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
            ),
          ),
        ),
      );
    }),
    ],
    
    const SizedBox(height: 16),
    
  ];
}

/// Shows a quick reminder dialog for easy reminder creation
/// @param controller The calendar controller
/// @param context The build context
void _showQuickReminderDialog(CalendarController controller, BuildContext context) {
  String reminderTitle = "";
  DateTime? reminderDate;
  TimeOfDay? reminderTime;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text(
              "Quick Add Reminder",
              style: TextStyle(fontFamily: "AnekTelugu"),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Reminder Title",
                    hintText: "e.g., Study for Math Exam",
                  ),
                  onChanged: (v) => reminderTitle = v,
                ),
                const SizedBox(height: 16),
                
                // Date Picker
                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: Text(
                    reminderDate == null
                        ? "Select Date"
                        : "${CalendarController.months[reminderDate!.month - 1]} ${reminderDate!.day}, ${reminderDate!.year}",
                  ),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      setState(() => reminderDate = picked);
                    }
                  },
                ),
                
                // Time Picker
                ListTile(
                  leading: const Icon(Icons.access_time),
                  title: Text(
                    reminderTime == null
                        ? "Select Time"
                        : reminderTime!.format(context),
                  ),
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (picked != null) {
                      setState(() => reminderTime = picked);
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  // Validate input
                  if (reminderTitle.isEmpty) {
                    ToastService.showError(
                      context,
                      title: 'Missing Title',
                      description: 'Please enter a reminder title',
                    );
                    return;
                  }
                  
                  if (reminderDate == null) {
                    ToastService.showError(
                      context,
                      title: 'Missing Date',
                      description: 'Please select a date for your reminder',
                    );
                    return;
                  }
                  
                  if (reminderTime == null) {
                    ToastService.showError(
                      context,
                      title: 'Missing Time',
                      description: 'Please select a time for your reminder',
                    );
                    return;
                  }
                  
                  // Combine date and time
                  final reminderDateTime = DateTime(
                    reminderDate!.year,
                    reminderDate!.month,
                    reminderDate!.day,
                    reminderTime!.hour,
                    reminderTime!.minute,
                  );
                  
                  // Check if the reminder time is in the past
                  if (reminderDateTime.isBefore(DateTime.now())) {
                    ToastService.showError(
                      context,
                      title: 'Invalid Time',
                      description: 'Please select a future date and time',
                    );
                    return;
                  }
                  
                  try {
                    // Add reminder with notification
                    await controller.addEventWithReminder(
                      title: reminderTitle,
                      date: reminderDateTime,
                      type: "Reminder",
                      reminderEnabled: true,
                      reminderDays: 0, // Immediate reminder
                      reminderTime: "${reminderTime!.hour.toString().padLeft(2, '0')}:${reminderTime!.minute.toString().padLeft(2, '0')}",
                    );
                    
                    // Show enhanced notification (both system and in-app)
                    await EnhancedNotificationService().showReminderAddedNotification(
                      context,
                      reminderTitle,
                      reminderDateTime,
                    );
                    
                    Navigator.pop(context);
                  } catch (e) {
                    ToastService.showError(
                      context,
                      title: 'Error Adding Reminder',
                      description: 'Please try again later',
                    );
                    print('Error adding reminder: $e');
                  }
                },
                child: const Text("Add Reminder"),
              ),
            ],
          );
        },
      );
    },
  );
}

/// Handles reminder actions from the popup menu
/// @param action The action to perform
/// @param event The calendar event
/// @param controller The calendar controller
/// @param context The build context
void _handleReminderAction(String action, CalendarEvent event, CalendarController controller, BuildContext context) {
  switch (action) {
    case 'toggle':
      controller.toggleEventReminder(event);
      ToastService.showInfo(
        context,
        title: 'Reminder ${event.reminderEnabled ? 'Disabled' : 'Enabled'}',
        description: event.title,
      );
      break;
    case 'edit':
      _showEditReminderDialog(event, controller, context);
      break;
    case 'delete':
      _showDeleteConfirmation(event, controller, context);
      break;
  }
}

/// Shows edit reminder dialog
/// @param event The calendar event to edit
/// @param controller The calendar controller
/// @param context The build context
void _showEditReminderDialog(CalendarEvent event, CalendarController controller, BuildContext context) {
  String reminderTitle = event.title;
  DateTime reminderDate = event.date;
  TimeOfDay reminderTime = TimeOfDay.fromDateTime(event.date);

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text(
              "Edit Reminder",
              style: TextStyle(fontFamily: "AnekTelugu"),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
      children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Reminder Title",
                  ),
                  controller: TextEditingController(text: reminderTitle),
                  onChanged: (v) => reminderTitle = v,
                ),
                const SizedBox(height: 16),
                
                // Date Picker
                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: Text(
                    "${CalendarController.months[reminderDate.month - 1]} ${reminderDate.day}, ${reminderDate.year}",
                  ),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: reminderDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      setState(() => reminderDate = picked);
                    }
                  },
                ),
                
                // Time Picker
                ListTile(
                  leading: const Icon(Icons.access_time),
                  title: Text(reminderTime.format(context)),
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: reminderTime,
                    );
                    if (picked != null) {
                      setState(() => reminderTime = picked);
                    }
                  },
        ),
      ],
    ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (reminderTitle.isNotEmpty) {
                    // Combine date and time
                    final reminderDateTime = DateTime(
                      reminderDate.year,
                      reminderDate.month,
                      reminderDate.day,
                      reminderTime.hour,
                      reminderTime.minute,
                    );
                    
                    // Create updated event
                    final updatedEvent = event.copyWith(
                      title: reminderTitle,
                      date: reminderDateTime,
                    );
                    
                    // Update the event
                    await controller.updateEventReminder(event, updatedEvent);
                    
                    // Show success toast
                    ToastService.showSuccess(
                      context,
                      title: 'Reminder Updated!',
                      description: reminderTitle,
                    );
                    
                    Navigator.pop(context);
                  }
                },
                child: const Text("Save Changes"),
              ),
            ],
          );
        },
      );
    },
  );
}

/// Shows delete confirmation dialog
/// @param event The calendar event to delete
/// @param controller The calendar controller
/// @param context The build context
void _showDeleteConfirmation(CalendarEvent event, CalendarController controller, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          "Delete Reminder",
          style: TextStyle(fontFamily: "AnekTelugu"),
        ),
        content: Text("Are you sure you want to delete '${event.title}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              await controller.deleteEvent(event);
              ToastService.showWarning(
                context,
                title: 'Reminder Deleted',
                description: event.title,
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Delete"),
          ),
        ],
      );
    },
  );
}


void _showAddReminderDialog(CalendarController controller, BuildContext context) {
  String reminderTitle = "";
  DateTime? reminderDate;
  String eventType = "Reminder";
  bool reminderEnabled = false;
  int reminderDays = 1;
  String reminderTime = "09:00";

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: AlertDialog(
                backgroundColor: Colors.white.withValues(alpha: 0.85),
                title: const Text(
                  "Add Event",
                  style: TextStyle(fontFamily: "AnekTelugu"),
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        decoration: const InputDecoration(
                          labelText: "Event Title",
                        ),
                        onChanged: (v) => reminderTitle = v,
                      ),
                      const SizedBox(height: 16),
                      
                      // Event Type Selection
                      DropdownButtonFormField<String>(
                        initialValue: eventType,
                        decoration: const InputDecoration(labelText: "Event Type"),
                        items: const [
                          DropdownMenuItem(value: "Event", child: Text("Event")),
                          DropdownMenuItem(value: "Deadline", child: Text("Deadline")),
                          DropdownMenuItem(value: "Reminder", child: Text("Reminder")),
                        ],
                        onChanged: (value) => setState(() => eventType = value!),
                      ),
                      const SizedBox(height: 16),
                      
                      // Date Picker
                      ElevatedButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: controller.today,
                            firstDate: DateTime(controller.today.year, controller.today.month - 1),
                            lastDate: DateTime(controller.today.year, controller.today.month + 12),
                          );
                          if (picked != null) {
                            setState(() => reminderDate = picked);
                          }
                        },
                        child: Text(
                          reminderDate == null
                              ? "Pick Date"
                              : "Picked: ${CalendarController.months[reminderDate!.month - 1]} ${reminderDate!.day}",
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Reminder Toggle
                      SwitchListTile(
                        title: const Text("Enable Reminder"),
                        value: reminderEnabled,
                        onChanged: (value) => setState(() => reminderEnabled = value),
                      ),
                      
                      if (reminderEnabled) ...[
                        const SizedBox(height: 8),
                        
                        // Reminder Days
                        DropdownButtonFormField<int>(
                          initialValue: reminderDays,
                          decoration: const InputDecoration(labelText: "Remind me"),
                          items: controller.getAvailableReminderDays().map((days) {
                            String label = days == 1 ? "1 day before" : 
                                         days == 7 ? "1 week before" :
                                         days == 14 ? "2 weeks before" :
                                         days == 30 ? "1 month before" :
                                         "$days days before";
                            return DropdownMenuItem(value: days, child: Text(label));
                          }).toList(),
                          onChanged: (value) => setState(() => reminderDays = value!),
                        ),
                        const SizedBox(height: 8),
                        
                        // Reminder Time
                        DropdownButtonFormField<String>(
                          initialValue: reminderTime,
                          decoration: const InputDecoration(labelText: "Reminder Time"),
                          items: controller.getAvailableReminderTimes().map((time) {
                            return DropdownMenuItem(value: time, child: Text(time));
                          }).toList(),
                          onChanged: (value) => setState(() => reminderTime = value!),
                        ),
                      ],
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (reminderTitle.isNotEmpty && reminderDate != null) {
                        await controller.addEventWithReminder(
                          title: reminderTitle,
                          date: reminderDate!,
                          type: eventType,
                          reminderEnabled: reminderEnabled,
                          reminderDays: reminderDays,
                          reminderTime: reminderTime,
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Save"),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}


Widget _bigTab(String tab, CalendarController controller) {
  final isActive = controller.selectedTab == tab;
  return GestureDetector(
    onTap: () => controller.toggleTab(tab),
    child: _glass(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withValues(alpha: 0.35) : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          tab,
          style: TextStyle(
            fontFamily: "AnekTelugu",
            fontSize: 14.5,
            fontWeight: FontWeight.w800,
            color: isActive ? Colors.black : Colors.black54,
          ),
        ),
      ),
    ),
  );
}

Widget _filterListItem(String label, CalendarController controller, {Color? swatch}) {
  final isActive = controller.selectedFilter == label;
  return GestureDetector(
    onTap: () => controller.selectFilter(label),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? Colors.white.withValues(alpha: 0.35) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          if (swatch != null) ...[
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: swatch,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontFamily: "AnekTelugu",
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.black : Colors.black54,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _glass({required Widget child}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(18),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withValues(alpha: 0.28),
              Colors.white.withValues(alpha: 0.12),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withValues(alpha: 0.45), width: 1),
        ),
        child: child,
      ),
    ),
  );
}

Widget _glassIconButton({
  required IconData icon,
  required VoidCallback onTap,
  double size = 28,
}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
      child: Material(
        color: Colors.white.withValues(alpha: 0.2),
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: size,
            height: size,
            child: Icon(icon, size: size * 0.64, color: Colors.black87),
          ),
        ),
      ),
    ),
  );
}

class _WD extends StatelessWidget {
  final String t;
  const _WD(this.t);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        t,
        style: const TextStyle(
          fontFamily: "AnekTelugu",
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.black54,
        ),
      ),
    );
  }
}
