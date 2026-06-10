import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:read_more_fun/core/services/draft_service.dart';
import 'package:read_more_fun/core/utils/whatsapp_formatter.dart';
import 'package:read_more_fun/main.dart';
import 'package:read_more_fun/features/home/presentation/pages/home_page.dart';
import 'package:read_more_fun/features/templates/data/static_templates.dart';
import 'package:read_more_fun/core/services/custom_templates_service.dart';
import 'package:read_more_fun/core/services/language_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    LanguageService.activeLanguageNotifier.value = 'en';
  });

  group('WhatsAppFormatter Unit Tests', () {
    test('getLovelyString returns correct format and length', () {
      final str = WhatsAppFormatter.getLovelyString(times: 10);
      expect(str, contains(WhatsAppFormatter.zeroWidthSpace));
      expect(str.endsWith('\n\n'), isTrue);
    });

    test('parseWhatsAppText parses bold, italic, and strike correctly', () {
      const text = 'Hello *world*, this is _italic_ and ~strike~.';
      const baseStyle = TextStyle(fontSize: 14);
      final spans = WhatsAppFormatter.parseWhatsAppText(text, baseStyle);

      expect(spans.length, 7);
      expect(spans[0].text, 'Hello ');
      expect(spans[1].text, 'world');
      expect(spans[1].style!.fontWeight, FontWeight.bold);
      expect(spans[3].text, 'italic');
      expect(spans[3].style!.fontStyle, FontStyle.italic);
      expect(spans[5].text, 'strike');
      expect(spans[5].style!.decoration, TextDecoration.lineThrough);
    });
  });

  group('DraftService Unit Tests', () {
    test('saveDraft saves draft and prevents duplicates', () async {
      await DraftService.saveDraft('Intro', 'ReadMore');
      var drafts = await DraftService.getDrafts();
      expect(drafts.length, 1);
      expect(drafts[0].intro, 'Intro');

      // Duplicate save
      await DraftService.saveDraft('Intro', 'ReadMore');
      drafts = await DraftService.getDrafts();
      expect(drafts.length, 1);
    });

    test('saveDraft respects the limit of 20 drafts', () async {
      for (int i = 0; i < 25; i++) {
        await DraftService.saveDraft('Intro $i', 'ReadMore $i');
      }
      final drafts = await DraftService.getDrafts();
      expect(drafts.length, 20);
      expect(drafts.first.intro, 'Intro 24');
    });

    test('deleteDraft deletes item correctly', () async {
      await DraftService.saveDraft('Intro 1', 'ReadMore 1');
      await DraftService.saveDraft('Intro 2', 'ReadMore 2');
      
      await DraftService.deleteDraft(0);
      final drafts = await DraftService.getDrafts();
      expect(drafts.length, 1);
      expect(drafts[0].intro, 'Intro 1');
    });
  });

  group('TemplateItem & CustomTemplatesService Unit Tests', () {
    test('TemplateItem JSON serialization and equality', () {
      const item = TemplateItem(
        category: 'Confessions',
        intro: 'Secret',
        readMore: 'Payoff',
      );
      final json = item.toJson();
      final parsed = TemplateItem.fromJson(json);

      expect(parsed.category, 'Confessions');
      expect(parsed.intro, 'Secret');
      expect(parsed.readMore, 'Payoff');
      expect(parsed, equals(item));
    });

    test('CustomTemplatesService saves and deletes templateItem', () async {
      const item = TemplateItem(
        category: 'Custom',
        intro: 'Intro Text',
        readMore: 'Read More Text',
      );

      await CustomTemplatesService.saveTemplate(item);
      var templates = await CustomTemplatesService.getTemplates();
      expect(templates.any((t) => t.intro == 'Intro Text' && t.readMore == 'Read More Text'), isTrue);

      await CustomTemplatesService.deleteTemplate(item);
      templates = await CustomTemplatesService.getTemplates();
      expect(templates.any((t) => t.intro == 'Intro Text' && t.readMore == 'Read More Text'), isFalse);
    });
  });

  group('LanguageService & Localization Unit Tests', () {
    test('LanguageService default and setter operations', () async {
      // Default should be 'en'
      final defaultLang = await LanguageService.getLanguage();
      expect(defaultLang, 'en');

      // Setter
      await LanguageService.setLanguage('hi');
      final newLang = await LanguageService.getLanguage();
      expect(newLang, 'hi');

      final isSet = await LanguageService.isLanguageSet();
      expect(isSet, isTrue);
    });

    test('StaticTemplates retrieves correct localized template count', () {
      final hindiTemplates = StaticTemplates.getTemplatesForLanguage('hi');
      expect(hindiTemplates.isNotEmpty, isTrue);
      expect(hindiTemplates.length, 60);

      final gujaratiTemplates = StaticTemplates.getTemplatesForLanguage('gu');
      expect(gujaratiTemplates.length, 60);
      expect(gujaratiTemplates.first.category, 'Confessions');
    });
  });

  group('Widget UI Tests', () {
    testWidgets('App renders correctly and displays intro input', (WidgetTester tester) async {
      // Mock share preferences for main initialization
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.byType(MyHomePage), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text("Copy"), findsOneWidget);
      expect(find.text("WhatsApp"), findsOneWidget);
      expect(find.text("Templates"), findsOneWidget);
      expect(find.text("History"), findsOneWidget);

      // Verify translate button exists and can be tapped to show language dialog
      final translateBtn = find.byIcon(Icons.translate_outlined);
      expect(translateBtn, findsOneWidget);

      await tester.tap(translateBtn);
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text("Change Template Language"), findsOneWidget);
    });
  });
}
