import 'dart:convert';

import 'package:atana/service/api.dart';
import 'package:http/http.dart' as http;

class PostResult {
  PostResult({
    this.provinceId,
    this.cityId,
    this.userId,
    this.itemId,
    this.requestDate,
    this.type,
    this.status,
  });

  int provinceId;
  int cityId;
  int userId;
  int itemId;
  DateTime requestDate;
  int type;
  int status;

  factory PostResult.fromJson(Map<String, dynamic> json) {
    return PostResult(
      provinceId: json["province_id"],
      cityId: json["city_id"],
      userId: json["user_id"],
      itemId: json["item_id"],
      type: json["type"],
      status: json["status"],
    );
  }

  static final url = 'https://service.indofarm.id/api/form/create';
  static final baseUrl = 'https://service.indofarm.id/api/form';
  static Future<PostResult> postApi(
      provinceId, cityId, districtId, itemId, reqDate, type) async {
    final http.Response response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'username': 'amt',
          'password': 'kedungdoro',
          'token': token
        },
        body: jsonEncode({
          "province_id": provinceId,
          "city_id": cityId,
          "district_id": districtId,
          "user_id": 1,
          "item_id": itemId,
          'request_date': reqDate,
          "type": type,
          "status": 1
        }));
    if (response.statusCode == 201) {
      print(response.body);
    }
    if (response.statusCode == 200) {
      print(response.body);
      print('post Ok');
    }
  }

  static Future<List<PostResult>> getPostResult() async {
    final response = await http.get(baseUrl, headers: {
      'username': 'amt',
      'password': 'kedungdoro',
      'token': token,
    });
    if (response.statusCode == 200) {
      print('Ok');
      // Map<String, dynamic> map = json.decode(response.body);
      // List<dynamic> data = map["result"];
      final Map parsed = json.decode(response.body);
      var responseJson = json.decode(response.body);
      return (responseJson['result'] as List)
          .map((e) => PostResult.fromJson(e))
          .toList();
      // return provinceFromJson(response.body);
    }
  }
}
