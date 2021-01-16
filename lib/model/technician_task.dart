// To parse this JSON data, do
//
//     final technicianTaskResult = technicianTaskResultFromJson(jsonString);

import 'dart:convert';

List<TechnicianTaskResult> technicianTaskResultFromJson(String str) => List<TechnicianTaskResult>.from(json.decode(str).map((x) => TechnicianTaskResult.fromJson(x)));

String technicianTaskResultToJson(List<TechnicianTaskResult> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TechnicianTaskResult {
  TechnicianTaskResult({
    this.id,
    this.formId,
    this.name,
    this.task,
    this.depart,
    this.technicianTaskResultReturn,
    this.confirmed,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int formId;
  String name;
  String task;
  DateTime depart;
  DateTime technicianTaskResultReturn;
  bool confirmed;
  DateTime createdAt;
  DateTime updatedAt;

  factory TechnicianTaskResult.fromJson(Map<String, dynamic> json) => TechnicianTaskResult(
    id: json["id"] == null ? null : json["id"],
    formId: json["form_id"] == null ? null : json["form_id"],
    name: json["name"] == null ? null : json["name"],
    task: json["task"] == null ? null : json["task"],
    depart: json["depart"] == null ? null : DateTime.parse(json["depart"]),
    technicianTaskResultReturn: json["return"] == null ? null : DateTime.parse(json["return"]),
    confirmed: json["confirmed"] == null ? null : json["confirmed"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "form_id": formId == null ? null : formId,
    "name": name == null ? null : name,
    "task": task == null ? null : task,
    "depart": depart == null ? null : depart.toIso8601String(),
    "return": technicianTaskResultReturn == null ? null : technicianTaskResultReturn.toIso8601String(),
    "confirmed": confirmed == null ? null : confirmed,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
  };
}
