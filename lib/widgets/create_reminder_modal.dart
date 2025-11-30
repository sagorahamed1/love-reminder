import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../providers/reminder_provider.dart';
import '../models/reminder.dart';
import '../utils/app_colors.dart';

class CreateReminderModal extends StatefulWidget {
  final VoidCallback onClose;

  const CreateReminderModal({super.key, required this.onClose});

  @override
  State<CreateReminderModal> createState() => _CreateReminderModalState();
}

class _CreateReminderModalState extends State<CreateReminderModal> {
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _selectedEmoji = '';
  List<String> _selectedDays = ['daily'];
  bool _isLoading = false;

  final List<String> _emojiOptions = [
    '💊',
    '🕌',
    '😴',
    '💧',
    '🏃‍♂️',
    '🍽️',
    '📚',
    '💝',
    '🌸',
    '⭐',
  ];

  final List<Map<String, String>> _timePresets = [
    {'label': 'Morning', 'value': '08:00'},
    {'label': 'Noon', 'value': '12:00'},
    {'label': 'Evening', 'value': '18:00'},
    {'label': 'Night', 'value': '22:00'},
  ];

  final List<Map<String, String>> _days = [
    {'key': 'daily', 'label': 'Daily'},
    {'key': 'sun', 'label': 'Sun'},
    {'key': 'mon', 'label': 'Mon'},
    {'key': 'tue', 'label': 'Tue'},
    {'key': 'wed', 'label': 'Wed'},
    {'key': 'thu', 'label': 'Thu'},
    {'key': 'fri', 'label': 'Fri'},
    {'key': 'sat', 'label': 'Sat'},
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          margin: EdgeInsets.all(16.w),
          constraints: BoxConstraints(maxHeight: 600.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20.r,
                offset: Offset(0, 10.h),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200, width: 1.w),
                  ),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Create Love Reminder',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onClose,
                      child: Container(
                        width: 32.w,
                        height: 32.w,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 20,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      const Text(
                        'Title',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      TextField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          hintText: 'e.g., Take your medicine',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(12),
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Message
                      const Text(
                        'Message (Optional)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _messageController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Add a sweet message...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                            ),
                          ),
                          contentPadding: EdgeInsets.all(12.w),
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Time
                      const Text(
                        'Time',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 8.h),

                      // Time Presets
                      Row(
                        children: _timePresets.map((preset) {
                          final isSelected =
                              _formatTimeOfDay(_selectedTime) ==
                              preset['value'];

                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(right: 8.w),
                              child: GestureDetector(
                                onTap: () {
                                  final timeParts = preset['value']!.split(':');
                                  setState(() {
                                    _selectedTime = TimeOfDay(
                                      hour: int.parse(timeParts[0]),
                                      minute: int.parse(timeParts[1]),
                                    );
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8.w),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primaryLight
                                        : Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.primary
                                          : Colors.grey.shade200,
                                    ),
                                  ),
                                  child: Text(
                                    preset['label']!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: isSelected
                                          ? AppColors.primary
                                          : AppColors.textSecondary,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 12.h),

                      // Time Picker
                      GestureDetector(
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: _selectedTime,
                          );
                          if (time != null) {
                            setState(() {
                              _selectedTime = time;
                            });
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                color: AppColors.textLight,
                                size: 16,
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                _selectedTime.format(context),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Days
                      const Text(
                        'Repeat',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: _days.map((day) {
                          final isSelected = _selectedDays.contains(day['key']);

                          return GestureDetector(
                            onTap: () => _toggleDay(day['key']!),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primaryLight
                                    : Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.grey.shade200,
                                ),
                              ),
                              child: Text(
                                day['label']!,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 16.h),

                      // Emoji
                      const Text(
                        'Emoji (Optional)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          crossAxisSpacing: 8.w,
                          mainAxisSpacing: 8.h,
                          childAspectRatio: 1,
                        ),
                        itemCount: _emojiOptions.length,
                        itemBuilder: (context, index) {
                          final emoji = _emojiOptions[index];
                          final isSelected = _selectedEmoji == emoji;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedEmoji = isSelected ? '' : emoji;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.grey.shade200,
                                  width: 2,
                                ),
                                color: isSelected
                                    ? AppColors.primaryLight
                                    : Colors.transparent,
                              ),
                              child: Center(
                                child: Text(
                                  emoji,
                                  style: TextStyle(fontSize: 18.sp),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 16.h),

                      // Attachment Options
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(12.w),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.photo,
                                    color: Colors.blue,
                                    size: 16,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Photo',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(12.w),
                              decoration: BoxDecoration(
                                color: Colors.purple.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.mic,
                                    color: Colors.purple,
                                    size: 16,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Voice',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.purple,
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
              ),

              // Footer
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade200, width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: widget.onClose,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          backgroundColor: Colors.grey.shade100,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading || _titleController.text.isEmpty
                            ? null
                            : _createReminder,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: _isLoading
                            ? SizedBox(
                                width: 20.w,
                                height: 20.w,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.send,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Create Reminder',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
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
        ),
      ),
    );
  }

  void _toggleDay(String day) {
    setState(() {
      if (day == 'daily') {
        _selectedDays = ['daily'];
      } else {
        _selectedDays = _selectedDays.where((d) => d != 'daily').toList();
        if (_selectedDays.contains(day)) {
          _selectedDays.remove(day);
          if (_selectedDays.isEmpty) {
            _selectedDays = ['daily'];
          }
        } else {
          _selectedDays.add(day);
        }
      }
    });
  }

  String _formatTimeOfDay(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _createReminder() async {
    if (_titleController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final reminder = Reminder(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        message: _messageController.text.isEmpty
            ? null
            : _messageController.text,
        time: _formatTimeOfDay(_selectedTime),
        days: _selectedDays,
        emoji: _selectedEmoji.isEmpty ? null : _selectedEmoji,
        fromUserId: '1', // Mock user ID
        toUserId: '2', // Mock partner ID
        createdAt: DateTime.now(),
      );

      await context.read<ReminderProvider>().addReminder(reminder);
      widget.onClose();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating reminder: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
