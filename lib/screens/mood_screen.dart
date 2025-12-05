import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/mood_controller.dart';
import '../utils/app_colors.dart';
import '../widgets/mood_selector.dart';
import '../widgets/mood_history.dart';
import '../widgets/custom_text.dart';

class MoodScreen extends StatelessWidget {
  const MoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MoodController>(
      builder: (moodController) {
        return Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              CustomText(
                text: 'Mood Sharing',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                textAlign: TextAlign.left,
              ),

              CustomText(
                text: 'Share your feelings with your loved one',

                color: AppColors.textSecondary,
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 10.h),

              Expanded(
                child: SingleChildScrollView(
                  physics:
                      const BouncingScrollPhysics(), // Better scroll physics
                  child: Column(
                    children: [
                      // Partner Mood Status
                      if (moodController.partnerMood.value != null)
                        Container(
                          padding: EdgeInsets.all(20.w),
                          margin: EdgeInsets.only(bottom: 16.h),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFCE4EC), Color(0xFFFFE0E6)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40.w,
                                height: 40.w,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.favorite,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: 'Your partner is feeling',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFFAD1457),
                                      textAlign: TextAlign.left,
                                    ),
                                    SizedBox(height: 4.h),
                                    CustomText(
                                      text: moodController
                                          .partnerMood
                                          .value!
                                          .mood
                                          .toUpperCase(),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF880E4F),
                                      textAlign: TextAlign.left,
                                    ),
                                    if (moodController
                                            .partnerMood
                                            .value!
                                            .note !=
                                        null)
                                      Padding(
                                        padding: EdgeInsets.only(top: 4.h),
                                        child: CustomText(
                                          text:
                                              '"${moodController.partnerMood.value!.note}"',
                                          fontSize: 14,
                                          color: Color(0xFFAD1457),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              CustomText(
                                text: _formatTime(
                                  moodController.partnerMood.value!.timestamp,
                                ),
                                fontSize: 12,
                                color: Color(0xFFAD1457),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                        ),

                      // Mood Selector
                      MoodSelector(
                        onMoodSelect: (moodId, note) {
                          // You may want to implement updateMood in MoodController
                          // For now, just call update() to refresh UI
                          // moodController.updateMood(moodId, note);
                          moodController.update();
                        },
                      ),
                      SizedBox(height: 24.h),

                      // Mood History
                      MoodHistory(history: moodController.moodHistory),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
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
}
