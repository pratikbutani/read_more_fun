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
  static const String zeroWidthSpace = '\u3164';
  static const int defaultSpacingTimes = 1500;

  static String getLovelyString({int times = defaultSpacingTimes, bool isIos = false}) {
    final spacer = isIos ? '\u3164' : '\u200B';
    return "${spacer * times}\n\n";
  }

  static Future<void> shareTemplate(BuildContext context, String intro, String readMore, {int spacingTimes = defaultSpacingTimes, bool isIos = false}) async {
    String str = getLovelyString(times: spacingTimes, isIos: isIos);
    final text = context.translate('share_template_text', [intro, str, readMore]);
    await Share.share(text);
  }

  static Future<void> shareApp(BuildContext context, {int spacingTimes = defaultSpacingTimes, bool isIos = false}) async {
    String str = getLovelyString(times: spacingTimes, isIos: isIos);
    final text = context.translate('share_app_text', [str]);
    await Share.share(text);
  }

  static List<TextSpan> parseWhatsAppText(String text, TextStyle baseStyle) {
    // Process list markers first: lines starting with "- " or "* " (followed by space) -> replace with bullet symbol "• "
    final processedLines = text.split('\n').map((line) {
      if (line.startsWith('- ')) {
        return '• ${line.substring(2)}';
      } else if (line.startsWith('* ')) {
        return '• ${line.substring(2)}';
      }
      return line;
    }).join('\n');

    final RegExp regExp = RegExp(r'([*_~])(.*?)\1');
    List<TextSpan> spans = [];
    int lastIndex = 0;

    for (final Match match in regExp.allMatches(processedLines)) {
      if (match.start > lastIndex) {
        spans.add(TextSpan(
          text: processedLines.substring(lastIndex, match.start),
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

    if (lastIndex < processedLines.length) {
      spans.add(TextSpan(text: processedLines.substring(lastIndex), style: baseStyle));
    }

    return spans;
  }

  static void applyFormatting(TextEditingController controller, String marker) {
    final selection = controller.selection;
    final text = controller.text;

    if (!selection.isValid) {
      if (marker == '- ') {
        final newText = text + marker;
        controller.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: newText.length),
        );
      } else {
        final newText = text + marker + marker;
        controller.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: newText.length - marker.length),
        );
      }
      return;
    }

    final start = selection.start;
    final end = selection.end;

    if (marker == '- ') {
      if (start == end) {
        final newText = text.substring(0, start) + marker + text.substring(start);
        controller.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: start + marker.length),
        );
      } else {
        final selectedText = text.substring(start, end);
        final formattedLines = selectedText.split('\n').map((line) {
          if (line.startsWith('- ')) return line;
          return '- $line';
        }).join('\n');
        final newText = text.substring(0, start) + formattedLines + text.substring(end);
        controller.value = TextEditingValue(
          text: newText,
          selection: TextSelection(
            baseOffset: start,
            extentOffset: start + formattedLines.length,
          ),
        );
      }
      return;
    }

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
