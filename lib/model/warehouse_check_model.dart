// To parse this JSON data, do
//
//     final warehouseCheckResult = warehouseCheckResultFromJson(jsonString);

import 'dart:convert';

List<WarehouseCheckResult> warehouseCheckResultFromJson(String str) => List<WarehouseCheckResult>.from(json.decode(str).map((x) => WarehouseCheckResult.fromJson(x)));

String warehouseCheckResultToJson(List<WarehouseCheckResult> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WarehouseCheckResult {
  WarehouseCheckResult({
    this.itemId,
    this.warehouseId,
    this.qtyReadyBalance,
  });

  dynamic itemId;
  dynamic warehouseId;
  dynamic qtyReadyBalance;

  factory WarehouseCheckResult.fromJson(Map<String, dynamic> json) => WarehouseCheckResult(
    itemId: json["itemId"] == null ? null : json["itemId"],
    warehouseId: json["warehouseId"] == null ? null : json["warehouseId"],
    qtyReadyBalance: json["qtyReadyBalance"] == null ? null : json["qtyReadyBalance"],
  );

  Map<String, dynamic> toJson() => {
    "itemId": itemId == null ? null : itemId,
    "warehouseId": warehouseId == null ? null : warehouseId,
    "qtyReadyBalance": qtyReadyBalance == null ? null : qtyReadyBalance,
  };
}
