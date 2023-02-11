import 'dart:async';

import 'package:bubble/bubble.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:read_more_fun/extensions.dart';
import 'package:read_more_fun/templates.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return NeumorphicApp(
      themeMode: ThemeMode.dark,
      theme: NeumorphicThemeData(
          accentColor: Colors.black,
          variantColor: Colors.black87,
          baseColor: Color(0xFFFFFFFF),
          lightSource: LightSource.topLeft),
      darkTheme: NeumorphicThemeData(
        accentColor: Colors.white,
        variantColor: Colors.white70,
        baseColor: Color(0xFF3E3E3E),
        lightSource: LightSource.topLeft,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
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
  String _introText = "Type some introduction text here";
  String _readMoreText = "This is really funny app.";

  bool isReadMoreClicked = false;

  StreamController<String> introTextStreamController =
      StreamController<String>.broadcast();

  StreamController<bool> introBoolStreamController =
      StreamController<bool>.broadcast();

  StreamController<bool> readmoreBoolStreamController =
      StreamController<bool>.broadcast();
  StreamController<String> readmoreTextStreamController =
      StreamController<String>.broadcast();
  final _scaffoldKey = GlobalKey<ScaffoldState>(); // new line

  _finalTextForClipBoard() {
    return _introText + Extension.getLovelyString() + _readMoreText;
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      key: _scaffoldKey,
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
                      depth: 5,
                      intensity: 0.4,
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
                      _getTextInputLabelWidget("Enter Intro Text"),
                      SizedBox(height: 8),
                      _getTextInputFieldIntroText(),
                      SizedBox(height: 25),
                      _getTextInputLabelWidget("Read-more content"),
                      SizedBox(height: 8),
                      _getTextInputFieldReadMoreText(),
                      SizedBox(height: 25),
                      _getTextInputLabelWidget("Message Preview:"),
                      SizedBox(height: 8),
                      _getProperTextChild(),
                      SizedBox(height: 40),
                      _getButtonCopyToClipboard(),
                      SizedBox(height: 40),
                      _getButtonForTemplatesActivity()
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
    return NeumorphicText(
      "Create WhatsApp Quiz, Spoiler, Joke, Pay-off, or General Intro of Business for longer messages with “... Read more” button",
      textStyle: NeumorphicTextStyle(fontFamily: 'fontFamily', fontSize: 24.0),
      textAlign: TextAlign.center,
      style: NeumorphicStyle(
          color: Extension.textColor(context),
          shadowLightColor: Extension.textColor(context)),
    );
  }

  _getTextInputLabelWidget(dynamic title) {
    return NeumorphicText(
      title,
      textStyle: NeumorphicTextStyle(fontFamily: 'fontFamily', fontSize: 16),
      style: NeumorphicStyle(
          color: Extension.textColor(context),
          shadowLightColor: Extension.textColor(context)),
    );
  }

  _getTextInputFieldIntroText() {
    return StreamBuilder<String>(
        initialData: _introText,
        stream: introTextStreamController.stream,
        builder: (context, snapshot) {
          return Neumorphic(
            style: NeumorphicStyle(depth: -2, intensity: 1),
            padding: EdgeInsets.all(20),
            child: TextFormField(
              enableInteractiveSelection: true,
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(fontFamily: 'fontFamily', fontSize: 16),
              cursorColor: Extension.textColor(context),
              cursorWidth: 1,
              onChanged: (value) {
                isReadMoreClicked = false;
                if (value.isEmpty) {
                  _introText = "Type some introduction text here";
                } else {
                  _introText = value;
                }
                readmoreBoolStreamController.add(isReadMoreClicked);
                introTextStreamController.add(_introText);
              },
              decoration: InputDecoration.collapsed(
                hintText: _introText,
                border: InputBorder.none,
              ),
            ),
          );
        });
  }

  _getTextInputFieldReadMoreText() {
    return StreamBuilder<String>(
        initialData: _readMoreText,
        stream: readmoreTextStreamController.stream,
        builder: (context, snapshot) {
          return Neumorphic(
            style: NeumorphicStyle(depth: -2, intensity: 1),
            padding: EdgeInsets.all(20),
            child: TextFormField(
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              style: TextStyle(fontFamily: 'fontFamily', fontSize: 16),
              cursorColor: Extension.textColor(context),
              cursorWidth: 1,
              onChanged: (value) {
                isReadMoreClicked = false;
                if (value.isEmpty) {
                  _readMoreText = "This is really funny app.";
                } else {
                  _readMoreText = value;
                }
                readmoreTextStreamController.add(_readMoreText);
                readmoreBoolStreamController.add(isReadMoreClicked);
              },
              decoration: InputDecoration.collapsed(
                hintText: _readMoreText,
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
      color: Colors.white,
      elevation: 5 * px,
      radius: Radius.circular(3),
      margin: BubbleEdges.only(top: 8.0),
      alignment: Alignment.topLeft,
    );

    List<Shadow> shadow = [
      Shadow(
        offset: Offset(1.5, 1.5),
        blurRadius: 1.5,
        color: Colors.black45,
      ),
      Shadow(
        offset: Offset(1.5, 1.5),
        blurRadius: 1.5,
        color: Colors.white54,
      ),
    ];

    TextStyle defaultStyle =
        TextStyle(color: Colors.black87, fontSize: 16.0, shadows: shadow);
    TextStyle linkStyle = TextStyle(
        color: Colors.blue,
        decoration: TextDecoration.underline,
        fontSize: 16.0,
        shadows: shadow);

    return StreamBuilder<bool>(
        initialData: isReadMoreClicked,
        stream: readmoreBoolStreamController.stream,
        builder: (ctx, snapshot) {
          return isReadMoreClicked
              ? Bubble(
                  style: styleMe,
                  child: RichText(
                      text: TextSpan(
                          text: _introText + Extension.getLovelyString(),
                          style: defaultStyle,
                          children: <TextSpan>[
                        TextSpan(
                            text: '\n\n\n' + _readMoreText, style: defaultStyle)
                      ])))
              : Bubble(
                  style: styleMe,
                  child: RichText(
                      text: TextSpan(
                          text: _introText + Extension.getLovelyString(),
                          style: defaultStyle,
                          children: <TextSpan>[
                        TextSpan(text: ' ... ', style: defaultStyle),
                        TextSpan(
                            text: 'Read more',
                            style: linkStyle,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => {
                                    isReadMoreClicked = !isReadMoreClicked,
                                    readmoreBoolStreamController
                                        .add(isReadMoreClicked)
                                  })
                      ])));
        });
  }

  _getButtonCopyToClipboard() {
    return Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NeumorphicButton(
                style: NeumorphicStyle(
                  shape: NeumorphicShape.flat,
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(4)),
                ),
                padding: const EdgeInsets.all(12.0),
                onPressed: () {
                  Clipboard.setData(
                          new ClipboardData(text: _finalTextForClipBoard()))
                      .then((value) => {
                            Extension.showSnackBar(
                                context, 'Copied to Clipboard')
                          });
                },
                child: Text("Copy to Clipboard",
                    style: TextStyle(fontFamily: 'fontFamily', fontSize: 16)),
              ),
              NeumorphicButton(
                style: NeumorphicStyle(
                  shape: NeumorphicShape.flat,
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(4)),
                ),
                padding: const EdgeInsets.all(12.0),
                onPressed: () {
                  Extension.showSnackBar(context, 'Please wait...');
                  Share.share(_finalTextForClipBoard());
                },
                child: Text("Send on WhatsApp",
                    style: TextStyle(fontFamily: 'fontFamily', fontSize: 16)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _getButtonForTemplatesActivity() {
    return Center(
      child: NeumorphicButton(
        style: NeumorphicStyle(
          shape: NeumorphicShape.flat,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(4)),
        ),
        padding: const EdgeInsets.all(12.0),
        onPressed: () {
          Navigator.of(context).push(_createRoute());
        },
        child: Text("Check Templates",
            style: TextStyle(fontFamily: 'fontFamily', fontSize: 16)),
      ),
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

  @override
  void dispose() {
    super.dispose();
    introTextStreamController.close();
    introBoolStreamController.close();
    readmoreBoolStreamController.close();
    readmoreTextStreamController.close();
  }
}
