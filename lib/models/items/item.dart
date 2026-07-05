import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Item {
  String itemName;
  int count;
  List<String> tags;

  Item({required this.itemName, required this.count, required this.tags});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'itemName': itemName,
      'count': count,
      'tags': tags,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      itemName: map['itemName'] as String,
      count: map['count'] as int,
      tags: List<String>.from((map['tags'] as List<String>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory Item.fromJson(String source) =>
      Item.fromMap(json.decode(source) as Map<String, dynamic>);
}
