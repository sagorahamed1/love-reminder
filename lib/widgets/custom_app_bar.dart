import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lovereminder/services/api_constants.dart';
import '../controllers/auth_controller.dart';
import '../controllers/couple_controller.dart';
import '../utils/app_colors.dart';
import 'custom_text.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (authController) {
        return GetBuilder<CoupleController>(
          builder: (coupleController) {
            return Container(
              padding: EdgeInsets.fromLTRB(16.w, 50.h, 16.w, 16.h),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.primary.withOpacity(0.1),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  // App Icon and Title
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: '$title',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          textAlign: TextAlign.left,
                        ),
                        if (coupleController.partner.value != "")
                          CustomText(
                            text:
                                'Connected with ${coupleController.partner.value}',
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            textAlign: TextAlign.left,
                          ),
                      ],
                    ),
                  ),

                  // Connection Streak and Profile
                  Row(
                    children: [
                      if (coupleController.connectionStreak.value > 0)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFCE4EC), Color(0xFFFFE0E6)],
                            ),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.favorite,
                                size: 12.sp,
                                color: AppColors.primary,
                              ),
                              SizedBox(width: 4.w),
                              CustomText(
                                text:
                                    '${coupleController.connectionStreak.value} days',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                      SizedBox(width: 12.w),

                      // Profile Avatar
                      Container(
                        width: 32.w,
                        height: 32.w,
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          shape: BoxShape.circle,
                        ),
                        child: CachedNetworkImage(
                          imageUrl: "${ApiConstants.imageBaseUrl}/${coupleController.profileImage.value}",
                          width: double.infinity,
                          fit: BoxFit.cover,

                          placeholder: (context, url) => Container(
                            height: 32.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppColors.primaryGradient.scale(0.3),
                            ),
                            child: Center(
                              child: Icon(Icons.photo, size: 18.sp, color: Colors.white),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            height: 32.h,
                            width: 32.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppColors.primaryGradient.scale(0.3),
                            ),
                            child: Center(
                              child: Icon(Icons.photo, size: 18.sp, color: Colors.white),
                            ),
                          ),
                        )
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
