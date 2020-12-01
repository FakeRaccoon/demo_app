// To parse this JSON data, do
//
//     final district = districtFromJson(jsonString);

import 'dart:convert';

District districtFromJson(String str) => District.fromJson(json.decode(str));

String districtToJson(District data) => json.encode(data.toJson());

class District {
  District({
    this.status,
    this.message,
    this.totalData,
    this.result,
  });

  int status;
  String message;
  int totalData;
  List<Result> result;

  factory District.fromJson(Map<String, dynamic> json) => District(
    status: json["status"],
    message: json["message"],
    totalData: json["total_data"],
    result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "total_data": totalData,
    "result": List<dynamic>.from(result.map((x) => x.toJson())),
  };
}

class Result {
  Result({
    this.id,
    this.cityId,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String cityId;
  String name;
  DateTime createdAt;
  DateTime updatedAt;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    cityId: json["city_id"],
    name: json["name"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "city_id": cityId,
    "name": name,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
