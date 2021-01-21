// To parse this JSON data, do
//
//     final notificationResult = notificationResultFromJson(jsonString);

import 'dart:convert';

List<NotificationResult> notificationResultFromJson(String str) => List<NotificationResult>.from(json.decode(str).map((x) => NotificationResult.fromJson(x)));

String notificationResultToJson(List<NotificationResult> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NotificationResult {
  NotificationResult({
    this.id,
    this.userId,
    this.user,
    this.title,
    this.content,
    this.read,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int userId;
  User user;
  String title;
  String content;
  bool read;
  DateTime createdAt;
  DateTime updatedAt;

  factory NotificationResult.fromJson(Map<String, dynamic> json) => NotificationResult(
    id: json["id"] == null ? null : json["id"],
    userId: json["user_id"] == null ? null : json["user_id"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    title: json["title"] == null ? null : json["title"],
    content: json["content"] == null ? null : json["content"],
    read: json["read"] == null ? null : json["read"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "user_id": userId == null ? null : userId,
    "user": user == null ? null : user.toJson(),
    "title": title == null ? null : title,
    "content": content == null ? null : content,
    "read": read == null ? null : read,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
  };
}

class User {
  User({
    this.id,
    this.name,
    this.username,
    this.role,
    this.selected,
  });

  int id;
  String name;
  String username;
  String role;
  bool selected;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    username: json["username"] == null ? null : json["username"],
    role: json["role"] == null ? null : json["role"],
    selected: json["selected"] == null ? null : json["selected"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "username": username == null ? null : username,
    "role": role == null ? null : role,
    "selected": selected == null ? null : selected,
  };
}
