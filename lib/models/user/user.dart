// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter_gregtext_game/models/user/inventory.dart';

class User {
  String userId;
  String userName;
  DateTime createDate;
  DateTime playedTime;
  Inventory inventory;
  int gameStage;

  User({
    required this.userId,
    required this.userName,
    required this.createDate,
    required this.playedTime,
    required this.inventory,
    required this.gameStage,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'userName': userName,
      'createDate': createDate.millisecondsSinceEpoch,
      'playedTime': playedTime.millisecondsSinceEpoch,
      'inventory': inventory.toMap(),
      'gameStage': gameStage,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['userId'] as String,
      userName: map['userName'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      playedTime: DateTime.fromMillisecondsSinceEpoch(map['playedTime'] as int),
      inventory: Inventory.fromMap(map['inventory'] as Map<String, dynamic>),
      gameStage: map['gameStage'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}
