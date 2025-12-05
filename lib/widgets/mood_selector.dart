import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/app_colors.dart';

class MoodSelector extends StatefulWidget {
  final Function(String, String?) onMoodSelect;

  const MoodSelector({super.key, required this.onMoodSelect});

  @override
  State<MoodSelector> createState() => _MoodSelectorState();
}

class _MoodSelectorState extends State<MoodSelector> {
  String _selectedMood = '';
  String _note = '';
  bool _showNote = false;

  final List<Map<String, dynamic>> _moods = [
    {'id': 'happy', 'label': 'Happy', 'emoji': '😊', 'color': Colors.yellow},
    {
      'id': 'love',
      'label': 'Loving',
      'emoji': '❤️',
      'color': AppColors.primary,
    },
    {
      'id': 'energetic',
      'label': 'Energetic',
      'emoji': '☀️',
      'color': Colors.orange,
    },
    {'id': 'calm', 'label': 'Calm', 'emoji': '☁️', 'color': Colors.blue},
    {'id': 'excited', 'label': 'Excited', 'emoji': '⭐', 'color': Colors.purple},
    {'id': 'tired', 'label': 'Tired', 'emoji': '☕', 'color': Colors.grey},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
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
            'How are you feeling?',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 6.h),

          // Mood Grid
          GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 1,
            ),
            itemCount: _moods.length,
            itemBuilder: (context, index) {
              final mood = _moods[index];
              final isSelected = _selectedMood == mood['id'];

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedMood = mood['id'];
                    _showNote = true;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? mood['color'].withOpacity(0.1)
                        : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isSelected ? mood['color'] : Colors.grey.shade200,
                      width: 2.w,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(mood['emoji'], style: TextStyle(fontSize: 24.sp)),
                      SizedBox(height: 4.h),
                      Text(
                        mood['label'],
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? mood['color']
                              : AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Note Input
          if (_showNote && _selectedMood.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: Column(
                children: [
                  Container(height: 1.h, color: Colors.grey.shade200),
                  SizedBox(height: 10.h),
                  TextField(
                    onChanged: (value) {
                      _note = value;
                    },
                    decoration: InputDecoration(
                      hintText:
                          'Add a note about how you\'re feeling... (optional)',
                      hintStyle: TextStyle(
                        color: AppColors.textLight,
                        fontSize: 14.sp,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: const BorderSide(color: AppColors.primary),
                      ),
                      contentPadding: EdgeInsets.all(12.w),
                    ),
                    maxLines: 3,
                  ),
                  SizedBox(height: 16.h),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _showNote = false;
                              _selectedMood = '';
                              _note = '';
                            });
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            backgroundColor: Colors.grey.shade100,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            widget.onMoodSelect(
                              _selectedMood,
                              _note.isEmpty ? null : _note,
                            );
                            setState(() {
                              _showNote = false;
                              _selectedMood = '';
                              _note = '';
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.send,
                                size: 16.sp,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Share Mood',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
