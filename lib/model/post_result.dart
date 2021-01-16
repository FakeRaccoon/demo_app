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

  static final url = 'http://10.0.2.2:8000/api/form/create';
  static final baseUrl = 'https://service.indofarm.id/api/form';
  static Future postApi() async {
    final http.Response response = await http.post(url, body: jsonEncode({
      "province": "Jawa Timur",
      "city": "Batu",
      "item": "Dafeng",
      "user": "Aliali",
      "status": 3,
      "type": 2,
      "estimated_date": "2020-12-22 07:34:04"
    }));
    if (response.statusCode == 201) {
      print(response.body);
    }
    if (response.statusCode == 200) {
      print(response.body);
      print('post Ok');
    }
  }

  static Future getPostResult() async {
    final response = await http.get(baseUrl, headers: auth);
    if (response.statusCode == 200) {
      print('Ok');
      final decoded = jsonDecode(response.body);
      List parsed = decoded['result'];
      return parsed.map((e) => PostResult.fromJson(e)).toList();
    }
  }
}
