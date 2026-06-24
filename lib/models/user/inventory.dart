// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_gregtext_game/models/items/item.dart';
import 'package:flutter_gregtext_game/models/items/tools/tool.dart';

class Inventory {
  List<Item> inventory;

  Inventory({required this.inventory});

  bool hasItem(String name, {int? count}) {
    if (inventory.isEmpty) return false;
    if (count == null) {
      return inventory.any((item) => item.itemName == name);
    }
    return inventory.any((item) => item.itemName == name && item.count > count);
  }

  void addItem(Item newItem) {
    if (newItem is Tool) {
      inventory.add(newItem);
    } else {
      final existingIndex = inventory.indexWhere(
        (item) => item.itemName == newItem.itemName,
      );

      if (existingIndex != -1) {
        inventory[existingIndex].count += newItem.count;
      } else {
        inventory.add(newItem);
      }
    }
  }

  void addItems(List<Item> items) {
    items.forEach(addItem);
  }

  void removeItem(Item item) {}
  void removeItems(List<Item> items) {}
  void craft(List<Item> input, List<Item> output) {
    removeItems(input);
    addItems(output);
  }
}
