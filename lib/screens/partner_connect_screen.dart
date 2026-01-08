import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lovereminder/helpers/prefs_helper.dart';
import 'package:lovereminder/utils/app_constant.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:async';
import '../controllers/couple_controller.dart';

class PartnerConnectScreen extends StatefulWidget {
  const PartnerConnectScreen({super.key});

  @override
  State<PartnerConnectScreen> createState() => _PartnerConnectScreenState();
}

class _PartnerConnectScreenState extends State<PartnerConnectScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _partnerCodeController = TextEditingController();
  final CoupleController _coupleController = Get.put(CoupleController());

  int _minutesRemaining = 60; // Code expires in 60 minutes
  Timer? _timer;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  String inviteCode = "";

  @override
  void initState() {
    super.initState();
    _startTimer();
    _setupAnimations();
    _loadData();
  }


  void _loadData() async {
    await _coupleController.refreshData();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (_minutesRemaining > 0) {
        setState(() {
          _minutesRemaining--;
        });
      } else {
        timer.cancel();
        // Regenerate code when expired
        _coupleController.getLocalData();
        _minutesRemaining = 60;
        _startTimer();
      }
    });
  }

  void _copyCode() {
    final code = _coupleController.connectionCode.value;
    if (code.isEmpty) return;

    Clipboard.setData(ClipboardData(text: code));
    Get.snackbar(
      'Copied!',
      'Code copied to clipboard',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFF48FB1),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: EdgeInsets.only(
        bottom: 20.h,
        left: 20.w,
        right: 20.w,
      ),
    );
  }

  void _shareCode() {
    final code = _coupleController.connectionCode.value;
    if (code.isEmpty) return;

    Share.share(
      'Hey! Connect with me using this code: $code\n\nDownload the app and enter this code to share our journey together! 💕',
      subject: 'Partner Connection Code',
    );
  }

  Future<void> _connectWithPartner() async {
    final code = _partnerCodeController.text.trim();

    if (code.isEmpty) {
      Get.snackbar(
        'Invalid Code',
        'Please enter your partner\'s code',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (code.length < 6) {
      Get.snackbar(
        'Invalid Code',
        'Connection code must be at least 6 characters',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    // Connect with partner
    bool success = await _coupleController.connectPartner(code);

    if (success) {
      _partnerCodeController.clear();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _partnerCodeController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: 8.w),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black87,
                size: 18,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.offAllNamed('/main');
            },
            child: Text(
              'Skip',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: RefreshIndicator(
            onRefresh: () => _coupleController.refreshData(),
            color: const Color(0xFFF48FB1),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 10.h),

                    // Header
                    _buildHeader(),

                    SizedBox(height: 24.h),

                    // Your Code Card
                    Obx(() => _buildYourCodeCard()),

                    SizedBox(height: 16.h),

                    // OR Divider
                    _buildOrDivider(),

                    SizedBox(height: 16.h),

                    // Enter Partner Code Card
                    _buildEnterCodeCard(),

                    SizedBox(height: 20.h),

                    // Info Footer
                    _buildInfoFooter(),

                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF48FB1), Color(0xFFEC407A)],
                ),
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF48FB1).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.favorite,
                color: Colors.white,
                size: 28.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Connect Partner',
                    style: TextStyle(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF4A148C),
                    ),
                  ),
                  Text(
                    'Share your journey together',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF6A1B9A),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3E0),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: const Color(0xFFFFB74D).withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: const Color(0xFFFF6F00),
                size: 20.sp,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  'Your details will be shared with your partner including answers and journal entries.',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFFE65100),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildYourCodeCard() {
    final isLoading = _coupleController.isGeneratingCode.value;
    final code = _coupleController.connectionCode.value;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFCE4EC), Color(0xFFFFF0F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF48FB1).withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circle
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.all(14.w),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.qr_code_2_rounded,
                      color: const Color(0xFFF48FB1),
                      size: 18.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Your Code',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF880E4F),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),

                // Code Display
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 12.h,
                    horizontal: 20.w,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: isLoading
                      ? SizedBox(
                    height: 32.h,
                    child: Center(
                      child: SizedBox(
                        width: 24.w,
                        height: 24.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFFF48FB1),
                          ),
                        ),
                      ),
                    ),
                  )
                      : Text(
                    code.isEmpty ? 'LOADING' : code,
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFF48FB1),
                      letterSpacing: 6,
                    ),
                  ),
                ),

                SizedBox(height: 8.h),

                // Timer Badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        size: 14.sp,
                        color: const Color(0xFFFF6B6B),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'Expires in $_minutesRemaining min',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFFF6B6B),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 10.h),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: isLoading || code.isEmpty ? null : _copyCode,
                        icon: Icon(Icons.copy_rounded, size: 16.sp),
                        label: const Text('Copy'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFF48FB1),
                          disabledForegroundColor: Colors.grey,
                          side: BorderSide(
                            color: isLoading || code.isEmpty
                                ? Colors.grey.shade300
                                : const Color(0xFFF48FB1),
                            width: 1.5,
                          ),
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: isLoading || code.isEmpty ? null : _shareCode,
                        icon: Icon(Icons.share_rounded, size: 16.sp),
                        label: const Text('Share'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF48FB1),
                          disabledBackgroundColor: Colors.grey.shade300,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
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

  Widget _buildOrDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: Colors.grey.shade300,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 4.h,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
            child: Text(
              'OR',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: Colors.grey.shade300,
          ),
        ),
      ],
    );
  }

  Widget _buildEnterCodeCard() {
    return Obx(() {
      final isLoading = _coupleController.isLoadingConnect.value;

      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.link_rounded,
                  color: const Color(0xFF9C27B0),
                  size: 18.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Enter Partner\'s Code',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),

            // Input Field
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: _partnerCodeController.text.isNotEmpty
                      ? const Color(0xFF9C27B0).withOpacity(0.3)
                      : Colors.grey.shade200,
                  width: 1.5,
                ),
              ),
              child: TextField(
                controller: _partnerCodeController,
                textAlign: TextAlign.center,
                textCapitalization: TextCapitalization.characters,
                enabled: !isLoading,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 4,
                  color: const Color(0xFF9C27B0),
                ),
                decoration: InputDecoration(
                  hintText: 'Enter code',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade300,
                    fontSize: 16.sp,
                    letterSpacing: 2,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 14.h,
                    horizontal: 16.w,
                  ),
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),

            SizedBox(height: 14.h),

            // Connect Button
            SizedBox(
              width: double.infinity,
              height: 46.h,
              child: ElevatedButton(
                onPressed: isLoading || _partnerCodeController.text.isEmpty
                    ? null
                    : _connectWithPartner,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9C27B0),
                  disabledBackgroundColor: Colors.grey.shade300,
                  elevation: _partnerCodeController.text.isNotEmpty && !isLoading ? 4 : 0,
                  shadowColor: const Color(0xFF9C27B0).withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                child: isLoading
                    ? SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Connect Now',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    if (_partnerCodeController.text.isNotEmpty) ...[
                      SizedBox(width: 6.w),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 18.sp,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildInfoFooter() {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: const Color(0xFF81C784).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.security_rounded,
              color: Colors.white,
              size: 16.sp,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Secure Connection',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2E7D32),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Your data is encrypted end-to-end',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: const Color(0xFF388E3C),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}