import 'dart:convert';
import 'package:mokarabia/model/login_states.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum PreferenceKey {
  loginState,
  userName,
  theme
}

extension KeyExtension on PreferenceKey {
  String get name {
    switch (this) {
      case PreferenceKey.loginState:
        return 'loginState';
      case PreferenceKey.userName:
        return 'userName';
      case PreferenceKey.theme:
        return 'theme';
    }
  }
}

class PreferenceHelper {
  static late SharedPreferences pref;

  static init() async {
    pref = await SharedPreferences.getInstance();
  }

  static void putDataInSharedPreference({
    required dynamic value,
    required PreferenceKey key,
  }) {
    if (value is String) {
      pref.setString(key.name, value);
    } else if (value is int) {
      pref.setInt(key.name, value);
    } else if (value is bool) {
      pref.setBool(key.name, value);
    } else if (value is double) {
      pref.setDouble(key.name, value);
    } else if (value is Map) {
      pref.setString(key.name, json.encode(value));
    }
  }

  static dynamic getDataFromSharedPreference({
    required PreferenceKey key,
  }) {
    return pref.get(key.name);
  }

  static void clearDataFromSharedPreference({
    required PreferenceKey key,
  }) {
    pref.remove(key.name);
  }

  static void clearAllSharedPreference() {
    pref.clear();
  }
}
