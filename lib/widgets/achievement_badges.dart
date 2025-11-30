import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AchievementBadges extends StatelessWidget {
  const AchievementBadges({super.key});

  @override
  Widget build(BuildContext context) {
    final achievements = [
      {
        'title': 'First Week',
        'icon': Icons.emoji_events,
        'color': Colors.yellow,
        'unlocked': true,
      },
      {
        'title': 'Love Bird',
        'icon': Icons.favorite,
        'color': AppColors.primary,
        'unlocked': true,
      },
      {
        'title': '30 Days',
        'icon': Icons.calendar_today,
        'color': Colors.purple,
        'unlocked': true,
      },
      {
        'title': 'Streak Master',
        'icon': Icons.local_fire_department,
        'color': Colors.orange,
        'unlocked': false,
      },
      {
        'title': 'Memory Keeper',
        'icon': Icons.photo_camera,
        'color': Colors.blue,
        'unlocked': false,
      },
      {
        'title': 'Mood Sharer',
        'icon': Icons.sentiment_satisfied,
        'color': Colors.green,
        'unlocked': false,
      },
    ];

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF3E5F5), Color(0xFFFFE0E6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Achievements',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16.h),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 1,
            ),
            itemCount: achievements.length,
            itemBuilder: (context, index) {
              final achievement = achievements[index];
              final isUnlocked = achievement['unlocked'] as bool;

              return Column(
                children: [
                  Container(
                    width: 48.w,
                    height: 48.w,
                    decoration: BoxDecoration(
                      color: isUnlocked
                          ? achievement['color'] as Color
                          : Colors.grey.shade300,
                      shape: BoxShape.circle,
                      boxShadow: isUnlocked
                          ? [
                              BoxShadow(
                                color: (achievement['color'] as Color)
                                    .withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Icon(
                      achievement['icon'] as IconData,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    achievement['title'] as String,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: isUnlocked
                          ? AppColors.textPrimary
                          : AppColors.textLight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
