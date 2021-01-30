// To parse this JSON data, do
//
//     final filteredWarehouse = filteredWarehouseFromJson(jsonString);

import 'dart:convert';

List<FilteredWarehouse> filteredWarehouseFromJson(String str) => List<FilteredWarehouse>.from(json.decode(str).map((x) => FilteredWarehouse.fromJson(x)));

String filteredWarehouseToJson(List<FilteredWarehouse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FilteredWarehouse {
  FilteredWarehouse({
    this.name,
    this.code,
  });

  String name;
  String code;

  factory FilteredWarehouse.fromJson(Map<String, dynamic> json) => FilteredWarehouse(
    name: json["name"] == null ? null : json["name"],
    code: json["code"] == null ? null : json["code"],
  );

  Map<String, dynamic> toJson() => {
    "name": name == null ? null : name,
    "code": code == null ? null : code,
  };
}
