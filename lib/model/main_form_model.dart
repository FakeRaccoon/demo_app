// To parse this JSON data, do
//
//     final mainForm = mainFormFromJson(jsonString);

import 'dart:convert';

List<MainForm> mainFormFromJson(String str) => List<MainForm>.from(json.decode(str).map((x) => MainForm.fromJson(x)));

String mainFormToJson(List<MainForm> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MainForm {
  MainForm({
    this.id,
    this.province,
    this.city,
    this.district,
    this.userName,
    this.itemName,
    this.status,
    this.type,
    this.estimatedDate,
  });

  final int id;
  final String province;
  final String city;
  final String district;
  final String userName;
  final String itemName;
  final int status;
  final int type;
  final DateTime estimatedDate;

  factory MainForm.fromJson(Map<String, dynamic> json) => MainForm(
    id: json["id"],
    province: json["province"],
    city: json["city"],
    district: json["district"],
    userName: json["user_name"],
    itemName: json["item_name"],
    status: json["status"],
    type: json["type"],
    estimatedDate: DateTime.parse(json["estimated_date"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "province": province,
    "city": city,
    "district": district,
    "user_name": userName,
    "item_name": itemName,
    "status": status,
    "type": type,
    "estimated_date": estimatedDate.toIso8601String(),
  };
}
