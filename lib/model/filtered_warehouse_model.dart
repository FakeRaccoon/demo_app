// To parse this JSON data, do
//
//     final filteredWarehouse = filteredWarehouseFromJson(jsonString);

import 'dart:convert';

List<FilteredWarehouse> filteredWarehouseFromJson(String str) => List<FilteredWarehouse>.from(json.decode(str).map((x) => FilteredWarehouse.fromJson(x)));

String filteredWarehouseToJson(List<FilteredWarehouse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FilteredWarehouse {
  FilteredWarehouse({
    this.id,
    this.name,
    this.code,
    this.stock,
  });

  int id;
  String name;
  String code;
  int stock;

  factory FilteredWarehouse.fromJson(Map<String, dynamic> json) => FilteredWarehouse(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    code: json["code"] == null ? null : json["code"],
    stock: json["stock"] == null ? null : json["stock"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "code": code == null ? null : code,
    "stock": stock == null ? null : stock,
  };
}
