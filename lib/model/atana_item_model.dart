// To parse this JSON data, do
//
//     final atanaItemResult = atanaItemResultFromJson(jsonString);

import 'dart:convert';

List<AtanaItemResult> atanaItemResultFromJson(String str) => List<AtanaItemResult>.from(json.decode(str).map((x) => AtanaItemResult.fromJson(x)));

String atanaItemResultToJson(List<AtanaItemResult> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AtanaItemResult {
  AtanaItemResult({
    this.itemId,
    this.unitMeasureId,
    this.itemCode,
    this.itemName,
    this.itemAlias,
    this.salesCategoryId,
    this.flagInactive,
    this.itemCategoryId,
    this.itemGroup1Id,
    this.itemGroup2Id,
    this.itemGroup3Id,
    this.statusSalesPricing,
    this.description,
    this.lastUpdate,
    this.itemImage,
    this.itemMeasureConversion,
    this.itemMeasurement,
    this.itemCategory,
    this.itemGroup1,
    this.itemGroup2,
    this.itemGroup3,
    this.unitMeasure,
  });

  dynamic itemId;
  dynamic unitMeasureId;
  String itemCode;
  String itemName;
  String itemAlias;
  dynamic salesCategoryId;
  String flagInactive;
  dynamic itemCategoryId;
  dynamic itemGroup1Id;
  dynamic itemGroup2Id;
  dynamic itemGroup3Id;
  String statusSalesPricing;
  String description;
  DateTime lastUpdate;
  dynamic itemImage;
  dynamic itemMeasureConversion;
  dynamic itemMeasurement;
  dynamic itemCategory;
  dynamic itemGroup1;
  dynamic itemGroup2;
  dynamic itemGroup3;
  dynamic unitMeasure;

  factory AtanaItemResult.fromJson(Map<String, dynamic> json) => AtanaItemResult(
    itemId: json["itemId"] == null ? null : json["itemId"],
    unitMeasureId: json["unitMeasureId"] == null ? null : json["unitMeasureId"],
    itemCode: json["itemCode"] == null ? null : json["itemCode"],
    itemName: json["itemName"] == null ? null : json["itemName"],
    itemAlias: json["itemAlias"] == null ? null : json["itemAlias"],
    salesCategoryId: json["salesCategoryId"] == null ? null : json["salesCategoryId"],
    flagInactive: json["flagInactive"] == null ? null : json["flagInactive"],
    itemCategoryId: json["itemCategoryId"] == null ? null : json["itemCategoryId"],
    itemGroup1Id: json["itemGroup1Id"] == null ? null : json["itemGroup1Id"],
    itemGroup2Id: json["itemGroup2Id"] == null ? null : json["itemGroup2Id"],
    itemGroup3Id: json["itemGroup3Id"] == null ? null : json["itemGroup3Id"],
    statusSalesPricing: json["statusSalesPricing"] == null ? null : json["statusSalesPricing"],
    description: json["description"] == null ? null : json["description"],
    lastUpdate: json["lastUpdate"] == null ? null : DateTime.parse(json["lastUpdate"]),
    itemImage: json["itemImage"],
    itemMeasureConversion: json["itemMeasureConversion"],
    itemMeasurement: json["itemMeasurement"],
    itemCategory: json["itemCategory"],
    itemGroup1: json["itemGroup1"],
    itemGroup2: json["itemGroup2"],
    itemGroup3: json["itemGroup3"],
    unitMeasure: json["unitMeasure"],
  );

  Map<String, dynamic> toJson() => {
    "itemId": itemId == null ? null : itemId,
    "unitMeasureId": unitMeasureId == null ? null : unitMeasureId,
    "itemCode": itemCode == null ? null : itemCode,
    "itemName": itemName == null ? null : itemName,
    "itemAlias": itemAlias == null ? null : itemAlias,
    "salesCategoryId": salesCategoryId == null ? null : salesCategoryId,
    "flagInactive": flagInactive == null ? null : flagInactive,
    "itemCategoryId": itemCategoryId == null ? null : itemCategoryId,
    "itemGroup1Id": itemGroup1Id == null ? null : itemGroup1Id,
    "itemGroup2Id": itemGroup2Id == null ? null : itemGroup2Id,
    "itemGroup3Id": itemGroup3Id == null ? null : itemGroup3Id,
    "statusSalesPricing": statusSalesPricing == null ? null : statusSalesPricing,
    "description": description == null ? null : description,
    "lastUpdate": lastUpdate == null ? null : lastUpdate.toIso8601String(),
    "itemImage": itemImage,
    "itemMeasureConversion": itemMeasureConversion,
    "itemMeasurement": itemMeasurement,
    "itemCategory": itemCategory,
    "itemGroup1": itemGroup1,
    "itemGroup2": itemGroup2,
    "itemGroup3": itemGroup3,
    "unitMeasure": unitMeasure,
  };
}
