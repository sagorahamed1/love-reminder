import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../models/mood.dart';
import '../utils/app_colors.dart';

class MoodHistory extends StatelessWidget {
  final List<Mood> history;

  const MoodHistory({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mood History',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16.h),

          if (history.isNotEmpty)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: history.length,
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final mood = history[index];
                final isOwnMood = mood.userId == '1'; // Mock user ID

                return Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      // Mood Emoji
                      Container(
                        width: 32.w,
                        height: 32.w,
                        decoration: BoxDecoration(
                          color: _getMoodColor(mood.mood).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            _getMoodEmoji(mood.mood),
                            style: TextStyle(fontSize: 16.sp),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),

                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  mood.mood.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: _getMoodColor(mood.mood),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 6.w,
                                    vertical: 2.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryLight,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.person,
                                        size: 10.sp,
                                        color: AppColors.primary,
                                      ),
                                      SizedBox(width: 2.w),
                                      Text(
                                        isOwnMood ? 'You' : 'Partner',
                                        style: TextStyle(
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (mood.note != null)
                              Padding(
                                padding: EdgeInsets.only(top: 4.h),
                                child: Text(
                                  '"${mood.note}"',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      // Time
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 12.sp,
                            color: AppColors.textLight,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            _formatTime(mood.timestamp),
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: AppColors.textLight,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            )
          else
            Center(
              child: Column(
                children: [
                  Container(
                    width: 64.w,
                    height: 64.w,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.access_time,
                      size: 32.sp,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'No mood history yet',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Start sharing your feelings!',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _getMoodEmoji(String mood) {
    switch (mood) {
      case 'happy':
        return '😊';
      case 'love':
        return '❤️';
      case 'energetic':
        return '☀️';
      case 'calm':
        return '☁️';
      case 'excited':
        return '⭐';
      case 'tired':
        return '☕';
      default:
        return '😊';
    }
  }

  Color _getMoodColor(String mood) {
    switch (mood) {
      case 'happy':
        return Colors.yellow.shade700;
      case 'love':
        return AppColors.primary;
      case 'energetic':
        return Colors.orange;
      case 'calm':
        return Colors.blue;
      case 'excited':
        return Colors.purple;
      case 'tired':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return DateFormat.MMMd().format(timestamp);
    }
  }
}
