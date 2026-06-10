import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:read_more_fun/core/utils/whatsapp_formatter.dart';

class SpacingService {
  static const String _key = 'spacing_times';

  static final ValueNotifier<int> spacingNotifier =
      ValueNotifier<int>(WhatsAppFormatter.defaultSpacingTimes);

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    spacingNotifier.value = prefs.getInt(_key) ?? WhatsAppFormatter.defaultSpacingTimes;
  }

  static Future<void> setSpacing(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, value);
    spacingNotifier.value = value;
  }
}
