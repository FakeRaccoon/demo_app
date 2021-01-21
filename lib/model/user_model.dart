// To parse this JSON data, do
//
//     final userResult = userResultFromJson(jsonString);

import 'dart:convert';

List<UserResult> userResultFromJson(String str) => List<UserResult>.from(json.decode(str).map((x) => UserResult.fromJson(x)));

String userResultToJson(List<UserResult> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserResult {
  UserResult({
    this.id,
    this.name,
    this.username,
    this.role,
    this.selected,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String name;
  String username;
  String role;
  bool selected;
  DateTime createdAt;
  DateTime updatedAt;

  factory UserResult.fromJson(Map<String, dynamic> json) => UserResult(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    username: json["username"] == null ? null : json["username"],
    role: json["role"] == null ? null : json["role"],
    selected: json["selected"] == null ? null : json["selected"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "username": username == null ? null : username,
    "role": role == null ? null : role,
    "selected": selected == null ? null : selected,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
  };
}
