import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:read_more_fun/core/localization/app_localizations.dart';
import 'package:read_more_fun/core/services/draft_service.dart';
import 'package:read_more_fun/core/utils/whatsapp_formatter.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.translate('history_title'),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: context.textColor,
          ),
        ),
      ),
      body: FutureBuilder<List<Draft>>(
        future: DraftService.getDrafts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final drafts = snapshot.data!;
          if (drafts.isEmpty) {
            return Center(
              child: Text(
                context.translate('no_history_yet'),
                style: TextStyle(
                  color: context.textColor.withValues(alpha: 0.6),
                  fontSize: 16,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: drafts.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final draft = drafts[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(
                    draft.intro,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.lora(
                      fontWeight: FontWeight.bold,
                      color: context.textColor,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      draft.readMore,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lora(
                        color: context.textColor.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete_outline, color: theme.colorScheme.error),
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
