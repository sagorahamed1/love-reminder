import 'dart:convert';
import 'package:get/get.dart';
import '../models/mood.dart';
import '../services/api_client.dart';
import '../services/api_constants.dart';

class MoodController extends GetxController {
  // Loading states
  var isLoading = false.obs;
  var shareMoodLoading = false.obs;
  var partnerCurrentMoodLoading = false.obs;

  // Pagination
  RxInt currentPage = 1.obs;
  var totalPages = 0;
  var totalResults = 0;

  // Data
  RxList<MoodModel> moods = <MoodModel>[].obs;
  Rx<MoodModel?> partnerMood = Rx<MoodModel?>(null);

  @override
  void onInit() {
    super.onInit();
    // Load initial data
    _initializeData();
  }

  // Initialize data on screen load
  Future<void> _initializeData() async {
    await Future.wait([
      getMood(),
      getPartnerCurrentMood(),
    ]);
  }

  // Share mood with partner
  Future<bool> shareMood({required String type, String? message}) async {
    try {
      shareMoodLoading(true);

      var body = {
        "type": type,
        if (message != null && message.isNotEmpty) "message": message,
      };

      var response = await ApiClient.postData(
        ApiConstants.mood,
        jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Refresh mood list after successful share
        await getMood(isRefresh: true);

        // Show success message
        Get.snackbar(
          'Success',
          'Mood shared successfully',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );

        shareMoodLoading(false);
        return true;
      } else {
        throw Exception(response.body['message'] ?? 'Failed to share mood');
      }
    } catch (e) {
      print('Error sharing mood: $e');
      Get.snackbar(
        'Error',
        'Failed to share mood. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
      shareMoodLoading(false);
      return false;
    }
  }

  // Get mood history with pagination
  Future<void> getMood({bool isRefresh = false}) async {
    if (isRefresh) {
      currentPage.value = 1;
      moods.clear();
    } else if (currentPage.value == 1) {
      isLoading.value = true;
      moods.clear();
    }

    try {
      var response = await ApiClient.getData(
        // '/mood/partner/history?limit=10&page=${currentPage.value}',
        '/mood/history?limit=10&page=${currentPage.value}',

      );

      if (response.statusCode == 200) {
        totalPages = response.body['pagination']?['totalPages'] ?? 0;
        totalResults = response.body['pagination']?['totalCount'] ?? 0;

        if (response.body["data"] != null) {
          var data = List<MoodModel>.from(
            response.body["data"].map((x) => MoodModel.fromJson(x)),
          );

          // Filter out deleted moods
          var filteredData = data.where((mood) => mood.isDeleted != true).toList();

          moods.addAll(data);
        }
      } else {
        throw Exception(response.body['message'] ?? 'Failed to load moods');
      }
    } catch (e) {
      print('Error loading moods: $e');
      if (currentPage.value == 1) {
        Get.snackbar(
          'Error',
          'Failed to load mood history',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isLoading.value = false;
      update();
    }
  }

  // Load more moods (pagination)
  void loadMore() {
    if (totalPages > currentPage.value) {
      currentPage.value += 1;
      getMood();
    }
  }

  // Get partner's current mood
  Future<void> getPartnerCurrentMood() async {
    try {
      partnerCurrentMoodLoading(true);

      var response = await ApiClient.getData("/mood/current");

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body['data'] != null) {
          partnerMood.value = MoodModel.fromJson(response.body['data']);
        } else {
          partnerMood.value = null;
        }
      } else {
        partnerMood.value = null;
      }
    } catch (e) {
      print('Error loading partner mood: $e');
      partnerMood.value = null;
    } finally {
      partnerCurrentMoodLoading(false);
      update();
    }
  }

  // Refresh all data
  Future<void> refreshAll() async {
    await Future.wait([
      getMood(isRefresh: true),
      getPartnerCurrentMood(),
    ]);
  }

  // Get mood history (legacy support)
  List<MoodModel> get moodHistory => moods.toList();
}