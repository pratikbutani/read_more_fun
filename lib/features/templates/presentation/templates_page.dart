import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:read_more_fun/core/localization/app_localizations.dart';
import 'package:read_more_fun/core/services/custom_templates_service.dart';
import 'package:read_more_fun/core/services/language_service.dart';
import 'package:read_more_fun/core/utils/whatsapp_formatter.dart';
import 'package:read_more_fun/features/templates/data/static_templates.dart';

class MyTemplatesPage extends StatefulWidget {
  const MyTemplatesPage({super.key});

  @override
  State<MyTemplatesPage> createState() => _MyTemplatesPageState();
}

class _MyTemplatesPageState extends State<MyTemplatesPage> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  List<TemplateItem> _customTemplates = [];

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _customIntroController = TextEditingController();
  final TextEditingController _customReadMoreController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _initLanguageAndTemplates();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _customIntroController.dispose();
    _customReadMoreController.dispose();
    super.dispose();
  }

  Future<void> _initLanguageAndTemplates() async {
    _loadCustomTemplates();
  }

  void _loadCustomTemplates() async {
    final list = await CustomTemplatesService.getTemplates();
    setState(() {
      _customTemplates = list;
    });
  }

  List<TemplateItem> _getFilteredTemplates() {
    final currentLang = LanguageService.activeLanguageNotifier.value;
    List<TemplateItem> list;
    if (_selectedCategory == 'All') {
      list = [
        ...StaticTemplates.getTemplatesForLanguage(currentLang),
        ..._customTemplates
      ];
    } else if (_selectedCategory == 'Custom') {
      list = _customTemplates;
    } else {
      list = StaticTemplates.localizedTemplates[currentLang]
              ?[_selectedCategory] ??
          [];
    }

    if (_searchQuery.isNotEmpty) {
      list = list
          .where((item) =>
              item.intro.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              item.readMore.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    return list;
  }

  String _getCategoryKey(String category) {
    switch (category) {
      case 'All': return 'category_all';
      case 'Confessions': return 'category_confessions';
      case 'Spoiler Alert': return 'category_spoiler_alert';
      case 'Pranks & Glitches': return 'category_pranks_glitches';
      case 'Riddles & Brainers': return 'category_riddles_brainers';
      case 'Millennial Work Speak': return 'category_millennial_work';
      case 'GenZ Daily Sarcasm': return 'category_genz_sarcasm';
      default: return 'preset_custom';
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _getFilteredTemplates();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.translate("templates_title"),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: context.textColor,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              context.showSnackBar(context.translate('snackbar_sharing'));
              WhatsAppFormatter.shareApp(context);
            },
            tooltip: context.translate('share_app'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            _buildCategorySelector(),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                children: [
                  if (_selectedCategory == 'Custom')
                    _buildAddCustomTemplateCard(theme),
                  if (filtered.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Center(
                        child: Text(
                          context.translate("no_templates_found"),
                          style: TextStyle(
                            color: context.textColor.withValues(alpha: 0.6),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    )
                  else
                    ...filtered.map((item) => _buildTemplateCard(item, theme)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: SearchBar(
        controller: _searchController,
        hintText: context.translate("search_templates"),
        onChanged: (val) {
          setState(() {
            _searchQuery = val;
          });
        },
        leading:
            Icon(Icons.search, color: context.textColor.withValues(alpha: 0.6)),
        trailing: _searchQuery.isNotEmpty
            ? [
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              ]
            : null,
        elevation: WidgetStateProperty.all(0),
        backgroundColor: WidgetStateProperty.all(
          Theme.of(context).cardTheme.color ?? Colors.white,
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
            side: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant,
              width: 1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    final categories = [
      'All',
      'Confessions',
      'Spoiler Alert',
      'Pranks & Glitches',
      'Riddles & Brainers',
      'Millennial Work Speak',
      'GenZ Daily Sarcasm',
      'Custom'
    ];
    final theme = Theme.of(context);
    return SizedBox(
      height: 72,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final localizedLabel = cat == 'Custom'
              ? context.translate('preset_custom')
              : context.translate(_getCategoryKey(cat));
          final isSelected = _selectedCategory == cat;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: ChoiceChip(
              showCheckmark: false,
              label: Text(
                localizedLabel,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
              selected: isSelected,
              selectedColor: theme.colorScheme.primary,
              backgroundColor: theme.brightness == Brightness.dark
                  ? const Color(0xFF1E293B)
                  : const Color(0xFFE2E8F0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              side: BorderSide.none,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedCategory = cat;
                  });
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddCustomTemplateCard(ThemeData theme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              context.translate("create_custom_template"),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: context.textColor,
                  fontSize: 16),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _customIntroController,
              maxLines: 1,
              style: GoogleFonts.lora(color: context.textColor, fontSize: 14),
              decoration: InputDecoration(
                hintText: context.translate("free_text_intro_hint"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _customReadMoreController,
              maxLines: 3,
              style: GoogleFonts.lora(color: context.textColor, fontSize: 14),
              decoration: InputDecoration(
                hintText: context.translate("free_text_read_more_hint"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FilledButton.tonal(
                  onPressed: () async {
                    final intro = _customIntroController.text.trim();
                    final readMore = _customReadMoreController.text.trim();
                    if (intro.isNotEmpty && readMore.isNotEmpty) {
                      final item = TemplateItem(
                          category: 'Custom', intro: intro, readMore: readMore);
                      await CustomTemplatesService.saveTemplate(item);
                      if (!mounted) return;
                      _customIntroController.clear();
                      _customReadMoreController.clear();
                      _loadCustomTemplates();
                      context.showSnackBar(context.translate('custom_template_saved'));
                    } else {
                      context.showSnackBar(context.translate('fill_both_fields'));
                    }
                  },
                  child: Text(
                    context.translate('button_save'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTemplateCard(TemplateItem item, ThemeData theme) {
    final isCustom = _customTemplates.contains(item);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          item.intro,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: context.textColor,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            item.readMore,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.lora(
              fontSize: 13,
              color: context.textColor.withValues(alpha: 0.6),
            ),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isCustom)
              IconButton(
                icon:
                    Icon(Icons.delete_outline, color: theme.colorScheme.error),
                onPressed: () async {
                  await CustomTemplatesService.deleteTemplate(item);
                  if (!mounted) return;
                  _loadCustomTemplates();
                  context.showSnackBar(context.translate('template_deleted'));
                },
                tooltip: context.translate('delete_template'),
              ),
            IconButton(
              icon: Icon(Icons.share_outlined, color: context.iconsColor),
              onPressed: () {
                context.showSnackBar(context.translate('snackbar_sharing_template'));
                WhatsAppFormatter.shareTemplate(context, item.intro, item.readMore);
              },
              tooltip: context.translate('share_template'),
            ),
          ],
        ),
        onTap: () {
          Navigator.pop(context, item);
        },
      ),
    );
  }
}
