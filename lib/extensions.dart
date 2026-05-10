import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:share_plus/share_plus.dart';

class Extension {
  static getLovelyString() {
    var repeatedString = "";
    var string = "\u200B";
    var times = 1300;

    while (times > 0) {
      repeatedString += string;
      times--;
    }
    return repeatedString + "\n\n";
  }

  static showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 1),
        content: Text(message,
            style: TextStyle(fontFamily: 'fontFamily', fontSize: 16))));
  }

  static Future<void> shareTemplate(String message) async {
    String str = getLovelyString();
    str = str.replaceAll('\n', '');
    await Share.share(
        str + "$message \n\nCreated from: https://bit.ly/read-more-whatsapp");
  }

  static Future<void> shareApp() async {
    String str = getLovelyString();
    await Share.share("*Try out the magic of WhatsApp*" +
        str +
        "\n\nHow's it? \n\nMake your own long text to short: https://bit.ly/read-more-whatsapp");
  }

  static List<TextSpan> parseWhatsAppText(String text, TextStyle baseStyle) {
    final RegExp regExp = RegExp(r'([*_~])(.*?)\1');
    List<TextSpan> spans = [];
    int lastIndex = 0;

    for (final Match match in regExp.allMatches(text)) {
      if (match.start > lastIndex) {
        spans.add(TextSpan(
            text: text.substring(lastIndex, match.start), style: baseStyle));
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

  static Color? iconsColor(BuildContext context) {
    final theme = NeumorphicTheme.of(context)!;
    if (theme.isUsingDark) {
      return theme.current!.accentColor;
    } else {
      return null;
    }
  }

  static Color textColor(BuildContext context) {
    if (NeumorphicTheme.isUsingDark(context)) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }
}
