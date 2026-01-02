import 'dart:convert';

import 'package:get/get.dart';
import '../models/getreminder_model.dart';
import '../services/api_client.dart';
import '../services/api_constants.dart';

class ReminderController extends GetxController {
  @override
  void onInit() {
    super.onInit();
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
      getReminders();
      print("**********************loading more reminders");
      update();
    }
    print("**********************end of load more**************");
  }

  RxBool isLoading = false.obs;
  RxList<GetReminderModel> reminders = <GetReminderModel>[].obs;

  Future<void> getReminders({bool isRefresh = false}) async {
    if (isRefresh) {
      currentPage.value = 1;
      reminders.clear();
    } else if (currentPage.value == 1) {
      isLoading.value = true;
      reminders.clear();
    }

    try {
      var response = await ApiClient.getData(
        '${ApiConstants.getReminder(currentPage.value.toString())}',
      );

      if (response.statusCode == 200) {
        totalPages = response.body['pagination']['totalPages'] ?? 0;
        totalResults = response.body['pagination']['totalCount'] ?? 0;

        var data = List<GetReminderModel>.from(
          response.body["data"].map((x) => GetReminderModel.fromJson(x)),
        );
        reminders.addAll(data);
      } else {
        throw Exception('Failed to load reminders: ${response.statusText}');
      }
    } catch (e) {
      print('Error loading reminders: $e');
    } finally {
      isLoading.value = false;
      update();
    }
  }

  RxBool isCreating = false.obs;

  Future<bool> createReminder({
    required String title,
    required String message,
    required String repeat,
    required String date,
    required String time,
    required String emoji,
  }) async {
    isCreating.value = true;

    try {
      // Format date to match API format: "2026-01-10T00:00:00.000Z"
      DateTime parsedDate = DateTime.parse(date);
      String formattedDate = parsedDate.toIso8601String().replaceFirst(RegExp(r'\.\d+Z$'), '.000Z');

      var body = {
        'title': title,
        'message': message,
        'repeat': repeat,
        'date': formattedDate,
        'time': time,
        'emoji': emoji,
      };

      var response = await ApiClient.postData(
        '/reminder',
        jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Refresh the list after creating a new reminder
        currentPage.value = 1;
        reminders.clear();
        await getReminders();
        return true;
      } else {
        throw Exception('Failed to create reminder: ${response.statusText}');
      }
    } catch (e) {
      print('Error creating reminder: $e');
      return false;
    } finally {
      isCreating.value = false;
      update();
    }
  }

  // Toggle reminder completion status
  Future<bool> toggleReminderCompletion(String reminderId, bool currentStatus) async {
    try {
      var body = {
        'completed': !currentStatus,
      };

      var response = await ApiClient.patch(
        '/reminder/$reminderId',
        jsonEncode(body),
      );

      if (response.statusCode == 200) {
        // Update the local list
        final index = reminders.indexWhere((r) => r.id == reminderId);
        if (index != -1) {
          reminders[index] = GetReminderModel(
            id: reminders[index].id,
            senderId: reminders[index].senderId,
            receiverId: reminders[index].receiverId,
            title: reminders[index].title,
            message: reminders[index].message,
            repeat: reminders[index].repeat,
            date: reminders[index].date,
            time: reminders[index].time,
            emoji: reminders[index].emoji,
            completed: !currentStatus, // Toggle the status
            createdAt: reminders[index].createdAt,
            updatedAt: reminders[index].updatedAt,
            v: reminders[index].v,
            isOwn: reminders[index].isOwn,
            sender: reminders[index].sender,
            receiver: reminders[index].receiver,
            getReminderModelId: reminders[index].getReminderModelId,
          );
          update();
        }
        return true;
      } else {
        throw Exception('Failed to update reminder: ${response.statusText}');
      }
    } catch (e) {
      print('Error updating reminder: $e');
      return false;
    }
  }
}
