// To parse this JSON data, do
//
//     final technician = technicianFromJson(jsonString);

import 'dart:convert';

List<Technician> technicianFromJson(String str) => List<Technician>.from(json.decode(str).map((x) => Technician.fromJson(x)));

String technicianToJson(List<Technician> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Technician {
  Technician({
    this.id,
    this.formId,
    this.name,
    this.username,
    this.task,
    this.warehouse,
    this.depart,
    this.technicianReturn,
    this.confirmed,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int formId;
  String name;
  String username;
  String task;
  String warehouse;
  DateTime depart;
  DateTime technicianReturn;
  bool confirmed;
  DateTime createdAt;
  DateTime updatedAt;

  factory Technician.fromJson(Map<String, dynamic> json) => Technician(
    id: json["id"] == null ? null : json["id"],
    formId: json["form_id"] == null ? null : json["form_id"],
    name: json["name"] == null ? null : json["name"],
    username: json["username"] == null ? null : json["username"],
    task: json["task"] == null ? null : json["task"],
    warehouse: json["warehouse"] == null ? null : json["warehouse"],
    depart: json["depart"] == null ? null : DateTime.parse(json["depart"]),
    technicianReturn: json["return"] == null ? null : DateTime.parse(json["return"]),
    confirmed: json["confirmed"] == null ? null : json["confirmed"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "form_id": formId == null ? null : formId,
    "name": name == null ? null : name,
    "username": username == null ? null : username,
    "task": task == null ? null : task,
    "warehouse": warehouse == null ? null : warehouse,
    "depart": depart == null ? null : depart.toIso8601String(),
    "return": technicianReturn == null ? null : technicianReturn.toIso8601String(),
    "confirmed": confirmed == null ? null : confirmed,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
  };
}
