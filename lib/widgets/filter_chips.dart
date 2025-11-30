import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FilterChips extends StatelessWidget {
  final List<Map<String, dynamic>> filters;
  final String selectedFilter;
  final Function(String) onFilterChanged;

  const FilterChips({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final isSelected = selectedFilter == filter['key'];

          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: FilterChip(
              selected: isSelected,
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    filter['icon'] as IconData,
                    size: 16.sp,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    filter['label'] as String,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              onSelected: (selected) {
                onFilterChanged(filter['key'] as String);
              },
              backgroundColor: Colors.white,
              selectedColor: AppColors.primary,
              checkmarkColor: Colors.white,
              side: BorderSide(
                color: isSelected ? AppColors.primary : Colors.grey.shade300,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
