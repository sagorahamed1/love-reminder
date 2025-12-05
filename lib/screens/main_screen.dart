import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/floating_action_button.dart';
import '../widgets/create_memory_form.dart';
import 'reminders_screen.dart';
import 'memory_screen.dart';
import 'mood_screen.dart';
import 'settings_screen.dart';
import '../widgets/create_reminder_modal.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  bool _showCreateModal = false;

  final List<Widget> _screens = [
    const RemindersScreen(),
    const MemoryScreen(),
    const MoodScreen(),
    const SettingsScreen(),
  ];

  // Show appropriate modal based on current screen
  void _showCreateDialog() {
    if (_currentIndex == 0) {
      // Reminders screen
      setState(() {
        _showCreateModal = true;
      });
    } else if (_currentIndex == 1) {
      // Memory screen
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.all(16.r),
            child: CreateMemoryForm(
              onSubmit: () {
                Navigator.of(context).pop();
              },
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Add back button handling
      onWillPop: () async {
        // On Android, if the current screen is not the first screen (reminders),
        // navigate back to reminders screen instead of closing the app
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
          return false; // Don't exit the app
        }
        return true; // Exit the app
      },
      child: Scaffold(
        extendBody: true, // Extend body to behind bottom navigation
        body: _showCreateModal
            ? Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: AppColors.backgroundGradient,
                    ),
                    child: Column(
                      children: [
                        const CustomAppBar(),
                        Expanded(child: _screens[_currentIndex]),
                      ],
                    ),
                  ),
                  CreateReminderModal(
                    onClose: () {
                      setState(() {
                        _showCreateModal = false;
                      });
                    },
                  ),
                ],
              )
            : Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.backgroundGradient,
                ),
                child: Column(
                  children: [
                    const CustomAppBar(),
                    Expanded(child: _screens[_currentIndex]),
                  ],
                ),
              ),
        bottomNavigationBar: CustomBottomNavigation(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        floatingActionButton:
            _currentIndex <
                2 // Show FAB only on Reminders and Memory screens
            ? CustomFloatingActionButton(
                onPressed: _showCreateDialog,
                icon: _currentIndex == 0
                    ? Icons.add
                    : Icons.add_photo_alternate,
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
