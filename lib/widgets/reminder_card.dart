import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lovereminder/models/getreminder_model.dart';
import '../utils/app_colors.dart';

class ReminderCard extends StatelessWidget {
  final GetReminderModel reminder;
  final VoidCallback onToggle;

  const ReminderCard({
    super.key,
    required this.reminder,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: reminder.completed == true
            ? AppColors.success.withOpacity(0.1)
            : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: reminder.completed == true
              ? AppColors.success.withOpacity(0.3)
              : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Row(
        children: [
          // Completion Toggle
          GestureDetector(
            onTap: onToggle,
            child: Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: reminder.completed == true
                      ? AppColors.success
                      : Colors.grey.shade400,
                  width: 2.w,
                ),
                color: reminder.completed == true
                    ? AppColors.success
                    : Colors.transparent,
              ),
              child: reminder.completed == true
                  ? Icon(Icons.check, size: 16.sp, color: Colors.white)
                  : null,
            ),
          ),
          SizedBox(width: 12.w),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Time
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        reminder.title ?? 'No Title',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: reminder.completed == true
                              ? AppColors.success
                              : AppColors.textPrimary,
                          decoration: reminder.completed == true
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 12.sp,
                          color: AppColors.textLight,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          _formatTime(reminder.time ?? ''),
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Message
                if (reminder.message != null)
                  Padding(
                    padding: EdgeInsets.only(top: 4.h),
                    child: Text(
                      reminder.message!,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: reminder.completed == true
                            ? AppColors.success
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),

                SizedBox(height: 8.h),

                // Bottom Row - Using API data where available, defaults otherwise
                Row(
                  children: [
                    // Emoji
                    if (reminder.emoji != null)
                      Container(
                        width: 24.w,
                        height: 24.w,
                        decoration: BoxDecoration(
                          color: AppColors.info.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            reminder.emoji!,
                            style: TextStyle(fontSize: 12.sp),
                          ),
                        ),
                      ),

                    const Spacer(),

                    // From Partner/You indicator based on isOwn
                    Row(
                      children: [
                        Icon(
                          Icons.favorite,
                          size: 12.sp,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          reminder.isOwn == true ? 'From You' : 'From Partner',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Repeat indicator
                if (reminder.repeat != null)
                  Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getRepeatIcon(reminder.repeat!),
                            size: 12.sp,
                            color: Colors.blue,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            _formatRepeat(reminder.repeat!),
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(String time) {
    try {
      if (time.isEmpty) return '';
      final timeParts = time.split(':');
      if (timeParts.length < 2) return time;
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      final dateTime = DateTime(2000, 1, 1, hour, minute);
      return DateFormat.jm().format(dateTime);
    } catch (e) {
      return time;
    }
  }

  IconData _getRepeatIcon(String repeat) {
    switch (repeat.toLowerCase()) {
      case 'daily':
      case 'everyday':
        return Icons.repeat;
      case 'weekly':
        return Icons.repeat_one;
      case 'monthly':
        return Icons.calendar_month;
      case 'once':
      default:
        return Icons.event;
    }
  }

  String _formatRepeat(String repeat) {
    switch (repeat.toLowerCase()) {
      case 'daily':
        return 'Daily';
      case 'weekly':
        return 'Weekly';
      case 'monthly':
        return 'Monthly';
      case 'once':
        return 'One-time';
      default:
        return repeat;
    }
  }
}
