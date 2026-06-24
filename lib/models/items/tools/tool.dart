// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_gregtext_game/models/items/item.dart';
import 'package:flutter_gregtext_game/models/items/tools/tool_type.dart';

class Tool extends Item {
  int durability;
  int maxDurability;
  int gatherSpeed;
  ToolType toolType;

  Tool({
    required this.durability,
    required this.gatherSpeed,
    required this.toolType,
    required super.itemName,
    super.count = 1,
  }) : maxDurability = durability;

  int durabilityPercentage() {
    return (maxDurability / durability * 100).toInt();
  }
}
