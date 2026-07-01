// lib/services/local_storage_service.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gregtext_game/models/user/profile.dart';
import 'package:flutter_gregtext_game/models/user/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService extends ChangeNotifier {
  static const String _keyLastProfileId = 'last_profile_Id';
  static const String _keyProfiles = 'profiles';
  static const String _keyUser = 'user';

  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  // Save last used profile
  Future<void> saveLastProfile(String profileId) async {
    await _prefs.setString(_keyLastProfileId, jsonEncode(profileId));
  }

  // Get last used profile
  Future<String?> getLastProfileId() async {
    final String? profileId = _prefs.getString(_keyLastProfileId);
    return profileId;
  }

  Future<void> saveProfiles(List<Profile> profiles) async {
    final List<String> jsonList = profiles
        .map((profile) => profile.toJson())
        .toList();
    final String jsonString = jsonEncode(jsonList);
    await _prefs.setString(_keyProfiles, jsonString);
  }

  List<Profile> getProfiles() {
    final String? jsonString = _prefs.getString(_keyProfiles);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }
    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => Profile.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveUser(User user) async {
    String key = _keyUser + user.userId;
    await _prefs.setString(key, user.toJson());
  }

  User getUserById(String userId) {
    String key = _keyUser + userId;
    final String? jsonString = _prefs.getString(key);
    if (jsonString == null) {
      throw "cant find user";
    }
    return User.fromJson(jsonString);
  }
}
