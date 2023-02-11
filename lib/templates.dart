import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'extensions.dart';

class MyTemplatesPage extends StatefulWidget {
  @override
  _MyTemplatesPageState createState() => _MyTemplatesPageState();
}

class _MyTemplatesPageState extends State<MyTemplatesPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>(); // new line

  List<String> listOfTemplates = [
    'Accept yourself',
    'Act justly',
    'Aim high',
    'Alive & well',
    'Amplify hope',
    'Baby steps',
    'Be awesome',
    'Be colorful',
    'Be fearless',
    'Be honest',
    'Be kind',
    'Be spontaneous',
    'Be still',
    'Be yourself',
    'Beautiful chaos',
    'Breathe deeply',
    'But why?',
    'Call me',
    'Carpe diem',
    'Cherish today',
    'Chill out',
    'Come back',
    'Crazy beautiful',
    'Dance today',
    'Don’t panic',
    'Don’t stop',
    'Dream big',
    'Dream bird',
    'Enjoy life',
    'Enjoy today',
    'Everything counts',
    'Explore magic',
    'Fairy dust',
    'Fear not',
    'Feeling groowy',
    'Find balance',
    'Follow through',
    'For real',
    'Forever free',
    'Forget this',
    'Friends forever',
    'Game on',
    'Getting there',
    'Give thanks',
    'Good job',
    'Good vibration',
    'Got love?',
    'Hakuna Matata',
    'Happy endings',
    'Have faith',
    'Have patience',
    'Hello gorgeous',
    'Hold on',
    'How lovely',
    'I can',
    'I remember...',
    'I will',
    'Imperfectly perfect',
    'Infinite possibilities',
    'Inhale exhale',
    'Invite tranquility',
    'Just because',
    'Just believe',
    'Just imagine',
    'Just sayin…',
    'Keep calm',
    'Keep going',
    'Keep smiling',
    'Laugh today',
    'Laughter heals',
    'Let go',
    'Limited edition',
    'Look up',
    'Look within',
    'Loosen up',
    'Love endures',
    'Love fearlessly',
    'Love you',
    'Miracle happens',
    'Move on',
    'No boundaries',
    'Not yet',
    'Notice things',
    'Oh snap',
    'Oh, really?',
    'Only believe',
    'Perfectly content',
    'Perfectly fabulous',
    'Pretty awesome',
    'Respect me',
    'Rise above',
    'Shift happens',
    'Shine on',
    'Sing today',
    'Slow down',
    'Start living',
    'Stay beautiful',
    'Stay focused',
    'Stay strong',
    'Stay true',
    'Stay tuned',
    'Take chances',
    'Thank you',
    'Then when?',
    'Think different',
    'Think first',
    'Think twice',
    'Tickled pink',
    'Treasure today',
    'True love',
    'Trust me',
    'Try again',
    'Unconditional love',
    'Wanna play?',
    'What if?',
    'Why not?',
    'Woo hoo!',
    'You can',
    'You matter',
    'You sparkle'
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: NeumorphicAppBar(
            actions: [
              NeumorphicButton(
                child: Icon(Icons.share),
                onPressed: () {
                  Extension.showSnackBar(context, 'Sharing App...');
                  Extension.shareApp();
                },
                tooltip: 'Share App',
              ),
            ],
            iconTheme: IconThemeData(color: Extension.textColor(context)),
            centerTitle: true,
            title: NeumorphicText(
              "Templates",
              textStyle:
                  NeumorphicTextStyle(fontFamily: 'fontFamily', fontSize: 26),
              style: NeumorphicStyle(
                  color: Extension.textColor(context),
                  shadowLightColor: Extension.textColor(context)),
            )),
        resizeToAvoidBottomInset: false,
        backgroundColor: NeumorphicTheme.baseColor(context),
        body: SafeArea(
            child: ListView.builder(
                itemCount: listOfTemplates.length,
                itemBuilder: (context, index) {
                  final item = listOfTemplates[index];
                  return Neumorphic(
                      padding: EdgeInsets.all(5),
                      style: NeumorphicStyle(
                          intensity: 0.5,
                          depth: 3,
                          surfaceIntensity: 0.5,
                          border: NeumorphicBorder(
                              color: Colors.white38, width: 0.1)),
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        trailing: NeumorphicButton(
                          style: NeumorphicStyle(
                              intensity: 0.5,
                              depth: 2,
                              shape: NeumorphicShape.concave),
                          child: Icon(
                            Icons.share,
                            color: Extension.iconsColor(context),
                          ),
                          onPressed: () {
                            Extension.showSnackBar(
                                context, 'Sharing Template...');
                            Extension.shareTemplate(listOfTemplates[index]);
                          },
                          tooltip: 'Share App',
                        ),
                        title: NeumorphicText(item,
                            textAlign: TextAlign.start,
                            textStyle: NeumorphicTextStyle(
                                fontFamily: 'fontFamily', fontSize: 18),
                            style: NeumorphicStyle(
                                intensity: 0.5,
                                color: Extension.textColor(context),
                                shadowLightColor:
                                    Extension.textColor(context))),
                      ));
                })));
  }
}
