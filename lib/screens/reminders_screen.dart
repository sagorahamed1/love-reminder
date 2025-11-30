import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/reminder_controller.dart';
import '../utils/app_colors.dart';
import '../widgets/reminder_card.dart';
import '../widgets/filter_chips.dart';
import '../widgets/stats_cards.dart';
import '../widgets/custom_text.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  String _selectedFilter = 'all';

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReminderController>(
      builder: (reminderController) {
        // Filtering logic (mimic original getFilteredReminders)
        final reminders = reminderController.reminders;
        List filteredReminders;
        if (_selectedFilter == 'pending') {
          filteredReminders = reminders.where((r) => !r.completed).toList();
        } else if (_selectedFilter == 'completed') {
          filteredReminders = reminders.where((r) => r.completed).toList();
        } else {
          filteredReminders = reminders;
        }

        return Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              CustomText(
                text: 'Love Reminders',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                textAlign: TextAlign.left,
              ),
            
              CustomText(
                text: 'Sweet reminders for a sweeter life together',
                fontSize: 16,
                color: AppColors.textSecondary,
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 10.h),

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

              // Stats Cards
              StatsCards(
                totalReminders: reminders.length,
                completedToday: reminders.where((r) => r.completed).length,
              ),
              const SizedBox(height: 10),

              // Reminders List
              Expanded(
                child: filteredReminders.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: filteredReminders.length,
                        itemBuilder: (context, index) {
                          final reminder = filteredReminders[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: ReminderCard(
                              reminder: reminder,
                              onToggle: () {
                                // You may want to implement toggle logic in ReminderController
                                // For now, just call update() to refresh UI
                                reminder.completed =
                                    !(reminder.completed ?? false);
                                reminderController.update();
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite,
              size: 40,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 24.h),
          CustomText(
            text: 'No reminders yet',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          CustomText(
            text: 'Create your first love reminder!',
            fontSize: 16,
            color: AppColors.textSecondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
