import 'package:get/get.dart';
import '../models/reminder.dart';

class ReminderController extends GetxController {
  var reminders = <Reminder>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadMockReminders();
  }

  void _loadMockReminders() {
    reminders.value = [
      Reminder(
        id: '1',
        title: 'Take your medicine',
        message: 'Don\'t forget your vitamins, my love! 💊',
        time: '08:00',
        days: ['daily'],
        emoji: '💊',
        hasVoice: true,
        fromUserId: '2',
        toUserId: '1',
        streak: 5,
        createdAt: DateTime.now(),
        fromPartner: true,
      ),
      Reminder(
        id: '2',
        title: 'Maghrib Prayer Time',
        message: 'Time for Maghrib prayer 🕔',
        time: '18:30',
        days: ['daily'],
        emoji: '🕔',
        hasPhoto: true,
        fromUserId: '1',
        toUserId: '2',
        completed: true,
        streak: 12,
        createdAt: DateTime.now(),
      ),
      Reminder(
        id: '3',
        title: 'Drink Water',
        message: 'Stay hydrated, sweetheart! 💧',
        time: '14:00',
        days: ['daily'],
        emoji: '💧',
        fromUserId: '2',
        toUserId: '1',
        streak: 3,
        createdAt: DateTime.now(),
        fromPartner: true,
      ),
      Reminder(
        id: '4',
        title: 'Sleep Time',
        message: 'Good night, love! 😴',
        time: '23:00',
        days: ['daily'],
        emoji: '😴',
        fromUserId: '1',
        toUserId: '2',
        streak: 7,
        createdAt: DateTime.now(),
      ),
    ];
    update();
  }
}
