// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_gregtext_game/models/inventory.dart';

class User {
  Inventory inventory;
  int gameStage;

  User({required this.inventory, required this.gameStage});

  User.newStart()
    : inventory = Inventory(inventory: List.empty()),
      gameStage = 0;
}
