// To parse this JSON data, do
//
//     final districtResult = districtResultFromJson(jsonString);

import 'dart:convert';

List<DistrictResult> districtResultFromJson(String str) => List<DistrictResult>.from(json.decode(str).map((x) => DistrictResult.fromJson(x)));

String districtResultToJson(List<DistrictResult> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DistrictResult {
  DistrictResult({
    this.id,
    this.cityId,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int cityId;
  String name;
  DateTime createdAt;
  DateTime updatedAt;

  factory DistrictResult.fromJson(Map<String, dynamic> json) => DistrictResult(
    id: json["id"] == null ? null : json["id"],
    cityId: json["city_id"] == null ? null : int.parse(json["city_id"]),
    name: json["name"] == null ? null : json["name"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "city_id": cityId == null ? null : cityId,
    "name": name == null ? null : name,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
  };
}
