// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter_gregtext_game/models/items/item.dart';

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
    final existingIndex = inventory.indexWhere(
      (item) => item.itemName == newItem.itemName,
    );

    if (existingIndex != -1) {
      inventory[existingIndex].count += newItem.count;
    } else {
      inventory.add(newItem);
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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'inventory': inventory.map((x) => x.toMap()).toList(),
    };
  }

  factory Inventory.fromMap(Map<String, dynamic> map) {
    final inventoryList = map['inventory'] as List<dynamic>;

    return Inventory(
      inventory: inventoryList
          .map<Item>((x) => Item.fromMap(x as Map<String, dynamic>))
          .toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Inventory.fromJson(String source) =>
      Inventory.fromMap(json.decode(source) as Map<String, dynamic>);
}
