// To parse this JSON data, do
//
//     final logResult = logResultFromJson(jsonString);

import 'dart:convert';

List<LogResult> logResultFromJson(String str) => List<LogResult>.from(json.decode(str).map((x) => LogResult.fromJson(x)));

String logResultToJson(List<LogResult> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LogResult {
  LogResult({
    this.id,
    this.activity,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String activity;
  DateTime createdAt;
  DateTime updatedAt;

  factory LogResult.fromJson(Map<String, dynamic> json) => LogResult(
    id: json["id"] == null ? null : json["id"],
    activity: json["activity"] == null ? null : json["activity"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "activity": activity == null ? null : activity,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
  };
}
