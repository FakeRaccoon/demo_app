// To parse this JSON data, do
//
//     final userJson = userJsonFromJson(jsonString);

import 'dart:convert';

UserJson userJsonFromJson(String str) => UserJson.fromJson(json.decode(str));

String userJsonToJson(UserJson data) => json.encode(data.toJson());

class UserJson {
  UserJson({
    this.token,
  });

  Token token;

  factory UserJson.fromJson(Map<String, dynamic> json) => UserJson(
    token: Token.fromJson(json["token"]),
  );

  Map<String, dynamic> toJson() => {
    "token": token.toJson(),
  };
}

class Token {
  Token({
    this.tokenKey,
    this.validFrom,
    this.validTo,
    this.userName,
  });

  String tokenKey;
  DateTime validFrom;
  DateTime validTo;
  String userName;

  factory Token.fromJson(Map<String, dynamic> json) => Token(
    tokenKey: json["tokenKey"],
    validFrom: DateTime.parse(json["validFrom"]),
    validTo: DateTime.parse(json["validTo"]),
    userName: json["userName"],
  );

  Map<String, dynamic> toJson() => {
    "tokenKey": tokenKey,
    "validFrom": validFrom.toIso8601String(),
    "validTo": validTo.toIso8601String(),
    "userName": userName,
  };
}
