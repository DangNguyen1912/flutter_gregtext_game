import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Area {
  String name;
  Area({required this.name});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'name': name};
  }

  factory Area.fromMap(Map<String, dynamic> map) {
    return Area(name: map['name'] as String? ?? '');
  }

  String toJson() => json.encode(toMap());

  factory Area.fromJson(String source) =>
      Area.fromMap(json.decode(source) as Map<String, dynamic>);
}
