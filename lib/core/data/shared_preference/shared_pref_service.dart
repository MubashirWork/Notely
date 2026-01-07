import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  static const String loginKey = 'isLoggedIn';
  static const String username = 'username';
  static const String fullName = 'fullName';

  static Future<String?> getFullName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(fullName);
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(username);
  }

  static Future<bool?> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(loginKey);
  }

  static Future logout() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }
}
