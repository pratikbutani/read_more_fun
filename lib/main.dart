import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:read_more_fun/core/services/theme_service.dart';
import 'package:read_more_fun/core/services/language_service.dart';
import 'package:read_more_fun/features/home/presentation/pages/home_page.dart';

import 'package:read_more_fun/core/services/spacing_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeService.instance.init();
  await LanguageService.init();
  await SpacingService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeService.instance.themeModeNotifier,
      builder: (context, themeMode, child) {
        return ValueListenableBuilder<String>(
          valueListenable: LanguageService.activeLanguageNotifier,
          builder: (context, activeLanguage, child) {
            return MaterialApp(
              title: 'Read More Fun',
              themeMode: themeMode,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF6366F1),
              brightness: Brightness.light,
            ),
            scaffoldBackgroundColor: const Color(0xFFF8FAFC),
            textTheme: GoogleFonts.poppinsTextTheme(
              ThemeData.light().textTheme,
            ),
            appBarTheme: const AppBarTheme(
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            cardTheme: CardThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
              ),
              elevation: 0,
              color: Colors.white,
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF6366F1),
              brightness: Brightness.dark,
            ),
            scaffoldBackgroundColor: const Color(0xFF0F172A),
            textTheme: GoogleFonts.poppinsTextTheme(
              ThemeData.dark().textTheme,
            ),
            appBarTheme: const AppBarTheme(
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            cardTheme: CardThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFF334155), width: 1),
              ),
              elevation: 0,
              color: const Color(0xFF1E293B),
            ),
          ),
          debugShowCheckedModeBanner: false,
          home: const MyHomePage(title: 'Read More Fun'),
        );
          },
        );
      },
    );
  }
}
