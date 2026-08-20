import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _keyUserJson = 'cached_user_json';
  static const String _keyRememberMeEmail = 'remember_me_email';
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyOnboardingDone = 'onboarding_done';

  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  static Future<LocalStorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStorageService(prefs);
  }

  // Theme Mode
  Future<void> saveThemeMode(String mode) async {
    await _prefs.setString(_keyThemeMode, mode);
  }

  String? getThemeMode() {
    return _prefs.getString(_keyThemeMode);
  }

  // Cached User Data
  Future<void> saveUserJson(Map<String, dynamic> userMap) async {
    await _prefs.setString(_keyUserJson, jsonEncode(userMap));
  }

  Map<String, dynamic>? getUserJson() {
    final raw = _prefs.getString(_keyUserJson);
    if (raw == null || raw.isEmpty) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  Future<void> removeUserJson() async {
    await _prefs.remove(_keyUserJson);
  }

  // Remember Me Email
  Future<void> saveRememberMeEmail(String email) async {
    await _prefs.setString(_keyRememberMeEmail, email);
  }

  String? getRememberMeEmail() {
    return _prefs.getString(_keyRememberMeEmail);
  }

  Future<void> removeRememberMeEmail() async {
    await _prefs.remove(_keyRememberMeEmail);
  }

  // Logged In Flag
  Future<void> setIsLoggedIn(bool value) async {
    await _prefs.setBool(_keyIsLoggedIn, value);
  }

  bool get isLoggedIn {
    return _prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // Onboarding
  Future<void> setOnboardingDone(bool value) async {
    await _prefs.setBool(_keyOnboardingDone, value);
  }

  bool get isOnboardingDone {
    return _prefs.getBool(_keyOnboardingDone) ?? false;
  }

  // Clear Session
  Future<void> clearSession() async {
    await removeUserJson();
    await setIsLoggedIn(false);
  }

  // Clear All
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
