import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/app_colors.dart';

class StatsGrid extends StatelessWidget {
  final int totalReminders;
  final int completedToday;
  final int completionRate;
  final int currentStreak;

  const StatsGrid({
    super.key,
    required this.totalReminders,
    required this.completedToday,
    required this.completionRate,
    required this.currentStreak,
  });

  @override
  Widget build(BuildContext context) {
    final stats = [
      {
        'title': 'Total Reminders',
        'value': '$totalReminders',
        'icon': Icons.favorite,
        'color': AppColors.primary,
        'bgColor': const Color(0xFFFCE4EC),
        'trend': '+12%',
      },
      {
        'title': 'Completed Today',
        'value': '$completedToday',
        'icon': Icons.check_circle,
        'color': AppColors.success,
        'bgColor': const Color(0xFFE8F5E8),
        'trend': '+8%',
      },
      {
        'title': 'Completion Rate',
        'value': '$completionRate%',
        'icon': Icons.heart_broken,
        'color': AppColors.info,
        'bgColor': const Color(0xFFE3F2FD),
        'trend': '+5%',
      },
      {
        'title': 'Current Streak',
        'value': '$currentStreak days',
        'icon': Icons.emoji_events,
        'color': Colors.purple,
        'bgColor': const Color(0xFFF3E5F5),
        'trend': 'Active',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 1.2,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];

        return Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: stat['bgColor'] as Color,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: stat['color'] as Color,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      stat['icon'] as IconData,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                  ),
                  const Spacer(),
                  if (stat['trend'] != null)
                    Row(
                      children: [
                        Icon(
                          stat['trend'] == 'Active'
                              ? Icons.circle
                              : Icons.trending_up,
                          size: 12.sp,
                          color: stat['trend'] == 'Active'
                              ? AppColors.success
                              : AppColors.success,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          stat['trend'] as String,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: stat['color'] as Color,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              SizedBox(height: 12.h),
              Text(
                stat['value'] as String,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: stat['color'] as Color,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                stat['title'] as String,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: (stat['color'] as Color).withOpacity(0.7),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
