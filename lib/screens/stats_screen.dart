import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/streak_display.dart';
import '../widgets/stats_grid.dart';
import '../widgets/progress_chart.dart';
import '../widgets/achievement_badges.dart';
import '../widgets/custom_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for design preview
    const totalReminders = 15;
    const completedToday = 8;
    const completionRate = 85;
    const currentStreak = 12;
    const longestStreak = 25;

    const weeklyProgress = [
      {'day': 'Mon', 'completed': 8, 'total': 10},
      {'day': 'Tue', 'completed': 9, 'total': 10},
      {'day': 'Wed', 'completed': 7, 'total': 10},
      {'day': 'Thu', 'completed': 10, 'total': 10},
      {'day': 'Fri', 'completed': 6, 'total': 10},
      {'day': 'Sat', 'completed': 8, 'total': 10},
      {'day': 'Sun', 'completed': 9, 'total': 10},
    ];

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          CustomText(
            text: 'Love Statistics',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 8.h),
          CustomText(
            text: 'Track your journey together',
            fontSize: 16,
            color: AppColors.textSecondary,
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 24.h),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Streak Display
                  StreakDisplay(
                    currentStreak: currentStreak,
                    longestStreak: longestStreak,
                  ),
                  SizedBox(height: 24.h),

                  // Stats Grid
                  StatsGrid(
                    totalReminders: totalReminders,
                    completedToday: completedToday,
                    completionRate: completionRate,
                    currentStreak: currentStreak,
                  ),
                  SizedBox(height: 24.h),

                  // Progress Chart
                  ProgressChart(data: weeklyProgress),
                  SizedBox(height: 24.h),

                  // Achievement Badges
                  const AchievementBadges(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
