import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActionsStore extends ChangeNotifier {
  static final ActionsStore i = ActionsStore._();
  ActionsStore._();
  final liked = <String>{};
  final saved = <String>{};
  final comments = <String, List<String>>{};

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    liked.addAll(p.getStringList('cu_liked') ?? []);
    saved.addAll(p.getStringList('cu_saved') ?? []);
    final raw = jsonDecode(p.getString('cu_comments') ?? '{}') as Map<String, dynamic>;
    comments.addAll(raw.map((k, v) => MapEntry(k, List<String>.from(v))));
    notifyListeners();
  }

  Future<void> _save() async {
    final p = await SharedPreferences.getInstance();
    await p.setStringList('cu_liked', liked.toList());
    await p.setStringList('cu_saved', saved.toList());
    await p.setString('cu_comments', jsonEncode(comments));
  }

  Future<void> toggleLike(String id) async {
    liked.contains(id) ? liked.remove(id) : liked.add(id);
    notifyListeners();
    await _save();
  }

  Future<void> toggleSave(String id) async {
    saved.contains(id) ? saved.remove(id) : saved.add(id);
    notifyListeners();
    await _save();
  }

  Future<void> addComment(String id, String text) async {
    comments.putIfAbsent(id, () => []).add(text);
    notifyListeners();
    await _save();
  }
}
