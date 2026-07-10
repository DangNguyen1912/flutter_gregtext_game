// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter_gregtext_game/models/area.dart';
import 'package:flutter_gregtext_game/models/user/inventory.dart';

class GameUser {
  String userId;
  String userName;
  DateTime createDate;
  Duration playedTime;
  Inventory inventory;
  List<Area> exploredArea;
  int gameStage;
  DateTime? newAreaFinishTime;
  Duration exploreDurarion;

  GameUser({
    required this.userId,
    required this.userName,
    required this.createDate,
    required this.playedTime,
    required this.gameStage,
    this.newAreaFinishTime,
    Inventory? inventory,
    List<Area>? exploredArea,
    Duration? exploreDurarion,
  }) : inventory = inventory ?? Inventory(inventory: List.empty()),
       exploredArea = exploredArea ?? List.empty(),
       exploreDurarion = exploreDurarion ?? Duration();

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'userName': userName,
      'createDate': createDate.millisecondsSinceEpoch,
      'playedTime': playedTime.inSeconds,
      'inventory': inventory.toMap(),
      'gameStage': gameStage,
      'exploredArea': exploredArea.map((x) => x.toMap()).toList(),
      'newAreaFinishTime': newAreaFinishTime,
      'exploreDurarion': exploreDurarion.inSeconds,
    };
  }

  factory GameUser.fromMap(Map<String, dynamic> map) {
    int? newAreaFinishTime = map['newAreaFinishTime'] as int?;
    return GameUser(
      userId: map['userId'] as String,
      userName: map['userName'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      playedTime: Duration(seconds: map['playedTime'] as int),
      inventory: Inventory.fromMap(map['inventory'] as Map<String, dynamic>),
      gameStage: map['gameStage'] as int,
      exploredArea: (map['exploredArea'] as List<Map<String, dynamic>>)
          .map((e) => Area.fromMap(e))
          .toList(),
      newAreaFinishTime: newAreaFinishTime != null
          ? DateTime.fromMillisecondsSinceEpoch(newAreaFinishTime)
          : null,
      exploreDurarion: Duration(seconds: map['playedTime'] as int? ?? 0),
    );
  }

  String toJson() => json.encode(toMap());

  factory GameUser.fromJson(String source) =>
      GameUser.fromMap(json.decode(source) as Map<String, dynamic>);
}
