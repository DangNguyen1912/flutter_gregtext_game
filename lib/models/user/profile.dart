import 'dart:convert';

import 'package:flutter/material.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
// ProfileIds = UserIds
// this is use to select profiles/users without loading inventories and heavy stuff, just ids, names and info stuff

class Profile {
  String profileId;
  String profileName;
  DateTime createDate;
  Duration playedTime;
  int gameStage;

  Profile({
    required this.profileId,
    required this.profileName,
    required this.createDate,
    required this.playedTime,
    required this.gameStage,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'profileId': profileId,
      'profileName': profileName,
      'createDate': createDate.millisecondsSinceEpoch,
      'playedTime': playedTime.inSeconds,
      'gameStage': gameStage,
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      profileId: map['profileId'] as String,
      profileName: map['profileName'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      playedTime: Duration(seconds: map['playedTime'] as int),
      gameStage: map['gameStage'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Profile.fromJson(String source) =>
      Profile.fromMap(json.decode(source) as Map<String, dynamic>);
}
