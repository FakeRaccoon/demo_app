// To parse this JSON data, do
//
//     final provinceResult = provinceResultFromJson(jsonString);

import 'dart:convert';

List<ProvinceResult> provinceResultFromJson(String str) => List<ProvinceResult>.from(json.decode(str).map((x) => ProvinceResult.fromJson(x)));

String provinceResultToJson(List<ProvinceResult> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProvinceResult {
  ProvinceResult({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String name;
  DateTime createdAt;
  DateTime updatedAt;

  factory ProvinceResult.fromJson(Map<String, dynamic> json) => ProvinceResult(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
  };
}
