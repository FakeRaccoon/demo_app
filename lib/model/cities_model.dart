// To parse this JSON data, do
//
//     final city = cityFromJson(jsonString);

import 'dart:convert';

City cityFromJson(String str) => City.fromJson(json.decode(str));

String cityToJson(City data) => json.encode(data.toJson());

class City {
  City({
    this.status,
    this.message,
    this.totalData,
    this.result,
  });

  int status;
  String message;
  int totalData;
  List<Result> result;

  factory City.fromJson(Map<String, dynamic> json) => City(
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
    this.provinceId,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String provinceId;
  String name;
  DateTime createdAt;
  DateTime updatedAt;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    provinceId: json["province_id"],
    name: json["name"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "province_id": provinceId,
    "name": name,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
