import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/reminder_controller.dart';
import '../utils/app_colors.dart';
import '../widgets/reminder_card.dart';
import '../widgets/filter_chips.dart';
import '../widgets/custom_text.dart';
import '../widgets/empty_state.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {

  final reminderController = Get.find<ReminderController>();

  String _selectedFilter = 'all';

  @override
  void initState() {
    reminderController.getReminders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Chips
          FilterChips(
            filters: const [
              {'key': 'all', 'label': 'All', 'icon': Icons.notifications},
              {
                'key': 'pending',
                'label': 'Pending',
                'icon': Icons.radio_button_unchecked,
              },
              {
                'key': 'completed',
                'label': 'Completed',
                'icon': Icons.check_circle,
              },
            ],
            selectedFilter: _selectedFilter,
            onFilterChanged: (filter) {
              setState(() {
                _selectedFilter = filter;
              });
            },
          ),
          SizedBox(height: 10.h),

          // Reminders List
          Expanded(
            child: Obx(() {

              final allReminders = reminderController.reminders;
              List filteredReminders;
              if (_selectedFilter == 'pending') {
                filteredReminders = allReminders.where((r) => r.completed != true).toList();
              } else if (_selectedFilter == 'completed') {
                filteredReminders = allReminders.where((r) => r.completed == true).toList();
              } else {
                filteredReminders = allReminders;
              }

              if (reminderController.isLoading.value && filteredReminders.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (filteredReminders.isEmpty) {
                return EmptyState(
                  title: 'No reminders yet',
                  message: 'Create your first love reminder!',
                  icon: Icons.favorite,
                );
              }

              return NotificationListener<ScrollEndNotification>(
                onNotification: (ScrollEndNotification notification) {
                  if (notification.metrics.extentAfter == 0) {
                    // User has scrolled to the end, load more
                    if (reminderController.currentPage.value < reminderController.totalPages) {
                      reminderController.loadMore();
                    }
                  }
                  return false;
                },
                child: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: filteredReminders.length,
                  itemBuilder: (context, index) {
                    final reminder = filteredReminders[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: ReminderCard(
                        reminder: reminder,
                        onToggle: () async {
                          // Toggle the reminder completion status
                          await reminderController.toggleReminderCompletion(
                            reminder.id!,
                            reminder.completed ?? false,
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            }),
          ),

          SizedBox(height: 55.h),
        ],
      ),
    );
  }
}
