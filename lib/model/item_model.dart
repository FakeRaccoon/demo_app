// To parse this JSON data, do
//
//     final itemResult = itemResultFromJson(jsonString);

import 'dart:convert';

List<ItemResult> itemResultFromJson(String str) => List<ItemResult>.from(json.decode(str).map((x) => ItemResult.fromJson(x)));

String itemResultToJson(List<ItemResult> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ItemResult {
  ItemResult({
    this.id,
    this.atanaItemId,
    this.atanaName,
    this.atanaAlias,
  });

  int id;
  int atanaItemId;
  String atanaName;
  String atanaAlias;

  factory ItemResult.fromJson(Map<String, dynamic> json) => ItemResult(
    id: json["id"] == null ? null : json["id"],
    atanaItemId: json["atanaItemId"] == null ? null : json["atanaItemId"],
    atanaName: json["atanaName"] == null ? null : json["atanaName"],
    atanaAlias: json["atanaAlias"] == null ? null : json["atanaAlias"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "atanaItemId": atanaItemId == null ? null : atanaItemId,
    "atanaName": atanaName == null ? null : atanaName,
    "atanaAlias": atanaAlias == null ? null : atanaAlias,
  };
}
