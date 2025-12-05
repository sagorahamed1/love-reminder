import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/memory_controller.dart';
import '../utils/app_colors.dart';
import 'custom_text.dart';

class CreateMemoryForm extends StatefulWidget {
  final VoidCallback? onSubmit;

  const CreateMemoryForm({super.key, this.onSubmit});

  @override
  State<CreateMemoryForm> createState() => _CreateMemoryFormState();
}

class _CreateMemoryFormState extends State<CreateMemoryForm> {
  final MemoryController _memoryController = Get.find<MemoryController>();
  
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String _selectedType = 'note';
  File? _selectedImage;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _submitMemory() async {
    if (_titleController.text.trim().isEmpty || 
        _contentController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all required fields',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (_selectedType == 'photo' && _selectedImage == null) {
      Get.snackbar(
        'Error',
        'Please select an image for photo memories',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _memoryController.addMemory(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        type: _selectedType,
        imageFile: _selectedImage,
      );

      // Clear form
      _titleController.clear();
      _contentController.clear();
      setState(() {
        _selectedImage = null;
        _isLoading = false;
      });

      Get.snackbar(
        'Success',
        'Memory added successfully!',
        backgroundColor: AppColors.primary,
        colorText: Colors.white,
      );

      if (widget.onSubmit != null) {
        widget.onSubmit!();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      Get.snackbar(
        'Error',
        'Failed to add memory: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(16.w),
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: 'Add New Memory',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              IconButton(
                onPressed: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }
                },
                icon: Icon(
                  Icons.close,
                  color: AppColors.textSecondary,
                  size: 24.sp,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 16.h),

          // Type Selection
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: ToggleButtons(
              borderRadius: BorderRadius.circular(12.r),
              isSelected: [_selectedType == 'note', _selectedType == 'photo'],
              onPressed: (index) {
                setState(() {
                  _selectedType = index == 0 ? 'note' : 'photo';
                });
              },
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.note,
                        size: 18.sp,
                        color: _selectedType == 'note' 
                            ? Colors.white 
                            : AppColors.textSecondary,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Note',
                        style: TextStyle(
                          color: _selectedType == 'note' 
                              ? Colors.white 
                              : AppColors.textSecondary,
                          fontWeight: _selectedType == 'note' 
                              ? FontWeight.bold 
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.photo_camera,
                        size: 18.sp,
                        color: _selectedType == 'photo' 
                            ? Colors.white 
                            : AppColors.textSecondary,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Photo',
                        style: TextStyle(
                          color: _selectedType == 'photo' 
                              ? Colors.white 
                              : AppColors.textSecondary,
                          fontWeight: _selectedType == 'photo' 
                              ? FontWeight.bold 
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              selectedColor: Colors.white,
              fillColor: AppColors.primary,
              color: AppColors.textSecondary,
            ),
          ),

          SizedBox(height: 16.h),

          // Title Field
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Title',
              hintText: 'Enter memory title...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // Content Field
          TextField(
            controller: _contentController,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: 'Description',
              hintText: 'Describe your memory...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
          ),

          if (_selectedType == 'photo') ...[
            SizedBox(height: 16.h),

            // Image Picker
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    if (_selectedImage != null)
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                        child: Image.file(
                          _selectedImage!,
                          height: 150.h,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    Container(
                      padding: EdgeInsets.all(16.w),
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_a_photo,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            _selectedImage != null 
                                ? 'Change Photo' 
                                : 'Select Photo',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          SizedBox(height: 24.h),

          // Submit Button
          ElevatedButton(
            onPressed: _isLoading ? null : _submitMemory,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: _isLoading 
                ? SizedBox(
                    width: 24.w,
                    height: 24.h,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    'Create Memory',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}