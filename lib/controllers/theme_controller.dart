import 'package:get/get.dart';

class ThemeController extends GetxController {
  var currentTheme = 'romantic'.obs;
  var isDarkMode = false.obs;

  void setTheme(String theme) {
    currentTheme.value = theme;
    update();
  }

  void toggleDarkMode() {
    isDarkMode.value = !isDarkMode.value;
    update();
  }
}
