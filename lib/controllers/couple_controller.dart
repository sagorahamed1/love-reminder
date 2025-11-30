import 'package:get/get.dart';
import '../models/user.dart';

class CoupleController extends GetxController {
  Rxn<User> partner = Rxn<User>();
  var connectionCode = 'ABC123'.obs;
  var connectionStreak = 12.obs;
  var isConnected = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Mock partner data for design preview
    partner.value = User(
      id: '2',
      email: 'ahmed@example.com',
      name: 'Ahmed',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    );
  }

  Future<void> connectWithCode(String code) async {
    await Future.delayed(const Duration(seconds: 1));
    partner.value = User(
      id: '2',
      email: 'partner@example.com',
      name: 'Partner',
      createdAt: DateTime.now(),
    );
    isConnected.value = true;
    update();
  }

  void generateNewCode() {
    connectionCode.value = _generateRandomCode();
    update();
  }

  void updateStreak() {
    connectionStreak.value++;
    update();
  }

  String _generateRandomCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    String result = '';
    for (int i = 0; i < 6; i++) {
      result +=
          chars[(DateTime.now().millisecondsSinceEpoch + i) % chars.length];
    }
    return result;
  }
}
