import 'package:flutter/material.dart';
import 'package:read_more_fun/core/localization/app_localizations.dart';
import 'package:share_plus/share_plus.dart';

extension ThemeContext on BuildContext {
  Color get textColor {
    return Theme.of(this).colorScheme.onSurface;
  }

  Color get iconsColor {
    return Theme.of(this).colorScheme.primary;
  }
}

extension SnackBarContext on BuildContext {
  void showSnackBar(String message) {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        content: Text(
          message,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

class WhatsAppFormatter {
  static const String zeroWidthSpace = '\u200B';
  static const int defaultSpacingTimes = 1300;

  static String getLovelyString({int times = defaultSpacingTimes}) {
    return "${zeroWidthSpace * times}\n\n";
  }

  static Future<void> shareTemplate(BuildContext context, String intro, String readMore, {int spacingTimes = defaultSpacingTimes}) async {
    String str = getLovelyString(times: spacingTimes);
    final text = context.translate('share_template_text', [intro, str, readMore]);
    await Share.share(text);
  }

  static Future<void> shareApp(BuildContext context, {int spacingTimes = defaultSpacingTimes}) async {
    String str = getLovelyString(times: spacingTimes);
    final text = context.translate('share_app_text', [str]);
    await Share.share(text);
  }

  static List<TextSpan> parseWhatsAppText(String text, TextStyle baseStyle) {
    final RegExp regExp = RegExp(r'([*_~])(.*?)\1');
    List<TextSpan> spans = [];
    int lastIndex = 0;

    for (final Match match in regExp.allMatches(text)) {
      if (match.start > lastIndex) {
        spans.add(TextSpan(
          text: text.substring(lastIndex, match.start),
          style: baseStyle,
        ));
      }

      String marker = match.group(1)!;
      String content = match.group(2)!;
      TextStyle style = baseStyle;

      if (marker == '*') {
        style = style.copyWith(fontWeight: FontWeight.bold);
      } else if (marker == '_') {
        style = style.copyWith(fontStyle: FontStyle.italic);
      } else if (marker == '~') {
        style = style.copyWith(decoration: TextDecoration.lineThrough);
      }

      spans.add(TextSpan(text: content, style: style));
      lastIndex = match.end;
    }

    if (lastIndex < text.length) {
      spans.add(TextSpan(text: text.substring(lastIndex), style: baseStyle));
    }

    return spans;
  }

  static void applyFormatting(TextEditingController controller, String marker) {
    final selection = controller.selection;
    final text = controller.text;

    if (!selection.isValid) {
      final newText = text + marker + marker;
      controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length - marker.length),
      );
      return;
    }

    final start = selection.start;
    final end = selection.end;

    if (start == end) {
      final newText = text.substring(0, start) + marker + marker + text.substring(start);
      controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: start + marker.length),
      );
    } else {
      final selectedText = text.substring(start, end);
      final newText = text.substring(0, start) + marker + selectedText + marker + text.substring(end);
      controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection(
          baseOffset: start,
          extentOffset: end + (marker.length * 2),
        ),
      );
    }
  }
}
