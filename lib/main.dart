import 'package:bubble/bubble.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:share/share.dart';

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
          variantColor: Colors.white,
          baseColor: Color(0xFFFFFFFF),
          lightSource: LightSource.topLeft),
      darkTheme: NeumorphicThemeData(
        variantColor: Colors.white,
        baseColor: Color(0xFF3E3E3E),
        lightSource: LightSource.topLeft,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _introText = "Type some introduction text here";
  String _readMoreText = "This is really funny app.";

  bool isReadMoreClicked = false;

  Future<void> _shareApp() async {
    String str = repeatStringNumTimes("\u200B", 1300);
    await Share.share(str + " Hello");
  }

  repeatStringNumTimes(string, times) {
    var repeatedString = "";
    while (times > 0) {
      repeatedString += string;
      times--;
    }
    return repeatedString;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: NeumorphicTheme.baseColor(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
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
                        isEnabled: true, color: Colors.white38, width: 0.1)),
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
                    _getButtonCopyToClipboard()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: NeumorphicFloatingActionButton(
        onPressed: _shareApp,
        tooltip: 'Share App',
        style: NeumorphicStyle(shape: NeumorphicShape.flat),
        child: Icon(
          Icons.share,
          color: Colors.white,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _getHeaderTextWidget() {
    return NeumorphicText(
      "Create WhatsApp Quiz, Spoiler, Joke, Pay-off, or general Intro for longer messages with “Read more” button",
      textStyle: NeumorphicTextStyle(fontFamily: 'fontFamily', fontSize: 24),
      textAlign: TextAlign.center,
      style:
          NeumorphicStyle(color: Colors.white, shadowLightColor: Colors.white),
    );
  }

  _getProperTextChild() {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    double px = 1 / pixelRatio;

    BubbleStyle styleMe = BubbleStyle(
      nip: BubbleNip.rightTop,
      color: Color.fromARGB(255, 225, 255, 199),
      elevation: 5 * px,
      radius: Radius.circular(3),
      margin: BubbleEdges.only(top: 8.0),
      alignment: Alignment.topLeft,
    );

    TextStyle defaultStyle = TextStyle(color: Colors.black87, fontSize: 16.0);
    TextStyle linkStyle = TextStyle(
        color: Colors.blue,
        decoration: TextDecoration.underline,
        fontSize: 16.0);

    return isReadMoreClicked
        ? Bubble(
            style: styleMe,
            child: RichText(
                text: TextSpan(
                    text: _introText + repeatStringNumTimes("\u200B", 1300),
                    style: defaultStyle,
                    children: <TextSpan>[
                  TextSpan(text: '\n\n\n' + _readMoreText, style: defaultStyle)
                ])))
        : Bubble(
            style: styleMe,
            child: RichText(
                text: TextSpan(
                    text: _introText + repeatStringNumTimes("\u200B", 1300),
                    style: defaultStyle,
                    children: <TextSpan>[
                  TextSpan(text: ' ... ', style: defaultStyle),
                  TextSpan(
                      text: 'Read more',
                      style: linkStyle,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => {
                              setState(() {
                                isReadMoreClicked = !isReadMoreClicked;
                              })
                            })
                ])));
  }

  _getTextInputLabelWidget(dynamic title) {
    return NeumorphicText(
      title,
      textStyle: NeumorphicTextStyle(fontFamily: 'fontFamily', fontSize: 16),
      style:
          NeumorphicStyle(color: Colors.white, shadowLightColor: Colors.white),
    );
  }

  _getTextInputFieldIntroText() {
    return Neumorphic(
      style: NeumorphicStyle(depth: -2, intensity: 1),
      padding: EdgeInsets.all(20),
      child: TextFormField(
        style: TextStyle(fontFamily: 'fontFamily', fontSize: 16),
        cursorColor: Colors.white,
        cursorWidth: 1,
        onChanged: (value) {
          setState(() {
            isReadMoreClicked = false;
            if (value.isEmpty)
              _introText = "Type some introduction text here";
            else
              _introText = value;
          });
        },
        decoration: InputDecoration.collapsed(
          hintText: _introText,
          border: InputBorder.none,
        ),
      ),
    );
  }

  _getTextInputFieldReadMoreText() {
    return Neumorphic(
      style: NeumorphicStyle(depth: -2, intensity: 1),
      padding: EdgeInsets.all(20),
      child: TextFormField(
        keyboardType: TextInputType.multiline,
        maxLines: 5,
        style: TextStyle(fontFamily: 'fontFamily', fontSize: 16),
        cursorColor: Colors.white,
        cursorWidth: 1,
        onChanged: (value) {
          setState(() {
            isReadMoreClicked = false;
            if (value.isEmpty)
              _readMoreText = "This is really funny app.";
            else
              _readMoreText = value;
          });
        },
        decoration: InputDecoration.collapsed(
          hintText: _readMoreText,
          border: InputBorder.none,
        ),
      ),
    );
  }

  _getButtonCopyToClipboard() {
    return Center(
      child: NeumorphicButton(
        style: NeumorphicStyle(
          shape: NeumorphicShape.flat,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(4)),
        ),
        padding: const EdgeInsets.all(12.0),
        onPressed: () {},
        child: Text("Copy to Clipboard",
            style: TextStyle(fontFamily: 'fontFamily', fontSize: 16)),
      ),
    );
  }
}
