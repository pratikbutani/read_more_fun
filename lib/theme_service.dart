import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static const String _key = 'theme_mode';
  final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(ThemeMode.dark);

  ThemeService._();
  static final ThemeService instance = ThemeService._();

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final String? mode = prefs.getString(_key);
    if (mode != null) {
      if (mode == 'light') {
        themeModeNotifier.value = ThemeMode.light;
      } else if (mode == 'dark') {
        themeModeNotifier.value = ThemeMode.dark;
      } else {
        themeModeNotifier.value = ThemeMode.system;
      }
    }
  }

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    if (themeModeNotifier.value == ThemeMode.light) {
      themeModeNotifier.value = ThemeMode.dark;
      await prefs.setString(_key, 'dark');
    } else {
      themeModeNotifier.value = ThemeMode.light;
      await prefs.setString(_key, 'light');
    }
  }

  bool get isDarkMode => themeModeNotifier.value == ThemeMode.dark;
}
