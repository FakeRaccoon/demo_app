// To parse this JSON data, do
//
//     final coa = coaFromJson(jsonString);

import 'dart:convert';

List<Coa> coaFromJson(String str) => List<Coa>.from(json.decode(str).map((x) => Coa.fromJson(x)));

String coaToJson(List<Coa> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Coa {
  Coa({
    this.coaId,
    this.coaCode,
    this.coaName,
    this.coaCategoryId,
  });

  int coaId;
  String coaCode;
  String coaName;
  int coaCategoryId;

  factory Coa.fromJson(Map<String, dynamic> json) => Coa(
        coaId: json["coaId"] == null ? null : json["coaId"],
        coaCode: json["coaCode"] == null ? null : json["coaCode"],
        coaName: json["coaName"] == null ? null : json["coaName"],
        coaCategoryId: json["coaCategoryId"] == null ? null : json["coaCategoryId"],
      );

  Map<String, dynamic> toJson() => {
        "coaId": coaId == null ? null : coaId,
        "coaCode": coaCode == null ? null : coaCode,
        "coaName": coaName == null ? null : coaName,
        "coaCategoryId": coaCategoryId == null ? null : coaCategoryId,
      };
}
