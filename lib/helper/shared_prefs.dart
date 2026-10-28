import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences? prefs;

  static const String visitors = 'visitors';
  static const String lastLocalId = 'lastLocalId';

  static Future<void> init() async {
    prefs ??= await SharedPreferences.getInstance();
  }

  static bool get hasVisitors => prefs?.containsKey(visitors) == true;

  static List<Map<String, dynamic>> getVisitors() {
    final raw = prefs?.getString(visitors);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw);
      if (list is! List) return [];
      return list.whereType<Map<String, dynamic>>().toList();
    } on FormatException {
      return [];
    }
  }

  static Future<void> saveVisitors(List<Map<String, dynamic>> list) async {
    await prefs?.setString(visitors, jsonEncode(list));
  }

  static Future<String> nextLocalId() async {
    final next = (prefs?.getInt(lastLocalId) ?? 1000) + 1;
    await prefs?.setInt(lastLocalId, next);
    return 'LV$next';
  }
}
