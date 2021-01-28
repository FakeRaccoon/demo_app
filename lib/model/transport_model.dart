// To parse this JSON data, do
//
//     final transportResult = transportResultFromJson(jsonString);

import 'dart:convert';

List<TransportResult> transportResultFromJson(String str) => List<TransportResult>.from(json.decode(str).map((x) => TransportResult.fromJson(x)));

String transportResultToJson(List<TransportResult> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TransportResult {
  TransportResult({
    this.id,
    this.name,
    this.platNo,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String name;
  String platNo;
  DateTime createdAt;
  DateTime updatedAt;

  factory TransportResult.fromJson(Map<String, dynamic> json) => TransportResult(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    platNo: json["plat_no"] == null ? null : json["plat_no"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "plat_no": platNo == null ? null : platNo,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
  };
}
