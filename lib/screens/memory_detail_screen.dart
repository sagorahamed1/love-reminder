import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/memory_controller.dart';
import '../models/memory.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_text.dart';

class MemoryDetailScreen extends StatelessWidget {
  final Memory memory;

  const MemoryDetailScreen({super.key, required this.memory});

  @override
  Widget build(BuildContext context) {
    final bool isOwnMemory = memory.isSender == true; // From API response

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Background
            Container(
              decoration: const BoxDecoration(
                gradient: AppColors.backgroundGradient,
              ),
            ),

            // Content
            CustomScrollView(
              slivers: [
                // App bar
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                  ),
                  actions: [
                    PopupMenuButton<String>(
                      onSelected: (String result) async {
                        // Handle menu selection
                        if (result == 'share') {
                          // Implement sharing functionality
                        } else if (result == 'delete') {
                          await _confirmAndDeleteMemory(context);
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                      [
                        const PopupMenuItem<String>(
                          value: 'share',
                          child: Row(
                            children: [
                              Icon(Icons.share),
                              SizedBox(width: 8),
                              Text('Share'),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Delete',
                                  style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                  expandedHeight: memory.images != null &&
                      memory.images!.isNotEmpty ? 300.h : 200.h,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: memory.images != null &&
                        memory.images!.isNotEmpty
                        ? PageView.builder(
                      itemCount: memory.images!.length,
                      itemBuilder: (context, index) {
                        String imageUrl = memory.images![index];
                        // If the image URL is not a full URL, prepend the base URL
                        if (!imageUrl.startsWith('http')) {
                          imageUrl =
                          'https://6c0hk6c2-8089.inc1.devtunnels.ms/upload/$imageUrl';
                        }
                        return CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Container(
                                color: AppColors.primary.withOpacity(0.1),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                          errorWidget: (context, url, error) =>
                              Container(
                                color: AppColors.primary.withOpacity(0.1),
                                child: Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    color: AppColors.textSecondary,
                                    size: 48.sp,
                                  ),
                                ),
                              ),
                        );
                      },
                    )
                        : Container(
                      color: AppColors.primary.withOpacity(0.1),
                      child: Icon(
                        Icons.note,
                        size: 48.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),

                // Memory details content
                SliverToBoxAdapter(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24.r),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10.r,
                          offset: Offset(0, -4.h),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(24.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Memory title and metadata
                          Row(
                            children: [
                              Container(
                                width: 40.w,
                                height: 40.w,
                                decoration: BoxDecoration(
                                  gradient: AppColors.primaryGradient,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.photo_library,
                                  // Generic icon for memories
                                  size: 18.sp,
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
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w700,
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
                                          DateFormat.yMMMd().format(
                                              memory.createdAt ??
                                                  DateTime.now()),
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: AppColors.textLight,
                                          ),
                                        ),
                                        SizedBox(width: 12.w),
                                        if (memory.dateTime != null) ...[
                                          Icon(
                                            Icons.access_time,
                                            size: 12.sp,
                                            color: AppColors.textLight,
                                          ),
                                          SizedBox(width: 4.w),
                                          Text(
                                            DateFormat('h:mm a').format(
                                                memory.dateTime!),
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color: AppColors.textLight,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryLight,
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      isOwnMemory ? Icons.person : Icons
                                          .favorite,
                                      size: 12.sp,
                                      color: AppColors.primary,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      isOwnMemory ? 'You' : 'Partner',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 24.h),

                          // Memory type indicator
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: memory.images != null &&
                                  memory.images!.isNotEmpty
                                  ? AppColors.primary.withOpacity(0.1)
                                  : Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  memory.images != null &&
                                      memory.images!.isNotEmpty
                                      ? Icons.photo_library
                                      : Icons.note,
                                  size: 12.sp,
                                  color: memory.images != null &&
                                      memory.images!.isNotEmpty
                                      ? AppColors.primary
                                      : Colors.orange,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  memory.images != null &&
                                      memory.images!.isNotEmpty
                                      ? 'Photo Memory'
                                      : 'Note Memory',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: memory.images != null &&
                                        memory.images!.isNotEmpty
                                        ? AppColors.primary
                                        : Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 24.h),

                          // Memory content
                          CustomText(
                            text: memory.message ?? '',
                            fontSize: 16,
                            color: AppColors.textPrimary,
                            textAlign: TextAlign.left,
                            fontWeight: FontWeight.w400,
                          ),

                          if (memory.tags != null &&
                              memory.tags!.isNotEmpty) ...[
                            SizedBox(height: 24.h),

                            // Tags section
                            CustomText(
                              text: 'Tags',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                            SizedBox(height: 12.h),
                            Wrap(
                              spacing: 8.w,
                              runSpacing: 8.h,
                              children: memory.tags!.map((tag) {
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 6.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                  child: Text(
                                    '#$tag',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],

                          SizedBox(height: 32.h),

                          // Favorite indicator
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 64.w,
                                height: 64.w,
                                decoration: BoxDecoration(
                                  color: memory.isFavorited == true
                                      ? Colors.red.withOpacity(0.1)
                                      : AppColors.primary.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.favorite,
                                  color: memory.isFavorited == true
                                      ? Colors.red
                                      : AppColors.primary,
                                  size: 32.sp,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                memory.isFavorited == true
                                    ? 'Favorited'
                                    : 'Memory Saved',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: memory.isFavorited == true
                                      ? Colors.red
                                      : AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Confirm and delete memory
  Future<void> _confirmAndDeleteMemory(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Memory'),
          content: const Text(
              'Are you sure you want to delete this memory? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirm
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (result == true) {
      // User confirmed deletion
      await _deleteMemory(context);
    }
  }

  // Delete memory from the API
  Future<void> _deleteMemory(BuildContext context) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text('Deleting memory...'),
              ],
            ),
          );
        },
      );

      // Call the memory controller to delete the memory
      final memoryController = Get.find<MemoryController>();
      bool success = await memoryController.deleteMemory(memory.id!);

      // Close the loading dialog
      Navigator.of(context).pop();

      if (success) {
        // Show success message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Memory deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }

        // Navigate back to the previous screen
        if (context.mounted) {
          Navigator.of(context).pop(); // Close detail screen
        }
      } else {
        // Show error message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to delete memory'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      // Close the loading dialog if still open
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      // Show error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}