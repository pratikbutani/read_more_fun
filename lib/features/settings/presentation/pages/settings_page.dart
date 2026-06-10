import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:read_more_fun/core/localization/app_localizations.dart';
import 'package:read_more_fun/core/services/language_service.dart';
import 'package:read_more_fun/core/services/theme_service.dart';
import 'package:read_more_fun/core/services/spacing_service.dart';
import 'package:read_more_fun/core/utils/whatsapp_formatter.dart';
import 'package:read_more_fun/features/settings/presentation/pages/about_me_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.translate('settings_title'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        children: [
          _buildLanguageTile(context),
          const Divider(height: 24),
          _buildSpacingTile(context),
          const Divider(height: 24),
          _buildThemeTile(context),
          const Divider(height: 24),
          _buildAboutMeTile(context),
        ],
      ),
    );
  }

  Widget _buildLanguageTile(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: LanguageService.activeLanguageNotifier,
      builder: (context, activeLang, child) {
        final langName = LanguageService.languages[activeLang] ?? 'English 🇬🇧';
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(Icons.translate_outlined,
                  color: Theme.of(context).colorScheme.primary),
            ),
            title: Text(
              context.translate('option_change_language'),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              langName,
              style: TextStyle(
                color: context.textColor.withValues(alpha: 0.6),
                fontSize: 13,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showLanguageSelectionDialog(context),
          ),
        );
      },
    );
  }

  Widget _buildSpacingTile(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: SpacingService.spacingNotifier,
      builder: (context, spacing, child) {
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(Icons.space_bar_outlined,
                  color: Theme.of(context).colorScheme.primary),
            ),
            title: Text(
              context.translate('option_change_spacing'),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              spacing.toString(),
              style: TextStyle(
                color: context.textColor.withValues(alpha: 0.6),
                fontSize: 13,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showSpacingDialog(context),
          ),
        );
      },
    );
  }

  Widget _buildThemeTile(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeService.instance.themeModeNotifier,
      builder: (context, themeMode, child) {
        final isDark = ThemeService.instance.isDarkMode;
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(
                isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            title: Text(
              context.translate('option_change_theme'),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              isDark
                  ? context.translate('theme_dark')
                  : context.translate('theme_light'),
              style: TextStyle(
                color: context.textColor.withValues(alpha: 0.6),
                fontSize: 13,
              ),
            ),
            trailing: Switch(
              value: isDark,
              onChanged: (val) {
                ThemeService.instance.toggleTheme();
              },
            ),
            onTap: () {
              ThemeService.instance.toggleTheme();
            },
          ),
        );
      },
    );
  }

  Widget _buildAboutMeTile(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(Icons.person_outline,
              color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(
          context.translate('option_about_me'),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          'Pratik Butani',
          style: TextStyle(
            color: context.textColor.withValues(alpha: 0.6),
            fontSize: 13,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AboutMePage()),
          );
        },
      ),
    );
  }

  void _showLanguageSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final currentLanguage = LanguageService.activeLanguageNotifier.value;
        return AlertDialog(
          title: Text(
            context.translate("change_language_title"),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 320,
            child: ListView(
              shrinkWrap: true,
              children: LanguageService.languages.entries.map((entry) {
                return ListTile(
                  title: Text(entry.value),
                  trailing: currentLanguage == entry.key
                      ? Icon(Icons.check,
                          color: Theme.of(context).colorScheme.primary)
                      : null,
                  onTap: () async {
                    await LanguageService.setLanguage(entry.key);
                    if (context.mounted) Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void _showSpacingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final currentSpacing = SpacingService.spacingNotifier.value;
            return AlertDialog(
              title: Text(
                context.translate('option_change_spacing'),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    context.translate('spacing_count', [currentSpacing.toString()]),
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    min: 500,
                    max: 2000,
                    value: currentSpacing.toDouble(),
                    onChanged: (val) async {
                      await SpacingService.setSpacing(val.toInt());
                      setDialogState(() {});
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.translate('spacing_note'),
                    style: TextStyle(
                      color: context.textColor.withValues(alpha: 0.5),
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    context.translate('button_save'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
