// lib/services/local_storage_service.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService extends ChangeNotifier {
  static const String _keyLastProfileId = 'last_profile_Id';
  static const String _keyTheme = 'theme';

  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  String? getLastProfileId() {
    final String? profileId = _prefs.getString(_keyLastProfileId);
    return profileId;
  }

  void setLastProfile(String profileId) {
    _prefs.setString(_keyLastProfileId, jsonEncode(profileId));
  }

  String getTheme() {
    final String profileId = _prefs.getString(_keyTheme) ?? 'system';
    return profileId;
  }

  void setTheme(String profileId) {
    _prefs.setString(_keyTheme, jsonEncode(profileId));
  }
}
