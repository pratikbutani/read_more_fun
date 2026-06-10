import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  static const String _key = 'template_language';

  static final ValueNotifier<String> activeLanguageNotifier = ValueNotifier<String>('en');

  static const Map<String, String> languages = {
    'en': 'English 🇬🇧',
    'hi': 'Hindi (हिन्दी) 🇮🇳',
    'gu': 'Gujarati (ગુજરાતી) 🇮🇳',
    'es': 'Spanish (Español) 🇪🇸',
    'pt': 'Portuguese (Português) 🇵🇹',
    'zh': 'Chinese (中文) 🇨🇳',
    'fr': 'French (Français) 🇫🇷',
    'ar': 'Arabic (العربية) 🇸🇦',
    'bn': 'Bengali (বাংলা) 🇧🇩',
    'ru': 'Russian (Русский) 🇷🇺',
    'ur': 'Urdu (اردو) 🇵🇰',
  };

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
