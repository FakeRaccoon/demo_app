// To parse this JSON data, do
//
//     final cityResult = cityResultFromJson(jsonString);

import 'dart:convert';

List<CityResult> cityResultFromJson(String str) =>
    List<CityResult>.from(json.decode(str).map((x) => CityResult.fromJson(x)));

String cityResultToJson(List<CityResult> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CityResult {
  CityResult({
    this.id,
    this.provinceId,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int provinceId;
  String name;
  DateTime createdAt;
  DateTime updatedAt;

  factory CityResult.fromJson(Map<String, dynamic> json) => CityResult(
        id: json["id"] == null ? null : json["id"],
        provinceId: json["province_id"] == null ? null : json["province_id"],
        name: json["name"] == null ? null : json["name"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "province_id": provinceId == null ? null : provinceId,
        "name": name == null ? null : name,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
      };
}
