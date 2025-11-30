import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../models/reminder.dart';
import '../utils/app_colors.dart';

class ReminderCard extends StatelessWidget {
  final Reminder reminder;
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
        color: reminder.completed
            ? AppColors.success.withOpacity(0.1)
            : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: reminder.completed
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
                  color: reminder.completed
                      ? AppColors.success
                      : Colors.grey.shade400,
                  width: 2.w,
                ),
                color: reminder.completed
                    ? AppColors.success
                    : Colors.transparent,
              ),
              child: reminder.completed
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
                        reminder.title,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: reminder.completed
                              ? AppColors.success
                              : AppColors.textPrimary,
                          decoration: reminder.completed
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
                          _formatTime(reminder.time),
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
                        color: reminder.completed
                            ? AppColors.success
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),

                SizedBox(height: 8.h),

                // Bottom Row
                Row(
                  children: [
                    // Attachments and Emoji
                    Row(
                      children: [
                        if (reminder.hasPhoto)
                          Container(
                            width: 24.w,
                            height: 24.w,
                            decoration: BoxDecoration(
                              color: AppColors.info.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.photo,
                              size: 12.sp,
                              color: AppColors.info,
                            ),
                          ),
                        if (reminder.hasPhoto && reminder.hasVoice)
                          SizedBox(width: 4.w),
                        if (reminder.hasVoice)
                          Container(
                            width: 24.w,
                            height: 24.w,
                            decoration: BoxDecoration(
                              color: Colors.purple.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.mic,
                              size: 12.sp,
                              color: Colors.purple,
                            ),
                          ),
                        if ((reminder.hasPhoto || reminder.hasVoice) &&
                            reminder.emoji != null)
                          SizedBox(width: 8.w),
                        if (reminder.emoji != null)
                          Text(
                            reminder.emoji!,
                            style: TextStyle(fontSize: 18.sp),
                          ),
                      ],
                    ),

                    const Spacer(),

                    // From Partner
                    Row(
                      children: [
                        Icon(
                          Icons.favorite,
                          size: 12.sp,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          reminder.fromPartner ? 'From Partner' : 'From You',
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

                // Streak
                if (reminder.streak > 0)
                  Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.local_fire_department,
                            size: 12.sp,
                            color: Colors.orange,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '${reminder.streak} day streak',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.orange,
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
      final timeParts = time.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      final dateTime = DateTime(2000, 1, 1, hour, minute);
      return DateFormat.jm().format(dateTime);
    } catch (e) {
      return time;
    }
  }
}
