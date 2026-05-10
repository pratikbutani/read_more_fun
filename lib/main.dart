import 'package:bubble/bubble.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:read_more_fun/draft_service.dart';
import 'package:read_more_fun/extensions.dart';
import 'package:read_more_fun/history_page.dart';
import 'package:read_more_fun/templates.dart';
import 'package:read_more_fun/theme_service.dart';
import 'package:share_plus/share_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeService.instance.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: ThemeService.instance.themeModeNotifier,
        builder: (context, themeMode, child) {
          return NeumorphicApp(
            themeMode: themeMode,
            theme: NeumorphicThemeData(
                accentColor: Colors.black,
                variantColor: Colors.black87,
                baseColor: Color(0xFFFFFFFF),
                depth: 3,
                intensity: 0.35,
                lightSource: LightSource.topLeft),
            darkTheme: NeumorphicThemeData(
              accentColor: Colors.white,
              variantColor: Colors.white70,
              baseColor: Color(0xFF3E3E3E),
              depth: 3,
              intensity: 0.35,
              lightSource: LightSource.topLeft,
            ),
            debugShowCheckedModeBanner: false,
            home: MyHomePage(title: 'Flutter Demo Home Page'),
          );
        });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ValueNotifier<String> _introTextNotifier =
      ValueNotifier<String>("Type some introduction text here");
  final ValueNotifier<String> _readMoreTextNotifier =
      ValueNotifier<String>("This is really funny app.");
  final ValueNotifier<bool> _isReadMoreClickedNotifier =
      ValueNotifier<bool>(false);

  late TextEditingController _introController;
  late TextEditingController _readMoreController;

  @override
  void initState() {
    super.initState();
    _introController = TextEditingController();
    _readMoreController = TextEditingController();
  }

  _finalTextForClipBoard() {
    return _introTextNotifier.value +
        Extension.getLovelyString() +
        _readMoreTextNotifier.value;
  }

  @override
  void dispose() {
    _introTextNotifier.dispose();
    _readMoreTextNotifier.dispose();
    _isReadMoreClickedNotifier.dispose();
    _introController.dispose();
    _readMoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: NeumorphicTheme.baseColor(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                left: 20.0, top: 20.0, right: 20.0, bottom: bottom),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 20),
                _getHeaderTextWidget(),
                SizedBox(height: 30),
                Neumorphic(
                  style: NeumorphicStyle(
                      depth: 2,
                      intensity: 0.3,
                      border: NeumorphicBorder(
                          isEnabled: true,
                          color: Extension.textColor(context),
                          width: 0.1)),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _getTextInputLabelWidget("Enter Intro Text\n(*bold*, _italic_, ~strike~)"),
                      SizedBox(height: 8),
                      _getTextInputFieldIntroText(),
                      SizedBox(height: 25),
                      _getTextInputLabelWidget("Read-more content\n(*bold*, _italic_, ~strike~)"),
                      SizedBox(height: 8),
                      _getTextInputFieldReadMoreText(),
                      SizedBox(height: 25),
                      _getTextInputLabelWidget("Message Preview:"),
                      SizedBox(height: 8),
                      _getProperTextChild(),
                      SizedBox(height: 40),
                      _getActionButtonsGrid(),
                    ],
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: NeumorphicFloatingActionButton(
        onPressed: () {
          Extension.showSnackBar(context, 'Sharing App...');
          Extension.shareApp();
        },
        tooltip: 'Share App',
        style: NeumorphicStyle(shape: NeumorphicShape.flat),
        child: Icon(
          Icons.share,
          color: Extension.iconsColor(context),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _getHeaderTextWidget() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            NeumorphicButton(
              onPressed: () {
                ThemeService.instance.toggleTheme();
              },
              style: NeumorphicStyle(
                shape: NeumorphicShape.flat,
                boxShape: NeumorphicBoxShape.circle(),
              ),
              child: Icon(
                ThemeService.instance.isDarkMode
                    ? Icons.light_mode
                    : Icons.dark_mode,
                color: Extension.textColor(context),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        NeumorphicText(
          "Create WhatsApp Quiz, Spoiler, Joke, Pay-off, or General Intro of Business for longer messages with “... Read more” button",
          textStyle: NeumorphicTextStyle(fontFamily: 'fontFamily', fontSize: 16.0),
          textAlign: TextAlign.center,
          style: NeumorphicStyle(
              color: Extension.textColor(context),
              shadowLightColor: Extension.textColor(context)),
        ),
      ],
    );
  }

  _getTextInputLabelWidget(dynamic title) {
    return NeumorphicText(
      title,
      textStyle: NeumorphicTextStyle(fontFamily: 'fontFamily', fontSize: 14),
      style: NeumorphicStyle(
          color: Extension.textColor(context),
          shadowLightColor: Extension.textColor(context)),
    );
  }

  _getTextInputFieldIntroText() {
    return ValueListenableBuilder<String>(
        valueListenable: _introTextNotifier,
        builder: (context, introText, snapshot) {
          return Neumorphic(
            style: NeumorphicStyle(depth: -1, intensity: 0.6),
            padding: EdgeInsets.all(20),
            child: TextFormField(
              controller: _introController,
              enableInteractiveSelection: true,
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(fontFamily: 'fontFamily', fontSize: 14),
              cursorColor: Extension.textColor(context),
              cursorWidth: 1,
              onChanged: (value) {
                _isReadMoreClickedNotifier.value = false;
                if (value.isEmpty) {
                  _introTextNotifier.value = "Type introduction text here";
                } else {
                  _introTextNotifier.value = value;
                }
              },
              decoration: InputDecoration.collapsed(
                hintText: "Type introduction text here",
                border: InputBorder.none,
              ),
            ),
          );
        });
  }

  _getTextInputFieldReadMoreText() {
    return ValueListenableBuilder<String>(
        valueListenable: _readMoreTextNotifier,
        builder: (context, readMoreText, snapshot) {
          return Neumorphic(
            style: NeumorphicStyle(depth: -1, intensity: 0.6),
            padding: EdgeInsets.all(20),
            child: TextFormField(
              controller: _readMoreController,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              style: TextStyle(fontFamily: 'fontFamily', fontSize: 14),
              cursorColor: Extension.textColor(context),
              cursorWidth: 1,
              onChanged: (value) {
                _isReadMoreClickedNotifier.value = false;
                if (value.isEmpty) {
                  _readMoreTextNotifier.value = "This is really funny app.";
                } else {
                  _readMoreTextNotifier.value = value;
                }
              },
              decoration: InputDecoration.collapsed(
                hintText: "This is really funny app.",
                border: InputBorder.none,
              ),
            ),
          );
        });
  }

  _getProperTextChild() {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    double px = 1 / pixelRatio;

    BubbleStyle styleMe = BubbleStyle(
      nip: BubbleNip.rightTop,
      color: NeumorphicTheme.isUsingDark(context)
          ? Color(0xFF1E2428)
          : Colors.white,
      elevation: 8 * px,
      radius: Radius.circular(8),
      margin: BubbleEdges.only(top: 8.0),
      alignment: Alignment.topLeft,
    );

    TextStyle defaultStyle = TextStyle(
        color: Extension.textColor(context).withOpacity(0.8), fontSize: 14.0);
    TextStyle linkStyle = TextStyle(
        color: Colors.blue,
        decoration: TextDecoration.underline,
        fontSize: 14.0);

    return ListenableBuilder(
        listenable: Listenable.merge([
          _isReadMoreClickedNotifier,
          _introTextNotifier,
          _readMoreTextNotifier
        ]),
        builder: (ctx, child) {
          bool isReadMoreClicked = _isReadMoreClickedNotifier.value;
          String introText = _introTextNotifier.value;
          String readMoreText = _readMoreTextNotifier.value;

          return Bubble(
            style: styleMe,
            child: isReadMoreClicked
                ? RichText(
                    text: TextSpan(
                        style: defaultStyle,
                        children: [
                      ...Extension.parseWhatsAppText(introText, defaultStyle),
                      TextSpan(
                          text: Extension.getLovelyString(),
                          style: defaultStyle),
                      ...Extension.parseWhatsAppText(
                          '\n\n\n' + readMoreText, defaultStyle),
                    ]))
                : RichText(
                    text: TextSpan(
                        style: defaultStyle,
                        children: [
                      ...Extension.parseWhatsAppText(introText, defaultStyle),
                      TextSpan(
                          text: Extension.getLovelyString(),
                          style: defaultStyle),
                      TextSpan(text: ' ... ', style: defaultStyle),
                      TextSpan(
                          text: 'Read more',
                          style: linkStyle,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _isReadMoreClickedNotifier.value =
                                  !_isReadMoreClickedNotifier.value;
                            })
                    ])),
          );
        });
  }

  _getActionButtonsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: NeumorphicButton(
                style: NeumorphicStyle(
                  shape: NeumorphicShape.concave,
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(4)),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                onPressed: () {
                  DraftService.saveDraft(
                      _introTextNotifier.value, _readMoreTextNotifier.value);
                  Clipboard.setData(
                          new ClipboardData(text: _finalTextForClipBoard()))
                      .then((value) => {
                            Extension.showSnackBar(
                                context, 'Copied to Clipboard')
                          });
                },
                child: Center(
                  child: Text("Copy",
                      style: TextStyle(fontFamily: 'fontFamily', fontSize: 16)),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: NeumorphicButton(
                style: NeumorphicStyle(
                  shape: NeumorphicShape.concave,
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(4)),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                onPressed: () {
                  DraftService.saveDraft(
                      _introTextNotifier.value, _readMoreTextNotifier.value);
                  Extension.showSnackBar(context, 'Please wait...');
                  Share.share(_finalTextForClipBoard());
                },
                child: Center(
                  child: Text("WhatsApp",
                      style: TextStyle(fontFamily: 'fontFamily', fontSize: 16)),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: NeumorphicButton(
                style: NeumorphicStyle(
                  shape: NeumorphicShape.concave,
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(4)),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                onPressed: () {
                  Navigator.of(context).push(_createRoute());
                },
                child: Center(
                  child: Text("Templates",
                      style: TextStyle(fontFamily: 'fontFamily', fontSize: 16)),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: NeumorphicButton(
                style: NeumorphicStyle(
                  shape: NeumorphicShape.concave,
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(4)),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                onPressed: () async {
                  final Draft? selectedDraft = await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => HistoryPage()),
                  );
                  if (selectedDraft != null) {
                    _introController.text = selectedDraft.intro;
                    _readMoreController.text = selectedDraft.readMore;
                    _introTextNotifier.value = selectedDraft.intro;
                    _readMoreTextNotifier.value = selectedDraft.readMore;
                    _isReadMoreClickedNotifier.value = false;
                  }
                },
                child: Center(
                  child: Text("History",
                      style: TextStyle(fontFamily: 'fontFamily', fontSize: 16)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          MyTemplatesPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

}
