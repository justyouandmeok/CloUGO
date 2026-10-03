import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalCache {
  static const feedKey = 'cache_feed';
  static const profileKey = 'cache_profile';

  static Future<List<Map<String, dynamic>>> feed() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getString(feedKey);
    if (raw == null) return [];
    return List<Map<String, dynamic>>.from(jsonDecode(raw));
  }

  static Future<void> saveFeed(List<Map<String, dynamic>> items) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(feedKey, jsonEncode(items));
  }

  static Future<void> saveProfile(Map<String, dynamic> profile) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(profileKey, jsonEncode(profile));
  }
}
