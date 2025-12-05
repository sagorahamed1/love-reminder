import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/auth_controller.dart';
import '../controllers/couple_controller.dart';
import '../controllers/theme_controller.dart';
import '../utils/app_colors.dart';
import '../widgets/connection_code_card.dart';
import '../widgets/settings_section.dart';
import '../widgets/theme_selector.dart';
import '../widgets/custom_text.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  bool _sounds = true;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (authController) {
        return GetBuilder<CoupleController>(
          builder: (coupleController) {
            return GetBuilder<ThemeController>(
              builder: (themeController) {
                return Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      CustomText(
                        text: 'Settings',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        textAlign: TextAlign.left,
                      ),

                      CustomText(
                        text: 'Customize your love reminder experience',

                        color: AppColors.textSecondary,
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 10.h),

                      Expanded(
                        child: SingleChildScrollView(
                          physics:
                              const BouncingScrollPhysics(), // Better scroll physics
                          child: Column(
                            children: [
                              ConnectionCodeCard(
                                connectionCode:
                                    coupleController.connectionCode.value,
                                onGenerateNew: () {
                                  coupleController.generateNewCode();
                                },
                              ),

                              SizedBox(height: 10.h),

                              // Profile Section
                              SettingsSection(
                                title: 'Profile',
                                items: [
                                  SettingsItem(
                                    icon: Icons.person,
                                    title: 'Personal Info',
                                    subtitle:
                                        authController.user.value?.name ??
                                        'Update name',
                                    onTap: () {
                                      // Handle profile edit
                                    },
                                  ),
                                  SettingsItem(
                                    icon: Icons.favorite,
                                    title: 'Partner Connection',
                                    subtitle:
                                        coupleController.partner.value != null
                                        ? 'Connected to ${coupleController.partner.value!.name}'
                                        : 'Not connected',
                                    onTap: () {
                                      // Handle connection management
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 24.h),

                              // // Preferences Section
                              // SettingsSection(
                              //   title: 'Preferences',
                              //   items: [
                              //     SettingsItem(
                              //       icon: Icons.notifications,
                              //       title: 'Notifications',
                              //       subtitle: _notifications
                              //           ? 'Enabled'
                              //           : 'Disabled',
                              //       trailing: Switch(
                              //         value: _notifications,
                              //         onChanged: (value) {
                              //           setState(() {
                              //             _notifications = value;
                              //           });
                              //         },
                              //         activeColor: AppColors.primary,
                              //       ),
                              //       onTap: () {
                              //         setState(() {
                              //           _notifications = !_notifications;
                              //         });
                              //       },
                              //     ),
                              //     SettingsItem(
                              //       icon: Icons.volume_up,
                              //       title: 'Sounds',
                              //       subtitle: _sounds ? 'On' : 'Off',
                              //       trailing: Switch(
                              //         value: _sounds,
                              //         onChanged: (value) {
                              //           setState(() {
                              //             _sounds = value;
                              //           });
                              //         },
                              //         activeColor: AppColors.primary,
                              //       ),
                              //       onTap: () {
                              //         setState(() {
                              //           _sounds = !_sounds;
                              //         });
                              //       },
                              //     ),
                              //     SettingsItem(
                              //       icon: Icons.palette,
                              //       title: 'Theme',
                              //       subtitle: themeController.currentTheme.value
                              //           .toUpperCase(),
                              //       onTap: () {
                              //         // Handle theme selection
                              //       },
                              //     ),
                              //   ],
                              // ),
                              // SizedBox(height: 24.h),

                              // Theme Selector
                              // ThemeSelector(
                              //   currentTheme:
                              //       themeController.currentTheme.value,
                              //   onThemeChanged: (theme) {
                              //     themeController.setTheme(theme);
                              //   },
                              // ),
                              // SizedBox(height: 24.h),

                              // Privacy Section
                              SettingsSection(
                                title: 'Privacy & Security',
                                items: [
                                  SettingsItem(
                                    icon: Icons.security,
                                    title: 'Privacy Settings',
                                    subtitle: 'View and manage your privacy',
                                    onTap: () {
                                      // Handle privacy settings
                                    },
                                  ),

                                  SettingsItem(
                                    icon: Icons.security,
                                    title: 'Terms of Service',
                                    subtitle: 'view terms and conditions',
                                    onTap: () {
                                      // Handle privacy settings
                                    },
                                  ),

                                  SettingsItem(
                                    icon: Icons.security,
                                    title: 'About Us',
                                    subtitle: 'view terms and conditions',
                                    onTap: () {
                                      // Handle privacy settings
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 24.h),

                              // Logout Button
                              Container(
                                width: double.infinity,

                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: Colors.red.shade200,
                                  ),
                                ),
                                child: TextButton.icon(
                                  onPressed: () {
                                    authController.logout();
                                  },
                                  icon: const Icon(
                                    Icons.logout,
                                    color: Colors.red,
                                  ),
                                  label: const Text(
                                    'Sign Out',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
