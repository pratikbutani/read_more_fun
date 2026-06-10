import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  static const String _key = 'template_language';

  static final ValueNotifier<String> activeLanguageNotifier = ValueNotifier<String>('en');

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    activeLanguageNotifier.value = prefs.getString(_key) ?? 'en';
  }

  static Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key) ?? 'en';
  }

  static Future<void> setLanguage(String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, langCode);
    activeLanguageNotifier.value = langCode;
  }

  static Future<bool> isLanguageSet() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_key);
  }
}
