import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/app_colors.dart';

class ThemeSelector extends StatelessWidget {
  final String currentTheme;
  final Function(String) onThemeChanged;

  const ThemeSelector({
    super.key,
    required this.currentTheme,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final themes = [
      {
        'key': 'light',
        'label': 'Light',
        'icon': Icons.wb_sunny,
        'colors': [Colors.blue.shade400, Colors.blue.shade500],
      },
      {
        'key': 'dark',
        'label': 'Dark',
        'icon': Icons.nights_stay,
        'colors': [Colors.grey.shade700, Colors.grey.shade800],
      },
      {
        'key': 'romantic',
        'label': 'Romantic',
        'icon': Icons.favorite,
        'colors': [AppColors.primary, AppColors.secondary],
      },
    ];

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose Theme',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16.h),

          Row(
            children: themes.map((theme) {
              final isSelected = currentTheme == theme['key'];

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: GestureDetector(
                    onTap: () => onThemeChanged(theme['key'] as String),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.grey.shade300,
                          width: 2.w,
                        ),
                        color: isSelected
                            ? AppColors.primaryLight.withOpacity(0.1)
                            : Colors.transparent,
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 32.w,
                            height: 32.w,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: theme['colors'] as List<Color>,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              theme['icon'] as IconData,
                              color: Colors.white,
                              size: 16.sp,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            theme['label'] as String,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
