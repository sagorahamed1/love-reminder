import 'package:get/get.dart';
import '../models/mood.dart';

class MoodController extends GetxController {
  Rxn<Mood> currentMood = Rxn<Mood>();
  Rxn<Mood> partnerMood = Rxn<Mood>();
  var moodHistory = <Mood>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadMockMoodData();
  }

  void _loadMockMoodData() {
    currentMood.value = Mood(
      id: '1',
      userId: '1',
      mood: 'love',
      note: 'Feeling so grateful for you today! 💕',
      timestamp: DateTime.now(),
    );
    partnerMood.value = Mood(
      id: '2',
      userId: '2',
      mood: 'happy',
      note: 'Had a great day at work!',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    );
    moodHistory.value = [
      Mood(
        id: '3',
        userId: '1',
        mood: 'love',
        note: 'Missing you so much!',
        timestamp: DateTime.now(),
      ),
      Mood(
        id: '4',
        userId: '2',
        mood: 'happy',
        note: 'Great day at work!',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      Mood(
        id: '5',
        userId: '1',
        mood: 'excited',
        note: 'Can\'t wait for our date tonight!',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      ),
    ];
    update();
  }
}
