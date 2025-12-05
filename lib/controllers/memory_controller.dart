import 'dart:io';
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

  Future<void> addMemory({
    required String title,
    required String content,
    required String type,
    File? imageFile,
  }) async {
    isLoading.value = true;

    try {
      // In a real app, you would upload the image to Firebase Storage
      // For now, we'll use a placeholder URL when imageFile is provided
      String? imageUrl;
      if (imageFile != null) {
        // In a production app, you'd upload the image here and get the URL
        // For now, using a placeholder image URL
        imageUrl = 'https://via.placeholder.com/600x400.png?text=Memory+Photo';
      }

      // Create a new memory with a unique ID
      final newMemory = Memory(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // Simple ID generation
        title: title,
        content: content,
        type: type,
        imageUrl: imageUrl,
        coupleId: '1', // Assuming default couple ID for now
        createdBy: '1', // Assuming current user ID
        createdAt: DateTime.now(),
        tags: [], // Empty tags for new memories
      );

      // Add to the beginning of the list (most recent first)
      memories.insert(0, newMemory);
      update();
    } catch (e) {
      throw Exception('Failed to add memory: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
