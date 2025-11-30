import 'package:get/get.dart';
import '../models/memory.dart';

class MemoryController extends GetxController {
  var memories = <Memory>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadMockMemories();
  }

  void _loadMockMemories() {
    memories.value = [
      Memory(
        id: '1',
        title: 'Our First Date',
        content:
            'Such a beautiful evening at the park. I will never forget how nervous and excited I was! 💕',
        type: 'photo',
        imageUrl:
            'https://images.pexels.com/photos/1024993/pexels-photo-1024993.jpeg?auto=compress&cs=tinysrgb&w=800',
        coupleId: '1',
        createdBy: '1',
        createdAt: DateTime.parse('2024-01-15T18:30:00Z'),
        tags: ['date', 'park', 'first'],
      ),
      Memory(
        id: '2',
        title: 'Wedding Day',
        content:
            'The most beautiful day of our lives. Alhamdulillah for bringing us together! 🙲',
        type: 'photo',
        imageUrl:
            'https://images.pexels.com/photos/1024993/pexels-photo-1024993.jpeg?auto=compress&cs=tinysrgb&w=800',
        coupleId: '1',
        createdBy: '2',
        createdAt: DateTime.parse('2024-02-20T16:00:00Z'),
        tags: ['wedding', 'nikah', 'special'],
      ),
      Memory(
        id: '3',
        title: 'Love Note',
        content:
            'Just wanted to remind you how much you mean to me. You make every day brighter! ✨',
        type: 'note',
        coupleId: '1',
        createdBy: '1',
        createdAt: DateTime.parse('2024-03-10T09:15:00Z'),
        tags: ['love', 'note', 'sweet'],
      ),
    ];
    update();
  }
}
