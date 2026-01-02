import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/memory.dart';
import '../screens/memory_detail_screen.dart';
import '../utils/app_colors.dart';

class MemoryCard extends StatelessWidget {
  final Memory memory;

  const MemoryCard({super.key, required this.memory});

  @override
  Widget build(BuildContext context) {
    final isOwnMemory = memory.isSender == true; // From API response

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
          // Memory Images (multiple if available)
          if (memory.images != null && memory.images!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              child: SizedBox(
                height: 200.h,
                child: PageView.builder(
                  itemCount: memory.images!.length,
                  itemBuilder: (context, index) {
                    String imageUrl = memory.images![index];
                    // If the image URL is not a full URL, prepend the base URL
                    if (!imageUrl.startsWith('http')) {
                      imageUrl = 'https://6c0hk6c2-8089.inc1.devtunnels.ms/upload/$imageUrl';
                    }
                    return CachedNetworkImage(
                      imageUrl: imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        height: 200.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient.scale(0.3),
                        ),
                        child: Center(
                          child: Icon(Icons.photo, size: 48.sp, color: Colors.white),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 200.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient.scale(0.3),
                        ),
                        child: Center(
                          child: Icon(Icons.photo, size: 48.sp, color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          else
            Container(
              height: 200.h,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient.scale(0.3),
              ),
              child: Center(
                child: Icon(Icons.photo, size: 48.sp, color: Colors.white),
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
                        Icons.photo_library, // Generic icon for memories
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
                            memory.title ?? 'No Title',
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
                                DateFormat.yMMMd().format(memory.createdAt ?? DateTime.now()),
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
                            isOwnMemory ? Icons.person : Icons.favorite,
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

                // Message
                Text(
                  memory.message ?? '',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),

                // Tags
                if (memory.tags != null && memory.tags!.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Wrap(
                      spacing: 6.w,
                      runSpacing: 6.h,
                      children: memory.tags!
                          .map(
                            (tag) => Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Text(
                                '#$tag',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                          .toList(),
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
                          color: memory.isFavorited == true ? Colors.red : AppColors.textLight,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          memory.isFavorited == true ? 'Favorited' : 'Memory saved',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            Get.to(() => MemoryDetailScreen(memory: memory));
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
