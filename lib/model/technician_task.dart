// To parse this JSON data, do
//
//     final technicianResult = technicianResultFromJson(jsonString);

import 'dart:convert';

List<TechnicianResult> technicianResultFromJson(String str) => List<TechnicianResult>.from(json.decode(str).map((x) => TechnicianResult.fromJson(x)));

String technicianResultToJson(List<TechnicianResult> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TechnicianResult {
  TechnicianResult({
    this.id,
    this.formId,
    this.name,
    this.task,
    this.warehouse,
    this.depart,
    this.technicianResultReturn,
    this.confirmed,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String formId;
  String name;
  String task;
  String warehouse;
  DateTime depart;
  DateTime technicianResultReturn;
  bool confirmed;
  DateTime createdAt;
  DateTime updatedAt;

  factory TechnicianResult.fromJson(Map<String, dynamic> json) => TechnicianResult(
    id: json["id"] == null ? null : json["id"],
    formId: json["form_id"] == null ? null : json["form_id"],
    name: json["name"] == null ? null : json["name"],
    task: json["task"] == null ? null : json["task"],
    warehouse: json["warehouse"] == null ? null : json["warehouse"],
    depart: json["depart"] == null ? null : DateTime.parse(json["depart"]),
    technicianResultReturn: json["return"] == null ? null : DateTime.parse(json["return"]),
    confirmed: json["confirmed"] == null ? null : json["confirmed"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "form_id": formId == null ? null : formId,
    "name": name == null ? null : name,
    "task": task == null ? null : task,
    "warehouse": warehouse == null ? null : warehouse,
    "depart": depart == null ? null : depart.toIso8601String(),
    "return": technicianResultReturn == null ? null : technicianResultReturn.toIso8601String(),
    "confirmed": confirmed == null ? null : confirmed,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
  };
}
