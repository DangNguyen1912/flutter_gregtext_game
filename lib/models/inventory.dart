// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_gregtext_game/models/item.dart';

class Inventory {
  List<Item> inventory;

  Inventory({required this.inventory});

  void addItem(Item item) {}
  void addItems(List<Item> item) {}
  void removeItem(Item item) {}
  void removeItems(List<Item> item) {}
  void craft(List<Item> input, List<Item> output) {
    removeItems(input);
    addItems(output);
  }
}
