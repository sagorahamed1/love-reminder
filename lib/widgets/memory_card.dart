import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../models/memory.dart';
import '../utils/app_colors.dart';

class MemoryCard extends StatelessWidget {
  final Memory memory;

  const MemoryCard({super.key, required this.memory});

  @override
  Widget build(BuildContext context) {
    final isOwnMemory = memory.createdBy == '1'; // Mock user ID

    return Container(
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
          // Memory Image
          if (memory.type == 'photo' && memory.imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              child: Container(
                height: 200.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient.scale(0.3),
                ),
                child: Image.network(
                  memory.imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient.scale(0.3),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.photo,
                          size: 48.sp,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

          // Content
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      width: 32.w,
                      height: 32.w,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        memory.type == 'photo'
                            ? Icons.photo_camera
                            : Icons.note,
                        size: 16.sp,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            memory.title,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 12.sp,
                                color: AppColors.textLight,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                DateFormat.yMMMd().format(memory.createdAt),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.textLight,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.person,
                            size: 12.sp,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            isOwnMemory ? 'You' : 'Partner',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // Content
                Text(
                  memory.content,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),

                // Tags
                if (memory.tags.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 12.h),
                    child: Wrap(
                      spacing: 6.w,
                      runSpacing: 6.h,
                      children: memory.tags.map((tag) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            '#$tag',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                // Footer
                Padding(
                  padding: EdgeInsets.only(top: 12.h),
                  child: Container(
                    padding: EdgeInsets.only(top: 12.h),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Colors.grey.shade200,
                          width: 1.w,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.favorite,
                          size: 16.sp,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'Memory saved',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            // Handle view details
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'View Details',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary,
                            ),
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
}
