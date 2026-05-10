import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:read_more_fun/draft_service.dart';
import 'package:read_more_fun/extensions.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      appBar: NeumorphicAppBar(
        title: NeumorphicText(
          "Draft History",
          style: NeumorphicStyle(color: Extension.textColor(context)),
          textStyle: NeumorphicTextStyle(fontSize: 20),
        ),
      ),
      body: FutureBuilder<List<Draft>>(
        future: DraftService.getDrafts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final drafts = snapshot.data!;
          if (drafts.isEmpty) return Center(child: Text("No history yet"));

          return ListView.builder(
            itemCount: drafts.length,
            itemBuilder: (context, index) {
              final draft = drafts[index];
              return Neumorphic(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: EdgeInsets.all(12),
                child: ListTile(
                  title: Text(draft.intro, maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text(draft.readMore, maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () async {
                      await DraftService.deleteDraft(index);
                      setState(() {});
                    },
                  ),
                  onTap: () {
                    Navigator.pop(context, draft);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
