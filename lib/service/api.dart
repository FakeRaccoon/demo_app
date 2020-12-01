import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:atana/model/result.dart';
import 'package:http/http.dart' as http;

const baseUrl = "http://103.56.149.39/amt_api/api/atana_get_item";
const baseDemoUrl = "https://demo.indofarm.id/api/";
const apiKey = "IndofarmSurabaya";

const token =
    'AMTJyr7nBW47pM2AzIL9TP4aQi1u4vrkVRCXjAs9XPgEysqO6UWwMKqJMxe8nd3N3H4qEjrri3ezwVQf0NBoHBTb4tVVyFowQQUq22g3uufhS6a9lC4BkQrJsuf5KQUHyLMTqoHUTyk0W2z1aK5WKB';

const Map<String, String> auth = {
  'username': 'amt',
  'password': 'kedungdoro',
  'token': token,
};

class API {
  static Future getItems() async {
    try {
      final response = await http.get(
        baseUrl,
        headers: {HttpHeaders.authorizationHeader: apiKey},
      );
      if (response.statusCode == 200) {
        print('Items Ok');
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((e) => ItemResult.fromJson(e)).toList();
      } else {
        throw Exception('Error');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<List<ProvinceResult>> getProvinceResult() async {
    final response = await http.get(baseDemoUrl + 'province', headers: auth);
    if (response.statusCode == 200) {
      // Map<String, dynamic> map = json.decode(response.body);
      // List<dynamic> data = map["result"];
      // final Map parsed = json.decode(response.body);
      var responseJson = json.decode(response.body);
      print(responseJson['message']);
      print('Total province : ' + responseJson['total_data'].toString());
      return (responseJson['result'] as List)
          .map((e) => ProvinceResult.fromJson(e))
          .toList();
      // return provinceFromJson(response.body);
    }
  }

  static Future<List<CityResult>> getCityResult(String provinceId) async {
    final response = await http
        .get(baseDemoUrl + 'city?province_id=' + provinceId, headers: auth);
    if (response.statusCode == 200) {
      print('Ok');
      // Map<String, dynamic> map = json.decode(response.body);
      // List<dynamic> data = map["result"];
      // final Map parsed = json.decode(response.body);
      var responseJson = json.decode(response.body);
      print(responseJson['message']);
      print('Total city : ' + responseJson['total_data'].toString());
      return (responseJson['result'] as List)
          .map((e) => CityResult.fromJson(e))
          .toList();
      // return provinceFromJson(response.body);
    }
  }

  static Future<List<DistrictResult>> getDistrictResult(String cityId) async {
    final response = await http.get(baseDemoUrl + 'district?city_id=' + cityId,
        headers: auth);
    if (response.statusCode == 200) {
      print('Ok');
      // Map<String, dynamic> map = json.decode(response.body);
      // List<dynamic> data = map["result"];
      // final Map parsed = json.decode(response.body);
      var responseJson = json.decode(response.body);
      print(responseJson['message']);
      print('Total district : ' + responseJson['total_data'].toString());
      return (responseJson['result'] as List)
          .map((e) => DistrictResult.fromJson(e))
          .toList();
      // return provinceFromJson(response.body);
    }
  }

  // static Future<City> getCity(String provinceId) async {
  //   final response = await http.get(cityUrl + provinceId, headers: {
  //     'username': 'amt',
  //     'password': 'kedungdoro',
  //     'token': token,
  //   });
  //   if (response.statusCode == 200) {
  //     print('city call success');
  //     return cityFromJson(response.body);
  //   }
  // }
  //
  // static Future<District> getDistrict(String cityId) async {
  //   final response = await http.get(districtUrl + cityId, headers: {
  //     'username': 'amt',
  //     'password': 'kedungdoro',
  //     'token': token,
  //   });
  //   if (response.statusCode == 200) {
  //     print('Ok');
  //     return districtFromJson(response.body);
  //   }
  // }
}
