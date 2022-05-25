import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:share/share.dart';

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

  static showSnackBar(ScaffoldState scaffoldState, String message) {
    scaffoldState.showSnackBar(SnackBar(
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
