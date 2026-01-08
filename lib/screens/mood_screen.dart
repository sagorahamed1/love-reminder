import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/mood_controller.dart';
import '../utils/app_colors.dart';
import '../widgets/mood_selector.dart';
import '../widgets/mood_history.dart';
import '../widgets/custom_text.dart';

class MoodScreen extends StatefulWidget {
  const MoodScreen({super.key});

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  final ScrollController _scrollController = ScrollController();
  MoodController moodController = Get.put(MoodController());

  @override
  void initState() {
    super.initState();
    moodController.getMood();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final moodController = Get.find<MoodController>();
      if (!moodController.isLoading.value) {
        moodController.loadMore();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MoodController>(
      builder: (moodController) {
        return RefreshIndicator(
          onRefresh: () => moodController.refreshAll(),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    child: Column(
                      children: [
                        // Partner Mood Status
                        Obx(() {
                          if (moodController.partnerCurrentMoodLoading.value) {
                            return _buildPartnerMoodSkeleton();
                          }

                          if (moodController.partnerMood.value != null) {
                            return _buildPartnerMoodCard(
                              moodController.partnerMood.value!,
                            );
                          }

                          return const SizedBox.shrink();
                        }),

                        // Mood Selector
                        MoodSelector(
                          onMoodSelect: (moodId, note) async {
                            await moodController.shareMood(
                              type: moodId,
                              message: note,
                            );
                          },
                        ),
                        SizedBox(height: 24.h),

                        // Mood History
                        Obx(() {
                          if (moodController.isLoading.value &&
                              moodController.moods.isEmpty) {
                            return _buildHistorySkeleton();
                          }

                          return MoodHistory(
                            history: moodController.moodHistory,
                          );
                        }),

                        // Loading indicator for pagination
                        Obx(() {
                          if (moodController.isLoading.value &&
                              moodController.moods.isNotEmpty) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        }),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 55.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPartnerMoodCard(dynamic partnerMood) {
    return Container(
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
                  text: '${partnerMood.getPartnerName()} is feeling',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFFAD1457),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 4.h),
                CustomText(
                  text: (partnerMood.mood ?? 'happy').toUpperCase(),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF880E4F),
                  textAlign: TextAlign.left,
                ),
                if (partnerMood.note != null && partnerMood.note!.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 4.h),
                    child: CustomText(
                      text: '"${partnerMood.note}"',
                      fontSize: 14,
                      color: const Color(0xFFAD1457),
                      textAlign: TextAlign.left,
                    ),
                  ),
              ],
            ),
          ),
          CustomText(
            text: _formatTime(partnerMood.timestamp),
            fontSize: 12,
            color: const Color(0xFFAD1457),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }

  Widget _buildPartnerMoodSkeleton() {
    return Container(
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
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 14.h,
                  width: 120.w,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  height: 18.h,
                  width: 80.w,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistorySkeleton() {
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
        children: List.generate(
          3,
              (index) => Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Container(
                  width: 32.w,
                  height: 32.w,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 14.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Container(
                        height: 12.h,
                        width: 150.w,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
}