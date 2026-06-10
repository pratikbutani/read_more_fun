import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:read_more_fun/features/templates/data/static_templates.dart';

class CustomTemplatesService {
  static const String _key = 'custom_templates_v2';

  static Future<void> saveTemplate(TemplateItem template) async {
    final prefs = await SharedPreferences.getInstance();
    final List<TemplateItem> custom = await getTemplates();
    if (custom.any((t) => t.intro == template.intro && t.readMore == template.readMore)) return;

    custom.insert(0, template);
    final list = custom.map((t) => jsonEncode(t.toJson())).toList();
    await prefs.setStringList(_key, list);
  }

  static Future<List<TemplateItem>> getTemplates() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    return list.map((item) {
      try {
        return TemplateItem.fromJson(jsonDecode(item));
      } catch (_) {
        // Fallback or migration if some old strings exist
        return TemplateItem(category: 'Custom', intro: item, readMore: '');
      }
    }).toList();
  }

  static Future<void> deleteTemplate(TemplateItem template) async {
    final prefs = await SharedPreferences.getInstance();
    final List<TemplateItem> custom = await getTemplates();
    custom.removeWhere((t) => t.intro == template.intro && t.readMore == template.readMore);
    final list = custom.map((t) => jsonEncode(t.toJson())).toList();
    await prefs.setStringList(_key, list);
  }
}
