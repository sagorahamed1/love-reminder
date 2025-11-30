import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/floating_action_button.dart';
import 'reminders_screen.dart';
import 'memory_screen.dart';
import 'mood_screen.dart';
import 'stats_screen.dart';
import 'settings_screen.dart';
import '../widgets/create_reminder_modal.dart';

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
    const StatsScreen(),
    const SettingsScreen(),
  ];

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Container(
  //       decoration: const BoxDecoration(
  //         gradient: AppColors.backgroundGradient,
  //       ),
  //       child: Column(
  //         children: [
  //           const CustomAppBar(),
  //           Expanded(
  //             child: _screens[_currentIndex],
  //           ),
  //         ],
  //       ),
  //     ),
  //     bottomNavigationBar: CustomBottomNavigation(
  //       currentIndex: _currentIndex,
  //       onTap: (index) {
  //         setState(() {
  //           _currentIndex = index;
  //         });
  //       },
  //     ),
  //     floatingActionButton: CustomFloatingActionButton(
  //       onPressed: () {
  //         setState(() {
  //           _showCreateModal = true;
  //         });
  //       },
  //     ),
  //     floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
  //     body: _showCreateModal
  //         ? Stack(
  //             children: [
  //               _screens[_currentIndex],
  //               CreateReminderModal(
  //                 onClose: () {
  //                   setState(() {
  //                     _showCreateModal = false;
  //                   });
  //                 },
  //               ),
  //             ],
  //           )
  //         : Container(
  //             decoration: const BoxDecoration(
  //               gradient: AppColors.backgroundGradient,
  //             ),
  //             child: Column(
  //               children: [
  //                 const CustomAppBar(),
  //                 Expanded(
  //                   child: _screens[_currentIndex],
  //                 ),
  //               ],
  //             ),
  //           ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () {
          setState(() {
            _showCreateModal = true;
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
