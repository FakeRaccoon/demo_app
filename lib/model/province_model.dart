// To parse this JSON data, do
//
//     final province = provinceFromJson(jsonString);

import 'dart:convert';

Province provinceFromJson(String str) => Province.fromJson(json.decode(str));

String provinceToJson(Province data) => json.encode(data.toJson());

class Province {
  Province({
    this.status,
    this.message,
    this.totalData,
    this.result,
  });

  int status;
  String message;
  int totalData;
  List<Result> result;

  factory Province.fromJson(Map<String, dynamic> json) => Province(
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
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String name;
  DateTime createdAt;
  DateTime updatedAt;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    name: json["name"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
