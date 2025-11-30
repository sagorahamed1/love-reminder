import 'package:flutter/material.dart';
import '../models/reminder.dart';

class ReminderProvider with ChangeNotifier {
  List<Reminder> _reminders = [];
  bool _isLoading = false;

  List<Reminder> get reminders => _reminders;
  bool get isLoading => _isLoading;

  ReminderProvider() {
    _loadMockReminders();
  }

  void _loadMockReminders() {
    _reminders = [
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
        message: 'Time for Maghrib prayer 🕌',
        time: '18:30',
        days: ['daily'],
        emoji: '🕌',
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
        message: 'Good night, my dear! Sweet dreams 😴',
        time: '22:00',
        days: ['daily'],
        emoji: '😴',
        hasVoice: true,
        fromUserId: '2',
        toUserId: '1',
        completed: true,
        streak: 8,
        createdAt: DateTime.now(),
        fromPartner: true,
      ),
    ];
    notifyListeners();
  }

  Future<void> addReminder(Reminder reminder) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _reminders.add(reminder);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleReminder(String reminderId) async {
    final index = _reminders.indexWhere((r) => r.id == reminderId);
    if (index != -1) {
      final reminder = _reminders[index];
      final updatedReminder = reminder.copyWith(
        completed: !reminder.completed,
        completedAt: !reminder.completed ? DateTime.now() : null,
        streak: !reminder.completed ? reminder.streak + 1 : reminder.streak - 1,
      );

      _reminders[index] = updatedReminder;
      notifyListeners();
    }
  }

  List<Reminder> getFilteredReminders(String filter) {
    switch (filter) {
      case 'pending':
        return _reminders.where((r) => !r.completed).toList();
      case 'completed':
        return _reminders.where((r) => r.completed).toList();
      default:
        return _reminders;
    }
  }
}
