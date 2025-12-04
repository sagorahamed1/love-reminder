import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../services/shared_prefs_service.dart';
import '../../utils/app_colors.dart';
import '../../widgets/custom_text.dart';
import 'onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late AnimationController _titleController;
  late AnimationController _contentController;
  late AnimationController _buttonController;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'How It Works',
      subtitle: 'Share beautiful moments with your partner',
      description: 'Create memories together and save them forever in your shared space',
      icon: Icons.auto_awesome,
      iconColor: AppColors.primary,
    ),
    OnboardingPage(
      title: 'Share Memories',
      subtitle: 'Capture precious moments',
      description: 'Upload photos and stories from your special moments together',
      icon: Icons.photo_library,
      iconColor: AppColors.secondary,
    ),
    OnboardingPage(
      title: 'Share Moods',
      subtitle: 'Know how your partner feels',
      description: 'Express your daily mood and see how your partner is feeling',
      icon: Icons.mood,
      iconColor: AppColors.success,
    ),
  ];

  @override
  void initState() {
    super.initState();

    _titleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _contentController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Start animations on first page
    _startAnimations();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _titleController.dispose();
    _contentController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  void _startAnimations() {
    _titleController.reset();
    _contentController.reset();
    _buttonController.reset();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _titleController.forward();
      _contentController.forward();
      _buttonController.forward();
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
    _startAnimations();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Complete onboarding and navigate to main screen
      _completeOnboarding();
    }
  }

  void _completeOnboarding() async {
    // Mark onboarding as completed in shared preferences
    await SharedPrefsService.setOnboardingComplete(true);

    // Navigate to main screen
    Get.offAllNamed('/main');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Progress indicator
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    width: _currentPage == index ? 24.w : 8.w,
                    height: 8.h,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? AppColors.primary
                          : AppColors.primary.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: _pages.length,
                  itemBuilder: (context, index) => _buildPage(index),
                ),
              ),

              // Next button with animation
              AnimationLimiter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                  child: AnimationConfiguration.staggeredGrid(
                    position: 0,
                    duration: const Duration(milliseconds: 375),
                    columnCount: 1,
                    child: ScaleAnimation(
                      scale: 0.8,
                      duration: _buttonController.duration,
                      delay: _buttonController.duration! * 0.8,
                      child: FadeInAnimation(
                        child: Container(
                          height: 56.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: _nextPage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              elevation: 0,
                            ),
                            child: CustomText(
                              text: _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(int index) {
    return AnimationLimiter(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated title
          AnimationConfiguration.staggeredGrid(
            position: 0,
            duration: const Duration(milliseconds: 375),
            columnCount: 1,
            child: SlideAnimation(
              horizontalOffset: 50,
              child: FadeInAnimation(
                child: CustomText(
                  text: _pages[index].title,
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),

          SizedBox(height: 8.h),

          // Animated subtitle
          AnimationConfiguration.staggeredGrid(
            position: 1,
            duration: const Duration(milliseconds: 375),
            columnCount: 1,
            child: SlideAnimation(
              horizontalOffset: 50,
              child: FadeInAnimation(
                child: CustomText(
                  text: _pages[index].subtitle,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),

          SizedBox(height: 40.h),

          // Animated icon
          AnimationConfiguration.staggeredGrid(
            position: 2,
            duration: const Duration(milliseconds: 375),
            columnCount: 1,
            child: ScaleAnimation(
              scale: 0.8,
              child: FadeInAnimation(
                child: Container(
                  width: 120.w,
                  height: 120.w,
                  decoration: BoxDecoration(
                    color: _pages[index].iconColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(24.r),
                    border: Border.all(
                      color: _pages[index].iconColor.withValues(alpha: 0.2),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    _pages[index].icon,
                    size: 60.sp,
                    color: _pages[index].iconColor,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 40.h),

          // Animated description
          AnimationConfiguration.staggeredGrid(
            position: 3,
            duration: const Duration(milliseconds: 375),
            columnCount: 1,
            child: SlideAnimation(
              verticalOffset: 50,
              child: FadeInAnimation(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.w),
                  child: CustomText(
                    text: _pages[index].description,
                    fontSize: 16.sp,
                    color: AppColors.textSecondary,
                    textAlign: TextAlign.center,
                    maxline: 3,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}