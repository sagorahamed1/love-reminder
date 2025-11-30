import 'package:get/get.dart';
import '../models/user.dart';

class AuthController extends GetxController {
  Rxn<User> user = Rxn<User>();
  RxBool isLoading = false.obs;

  bool get isAuthenticated => user.value != null;

  // Mock authentication for design preview
  void mockLogin() {
    isLoading.value = true;
    update();
    Future.delayed(const Duration(seconds: 2), () {
      user.value = User(
        id: '1',
        email: 'sarah@example.com',
        name: 'Sarah',
        createdAt: DateTime.now(),
      );
      isLoading.value = false;
      update();
    });
  }

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    update();
    try {
      await Future.delayed(const Duration(seconds: 1));
      user.value = User(
        id: '1',
        email: email,
        name: email.split('@')[0],
        createdAt: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Login failed: $e');
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> signup(String email, String password, String name) async {
    isLoading.value = true;
    update();
    try {
      await Future.delayed(const Duration(seconds: 1));
      user.value = User(
        id: '1',
        email: email,
        name: name,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Signup failed: $e');
    } finally {
      isLoading.value = false;
      update();
    }
  }

  void logout() {
    user.value = null;
    update();
  }
}
