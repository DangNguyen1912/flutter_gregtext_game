// ignore_for_file: public_member_api_docs, sort_constructors_first
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
}
