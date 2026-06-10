import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Draft {
  final String intro;
  final String readMore;
  final DateTime timestamp;

  Draft({required this.intro, required this.readMore, required this.timestamp});

  Map<String, dynamic> toJson() => {
        'intro': intro,
        'readMore': readMore,
        'timestamp': timestamp.toIso8601String(),
      };

  factory Draft.fromJson(Map<String, dynamic> json) => Draft(
        intro: json['intro'],
        readMore: json['readMore'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}

class DraftService {
  static const String _key = 'drafts_history';

  static Future<void> saveDraft(String intro, String readMore) async {
    final prefs = await SharedPreferences.getInstance();
    List<Draft> drafts = await getDrafts();
    
    // Check if duplicate
    if (drafts.any((d) => d.intro == intro && d.readMore == readMore)) {
      return;
    }

    drafts.insert(0, Draft(intro: intro, readMore: readMore, timestamp: DateTime.now()));
    
    // Keep only last 20 drafts
    if (drafts.length > 20) {
      drafts = drafts.sublist(0, 20);
    }

    final String encoded = jsonEncode(drafts.map((d) => d.toJson()).toList());
    await prefs.setString(_key, encoded);
  }

  static Future<List<Draft>> getDrafts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encoded = prefs.getString(_key);
    if (encoded == null) return [];

    final List<dynamic> decoded = jsonDecode(encoded);
    return decoded.map((item) => Draft.fromJson(item)).toList();
  }

  static Future<void> deleteDraft(int index) async {
    final prefs = await SharedPreferences.getInstance();
    List<Draft> drafts = await getDrafts();
    if (index >= 0 && index < drafts.length) {
      drafts.removeAt(index);
      final String encoded = jsonEncode(drafts.map((d) => d.toJson()).toList());
      await prefs.setString(_key, encoded);
    }
  }
}
