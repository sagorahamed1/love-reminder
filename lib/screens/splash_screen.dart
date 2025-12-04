import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/auth_controller.dart';
import '../screens/auth/login_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../services/shared_prefs_service.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_text.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward();

    // Auto navigate based on auth and onboarding status after splash
    Future.delayed(const Duration(seconds: 3), () async {
      if (mounted) {
        final authController = Get.find<AuthController>();
        final isAuthenticated = authController.isAuthenticated;
        final hasCompletedOnboarding = await SharedPrefsService.isOnboardingComplete;

        // Remove the mock login since we want real authentication
        // Get.find<AuthController>().mockLogin();

        if (!isAuthenticated) {
          // User not logged in, show login screen
          Get.offAllNamed('/login');
        } else if (!hasCompletedOnboarding) {
          // User is logged in but hasn't completed onboarding
          Get.offAllNamed('/onboarding');
        } else {
          // User is logged in and has completed onboarding
          Get.offAllNamed('/main');
        }
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Heart Icon with Pulse Animation
                      Container(
                        width: 120.w,
                        height: 120.w,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.favorite,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 32.h),

                      // App Title
                      CustomText(
                        text: 'My Love Reminder',
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.h),

                      // Subtitle
                      CustomText(
                        text: 'Loading your love story...',
                        fontSize: 16,
                        color: AppColors.textSecondary,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 48.h),

                      // Loading Indicator
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
