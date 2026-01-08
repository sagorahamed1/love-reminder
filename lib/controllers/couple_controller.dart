import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/user.dart';
import '../services/api_client.dart';
import '../services/api_constants.dart';

class CoupleController extends GetxController {
  // Partner info
  Rxn<User> partner = Rxn<User>();

  // Connection data
  var connectionCode = ''.obs;
  var connectionStreak = 0.obs;
  var isConnected = false.obs;

  // Loading states
  var isLoadingConnect = false.obs;
  var isLoadingDisconnect = false.obs;
  var isLoadingPartnerInfo = false.obs;
  var isGeneratingCode = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Load partner info when controller initializes
    getPartnerInfo();
    generateConnectionCode();
  }

  // Generate connection code for current user
  Future<void> generateConnectionCode() async {
    try {
      isGeneratingCode(true);

      var response = await ApiClient.getData('/user/generate-code');

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body['data'] != null &&
            response.body['data']['code'] != null) {
          connectionCode.value = response.body['data']['code'];
        }
      } else {
        throw Exception(response.body['message'] ?? 'Failed to generate code');
      }
    } catch (e) {
      print('Error generating connection code: $e');
      // Generate a fallback code (you can customize this)
      connectionCode.value = _generateFallbackCode();
    } finally {
      isGeneratingCode(false);
    }
  }

  // Fallback code generator
  String _generateFallbackCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(
      6,
          (index) => chars[(DateTime.now().millisecondsSinceEpoch + index) % chars.length],
    ).join();
  }

  // Connect with partner using their code
  Future<bool> connectPartner(String code) async {
    if (code.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a valid code',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return false;
    }

    try {
      isLoadingConnect(true);

      var body = jsonEncode({"code": code.toUpperCase().trim()});

      var response = await ApiClient.postData(
        '/user/connect-partner',
        body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Connection successful
        isConnected(true);

        // Get partner info
        if (response.body['data'] != null &&
            response.body['data']['partner'] != null) {
          partner.value = User.fromJson(response.body['data']['partner']);
        }

        // Update connection streak if available
        if (response.body['data'] != null &&
            response.body['data']['connectionStreak'] != null) {
          connectionStreak.value = response.body['data']['connectionStreak'];
        }

        // Refresh partner info
        await getPartnerInfo();

        Get.snackbar(
          'Success',
          'Connected with your partner successfully! 💕',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF4CAF50),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        // Navigate to main screen after successful connection
        Future.delayed(const Duration(seconds: 1), () {
          Get.offAllNamed('/main');
        });

        return true;
      } else {
        String errorMessage = response.body['message'] ?? 'Failed to connect';

        Get.snackbar(
          'Connection Failed',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
          duration: const Duration(seconds: 3),
        );

        return false;
      }
    } catch (e) {
      print('Error connecting partner: $e');

      Get.snackbar(
        'Error',
        'Failed to connect. Please check your internet connection and try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        duration: const Duration(seconds: 3),
      );

      return false;
    } finally {
      isLoadingConnect(false);
      update();
    }
  }

  // Disconnect from partner
  Future<bool> disconnectPartner() async {
    try {
      // Show confirmation dialog
      bool? confirmed = await Get.dialog<bool>(
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Disconnect Partner?'),
          content: const Text(
            'Are you sure you want to disconnect from your partner? All shared data will remain but you won\'t be connected anymore.',
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Get.back(result: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Disconnect'),
            ),
          ],
        ),
      );

      if (confirmed != true) return false;

      isLoadingDisconnect(true);

      var response = await ApiClient.postData(
        '/user/disconnect-partner',
        '',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Disconnection successful
        isConnected(false);
        partner.value = null;
        connectionStreak.value = 0;

        Get.snackbar(
          'Disconnected',
          'You have been disconnected from your partner',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        return true;
      } else {
        throw Exception(response.body['message'] ?? 'Failed to disconnect');
      }
    } catch (e) {
      print('Error disconnecting partner: $e');

      Get.snackbar(
        'Error',
        'Failed to disconnect. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );

      return false;
    } finally {
      isLoadingDisconnect(false);
      update();
    }
  }

  // Get partner information
  Future<void> getPartnerInfo() async {
    try {
      isLoadingPartnerInfo(true);

      var response = await ApiClient.getData('/user/partner-info');

      if (response.statusCode == 200) {
        if (response.body['data'] != null) {
          // Check if user is connected
          isConnected.value = response.body['data']['isConnected'] ?? false;

          // Get partner info
          if (response.body['data']['partner'] != null) {
            partner.value = User.fromJson(response.body['data']['partner']);
          }

          // Get connection streak
          if (response.body['data']['connectionStreak'] != null) {
            connectionStreak.value = response.body['data']['connectionStreak'];
          }

          // Get user's own connection code
          if (response.body['data']['connectionCode'] != null) {
            connectionCode.value = response.body['data']['connectionCode'];
          }
        }
      }
    } catch (e) {
      print('Error getting partner info: $e');
    } finally {
      isLoadingPartnerInfo(false);
      update();
    }
  }

  // Refresh all data
  Future<void> refreshData() async {
    await Future.wait([
      getPartnerInfo(),
      generateConnectionCode(),
    ]);
  }
}