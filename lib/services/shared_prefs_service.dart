import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static const String _onboardingCompleteKey = 'onboarding_complete';
  static const String _userLoggedInKey = 'user_logged_in';

  static Future<bool> get isOnboardingComplete async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingCompleteKey) ?? false;
  }

  static Future<void> setOnboardingComplete(bool complete) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompleteKey, complete);
  }

  static Future<bool> get isUserLoggedIn async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_userLoggedInKey) ?? false;
  }

  static Future<void> setUserLoggedIn(bool loggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_userLoggedInKey, loggedIn);
  }
}