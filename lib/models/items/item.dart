import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Item {
  String itemName;
  int count;
  List<String> tags;
  // use for sorting a filtering in inventory
  String iventoryType;

  Item({
    required this.itemName,
    required this.count,
    required this.tags,
    required this.iventoryType,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'itemName': itemName,
      'count': count,
      'tags': tags,
      'iventoryType': iventoryType,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      itemName: map['itemName'] as String,
      count: map['count'] as int,
      tags: List<String>.from((map['tags'] as List<dynamic>)),
      iventoryType: map['iventoryType'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Item.fromJson(String source) =>
      Item.fromMap(json.decode(source) as Map<String, dynamic>);
}
