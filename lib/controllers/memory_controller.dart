import 'dart:io';
import 'dart:convert';
import 'package:get/get.dart';
import '../models/memory.dart';
import '../services/api_client.dart';
import '../services/api_constants.dart';

class MemoryController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getMemories();
  }

  RxInt currentPage = 1.obs;
  var totalPages = 0;
  var totalResults = 0;

  void loadMore() {
    print(
      "==========================================total page $totalPages page No: ${currentPage.value} == total result $totalResults",
    );
    if (totalPages > currentPage.value) {
      currentPage.value += 1;
      getMemories();
      print("**********************loading more memories");
      update();
    }
    print("**********************end of load more**************");
  }

  RxBool isLoading = false.obs;
  RxList<Memory> memories = <Memory>[].obs;

  Future<void> getMemories({bool isRefresh = false}) async {
    if (isRefresh) {
      currentPage.value = 1;
      memories.clear();
    } else if (currentPage.value == 1) {
      isLoading.value = true;
      memories.clear();
    }

    try {
      var response = await ApiClient.getData(
        '/memory?limit=10&page=${currentPage.value}',
      );

      if (response.statusCode == 200) {
        totalPages = response.body['pagination']['totalPages'] ?? 0;
        totalResults = response.body['pagination']['totalCount'] ?? 0;

        var data = List<Memory>.from(
          response.body["data"].map((x) => Memory.fromJson(x)),
        );
        memories.addAll(data);
      } else {
        throw Exception('Failed to load memories: ${response.statusText}');
      }
    } catch (e) {
      print('Error loading memories: $e');
    } finally {
      isLoading.value = false;
      update();
    }
  }

  RxBool isCreating = false.obs;

  Future<bool> createMemory({
    required String title,
    required String message,
    required List<String> tags,
    required String dateTime,
    required List<String> images,
  }) async {
    isCreating.value = true;

    try {
      var body = {
        'title': title,
        'message': message,
        'tags': tags,
        'dateTime': dateTime,
        'images': images,
      };

      var response = await ApiClient.postData(
        '/memory',
        jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Refresh the list after creating a new memory
        currentPage.value = 1;
        memories.clear();
        await getMemories();
        return true;
      } else {
        throw Exception('Failed to create memory: ${response.statusText}');
      }
    } catch (e) {
      print('Error creating memory: $e');
      return false;
    } finally {
      isCreating.value = false;
      update();
    }
  }

  // Upload images and get URLs
  Future<List<String>> uploadImages(List<File> imageFiles) async {
    try {
      List<String> imageUrls = [];

      // For each image file, upload and get URL
      for (File imageFile in imageFiles) {
        var response = await ApiClient.postMultipartData(
          '/upload/multiple',
          {}, // No additional body parameters
          multipartBody: [MultipartBody('files', imageFile)],
        );

        if (response.statusCode == 201) {
          List<String> uploadedFiles = List<String>.from(response.body['data']);
          imageUrls.addAll(uploadedFiles.map((x) => "${ApiConstants.imageBaseUrl}$uploadedFiles"));
        } else {
          throw Exception('Failed to upload image: ${response.statusText}');
        }
      }

      return imageUrls;
    } catch (e) {
      print('Error uploading images: $e');
      throw Exception('Failed to upload images: $e');
    }
  }

  // Delete a memory
  Future<bool> deleteMemory(String memoryId) async {
    try {
      var response = await ApiClient.deleteData('/memory/$memoryId');

      if (response.statusCode == 200) {
        // Remove the deleted memory from the local list
        memories.removeWhere((memory) => memory.id == memoryId);
        update();
        return true;
      } else {
        throw Exception('Failed to delete memory: ${response.statusText}');
      }
    } catch (e) {
      print('Error deleting memory: $e');
      return false;
    }
  }

  // Toggle favorite status for a memory
  Future<bool> toggleFavorite(String memoryId, bool isCurrentlyFavorited) async {
    try {
      String endpoint = isCurrentlyFavorited
          ? '/memory/$memoryId/unfavorite'
          : '/memory/$memoryId/favorite';

      var response = await ApiClient.postData(endpoint, jsonEncode({}));

      if (response.statusCode == 200) {
        // Update the favorite status in the local list
        final index = memories.indexWhere((memory) => memory.id == memoryId);
        if (index != -1) {
          memories[index] = Memory(
            id: memories[index].id,
            senderId: memories[index].senderId,
            receiverId: memories[index].receiverId,
            title: memories[index].title,
            message: memories[index].message,
            tags: memories[index].tags,
            dateTime: memories[index].dateTime,
            images: memories[index].images,
            createdAt: memories[index].createdAt,
            updatedAt: memories[index].updatedAt,
            favBy: memories[index].favBy,
            isSender: memories[index].isSender,
            isFavorited: !isCurrentlyFavorited, // Toggle the status
            sender: memories[index].sender,
            receiver: memories[index].receiver,
          );
          update();
        }
        return true;
      } else {
        throw Exception('Failed to toggle favorite: ${response.statusText}');
      }
    } catch (e) {
      print('Error toggling favorite: $e');
      return false;
    }
  }
}
