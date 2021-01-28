// To parse this JSON data, do
//
//     final warehouse = warehouseFromJson(jsonString);

import 'dart:convert';

List<Warehouse> warehouseFromJson(String str) => List<Warehouse>.from(json.decode(str).map((x) => Warehouse.fromJson(x)));

String warehouseToJson(List<Warehouse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Warehouse {
  Warehouse({
    this.warehouseId,
    this.warehouseCode,
    this.warehouseName,
    this.flagSaleWarehouse,
    this.flagInactive,
  });

  int warehouseId;
  String warehouseCode;
  String warehouseName;
  String flagSaleWarehouse;
  String flagInactive;

  factory Warehouse.fromJson(Map<String, dynamic> json) => Warehouse(
    warehouseId: json["warehouseId"] == null ? null : json["warehouseId"],
    warehouseCode: json["warehouseCode"] == null ? null : json["warehouseCode"],
    warehouseName: json["warehouseName"] == null ? null : json["warehouseName"],
    flagSaleWarehouse: json["flagSaleWarehouse"] == null ? null : json["flagSaleWarehouse"],
    flagInactive: json["flagInactive"] == null ? null : json["flagInactive"],
  );

  Map<String, dynamic> toJson() => {
    "warehouseId": warehouseId == null ? null : warehouseId,
    "warehouseCode": warehouseCode == null ? null : warehouseCode,
    "warehouseName": warehouseName == null ? null : warehouseName,
    "flagSaleWarehouse": flagSaleWarehouse == null ? null : flagSaleWarehouse,
    "flagInactive": flagInactive == null ? null : flagInactive,
  };
}
