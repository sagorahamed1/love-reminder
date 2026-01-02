import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/memory_controller.dart';
import '../utils/app_colors.dart';
import '../widgets/memory_card.dart';
import '../widgets/filter_chips.dart';
import '../widgets/custom_text.dart';

class MemoryScreen extends StatefulWidget {
  const MemoryScreen({super.key});

  @override
  State<MemoryScreen> createState() => _MemoryScreenState();
}

class _MemoryScreenState extends State<MemoryScreen> {
  final memoryController = Get.find<MemoryController>();
  String _selectedFilter = 'all';

  @override
  void initState() {
    memoryController.getMemories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          CustomText(
            text: 'Our Memories',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            textAlign: TextAlign.left,
          ),

          CustomText(
            text: 'Precious moments we share together',

            color: AppColors.textSecondary,
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 10.h),

          // Filter Chips
          FilterChips(
            filters: const [
              {'key': 'all', 'label': 'All', 'icon': Icons.favorite},
              {
                'key': 'photos',
                'label': 'Photos',
                'icon': Icons.photo_camera,
              },
              {'key': 'notes', 'label': 'Notes', 'icon': Icons.note},
            ],
            selectedFilter: _selectedFilter,
            onFilterChanged: (filter) {
              setState(() {
                _selectedFilter = filter;
              });
            },
          ),
          SizedBox(height: 10.h),

          // Memories List
          Expanded(
            child: Obx(() {

              final allMemories = memoryController.memories;

              // Filter memories based on selected filter
              List filteredMemories;
              if (_selectedFilter == 'photos') {
                filteredMemories = allMemories.where((m) => m.images != null && m.images!.isNotEmpty).toList();
              } else if (_selectedFilter == 'notes') {
                filteredMemories = allMemories.where((m) => (m.images == null || m.images!.isEmpty) && m.message != null && m.message!.isNotEmpty).toList();
              } else {
                filteredMemories = allMemories;
              }

              if (memoryController.isLoading.value && filteredMemories.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (filteredMemories.isEmpty) {
                return _buildEmptyState();
              }

              return NotificationListener<ScrollEndNotification>(
                onNotification: (ScrollEndNotification notification) {
                  if (notification.metrics.extentAfter == 0) {
                    // User has scrolled to the end, load more
                    if (memoryController.currentPage.value < memoryController.totalPages) {
                      memoryController.loadMore();
                    }
                  }
                  return false;
                },
                child: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: filteredMemories.length,
                  itemBuilder: (context, index) {
                    final memory = filteredMemories[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: MemoryCard(memory: memory),
                    );
                  },
                ),
              );
            }),
          ),

          SizedBox(height: 55.h),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.photo_camera,
              size: 40,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 24.h),
          CustomText(
            text: 'No memories yet',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          CustomText(
            text: 'Start creating beautiful memories together!',
            fontSize: 16,
            color: AppColors.textSecondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
